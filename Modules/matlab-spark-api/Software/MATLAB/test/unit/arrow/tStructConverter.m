classdef tStructConverter < hConverter
%TSTRUCTCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedStructArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        ConverterTestData
    end


    methods (TestClassSetup)
        function initializeTestData(testCase)
            import matlab.internal.arrow.*
            fieldConverter1 = ChunkedFloatingArrayConverter("double");
            fieldConverter2 = ChunkedStringArrayConverter("int32");
            fieldNames = ["Number" "String"];
            testCase.Converter =  ChunkedStructArrayConverter(fieldNames, [fieldConverter1 fieldConverter2]);
        end
    end

    methods(TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData()

            S = struct();

            field1 = py.pyarrow.field("Number", py.pyarrow.float64());
            field2 = py.pyarrow.field("String", py.pyarrow.utf8());

            structType = py.pyarrow.struct({field1, field2});

            S.ZeroChunks = createZeroChunks(structType);
            S.OneEmptyChunk = createOneEmptyChunk(structType);
            S.OneChunkNoNulls = createOneChunkNoNulls(structType);
            S.OneChunkWithNulls = createOneChunkWithNulls(structType);
            S.OneChunkOnlyNulls = createOneChunkOnlyNulls(structType);
            S.MultipleChunks = createMultipleChunks(structType);
            ConverterTestData = S;
        end
    end

    methods (Test)
        function modifiedFieldNamesWarning(testCase)
            import matlab.internal.arrow.*
            fieldNames = ["A" "A"];
            childConverter = ChunkedFloatingArrayConverter("double");
            fcn = @() ChunkedStructArrayConverter(fieldNames, [childConverter childConverter]);

            id = "sparkapi:ModifiedStructFieldNames";
            converter = testCase.verifyWarning(fcn, id);
            testCase.verifyEqual(converter.FieldNames, ["A", "A_1"]);

            fieldNames = ["1A" "1B"];
            fcn = @() ChunkedStructArrayConverter(fieldNames, [childConverter childConverter]);
            converter = testCase.verifyWarning(fcn, id);
            testCase.verifyEqual(converter.FieldNames, ["x1A", "x1B"]);

        end

        function nestedFields(testCase)
            import matlab.internal.arrow.*

            pa = py.importlib.import_module("pyarrow");

            listArray = pa.array({[1, 2, 3], [4, 5], [6, 7, 8, 9]});
            keys = pa.array({'A', 'B', 'C', 'D', 'E', 'F', 'G'});
            values = pa.array([1, 2, 3, 4, 5, 6, 7]);
            offsets = pa.array(int32([0, 3, 4, 7]));
            mapArray = pa.MapArray.from_arrays(offsets, keys, values);
            structArray = pa.StructArray.from_arrays({listArray, mapArray}, pyargs(names={'List' 'Map'}));

            fieldConverter1 = ChunkedListArrayConverter("int32", ChunkedFloatingArrayConverter("double"));
            fieldConverter2 = ChunkedMapArrayConverter(ChunkedStringArrayConverter("int32"), ChunkedFloatingArrayConverter("double"));

            fieldNames = ["List" "Map"];
            converter = ChunkedStructArrayConverter(fieldNames, [fieldConverter1, fieldConverter2]);

            actual = converter.convert(pa.chunked_array({structArray}));

            expected(1).List = [1, 2 3];
            expected(2).List = [4, 5];
            expected(3).List = [6, 7, 8, 9];

            expected(1).Map = dictionary(["A" "B" "C"], [1, 2 3]);
            expected(2).Map = dictionary("D", 4);
            expected(3).Map = dictionary(["E" "F" "G"], [5, 6, 7]);

            expected = reshape(expected, [], 1);
            testCase.verifyEqual(actual, expected);
        end
    end
end


function testdata = createZeroChunks(structType)
    array = py.pyarrow.chunked_array({}, pyargs("type", structType));
    expected = struct("Number", {}, "String", {});
    testdata = struct(Array=array, Expected=reshape(expected, 0, 1));
end


function testdata = createOneEmptyChunk(structType)
    array = py.pyarrow.array(cell.empty(1, 0), pyargs("type", structType));
    array = py.pyarrow.chunked_array(array);
    expected = struct("Number", {}, "String", {});
    testdata = struct(Array=array, Expected=reshape(expected, 0, 1));
end

function testdata = createOneChunkNoNulls(structType)
    pa = py.importlib.import_module("pyarrow");
    floatArray = pa.array({1, 2, 3, py.None, 5, 6});
    stringArray = pa.array({'A', py.None, 'C', 'D', py.None, 'F'});
    array = pa.StructArray.from_arrays({floatArray, stringArray}, ...
        pyargs("fields", structType.fields));
    array = pa.chunked_array(array);

    number = 1:6;
    number(4) = NaN;
    strs = string(char((65:70)'))';
    strs([2 5]) = missing;

    expected = struct("Number", num2cell(number), "String", num2cell(strs));
    expected = reshape(expected, [], 1);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkWithNulls(structType)
    pa = py.importlib.import_module("pyarrow");
    floatArray = pa.array(1:20);
    stringArray = pa.array(cellstr(string(1:20)));
    nullMask = false([1 20]);
    nullMask([2 5 17]) = true;
    nullBoolArray = pa.array(nullMask);

    array = pa.StructArray.from_arrays({floatArray, stringArray}, ...
        pyargs("fields", structType.fields, "mask", nullBoolArray));
    array = pa.chunked_array(array);

    expected = struct("Number", num2cell(1:20), "String", num2cell(string(1:20)));
    expected = reshape(expected, [], 1);
    expected(nullMask) = struct(Number=missing, String=missing);
    
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkOnlyNulls(structType)
    pa = py.importlib.import_module("pyarrow");
    array = pa.array({py.None py.None py.None}, pyargs("type", structType));
    array = pa.chunked_array({array});
    missingValues = repmat({missing}, [1 3]);
    expected = struct("Number", missingValues, "String", missingValues);
    expected = reshape(expected, [], 1);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createMultipleChunks(structType)
    pa = py.importlib.import_module("pyarrow");
    floatArray = pa.array(1:40);
    stringArray = pa.array(cellstr(string(1:40)));

    nullMask = false([1 40]);
    nullMask([5 7 16 22 36]) = true;
    nullBoolArray = pa.array(nullMask);

    array = pa.StructArray.from_arrays({floatArray, stringArray}, ...
        pyargs("fields", structType.fields, "mask", nullBoolArray));
    array1 = array.slice(0, 10);
    array2 = array.slice(10, 15);
    array3 = array.slice(25, 0);
    array4 = array.slice(25, 7);
    array5 = array.slice(32, 8);

    array = pa.chunked_array({array1, array2, array3, array4, array5});

    number = 1:40;
    strs = string(1:40);
    expected = struct("Number", num2cell(number), "String", num2cell(strs));
    expected = reshape(expected, [], 1);
    expected(nullMask) = struct(Number=missing, String=missing);
    
    testdata = struct(Array=array, Expected=expected);
end
