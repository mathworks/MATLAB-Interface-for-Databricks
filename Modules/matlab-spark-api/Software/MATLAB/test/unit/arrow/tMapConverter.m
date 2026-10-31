classdef tMapConverter < hConverter
%TMAPCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedMapArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function initializeConverter(testCase)
            import matlab.internal.arrow.*
            keyConverter = ChunkedStringArrayConverter("int32");
            itemConverter = ChunkedFloatingArrayConverter("double");
            testCase.Converter = ChunkedMapArrayConverter(keyConverter, itemConverter);
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData()
            mapType = py.pyarrow.map_(py.pyarrow.utf8(), py.pyarrow.float64());
            S = struct();

            S.ZeroChunks = createZeroChunks(mapType);
            S.OneEmptyChunks = createOneEmptyChunks(mapType);
            S.OneChunkNoNulls = createOneChunkNoNulls();
            S.OneChunkWithNulls = createOneChunkWithNulls();
            S.OneChunkOnlyNulls = createOneChunkOnlyNulls(mapType);
            S.MultipleChunks = createMultipleChunks();

            ConverterTestData = S;
        end
    end
end

function testdata = createZeroChunks(mapType)
    pa = py.importlib.import_module("pyarrow");
    array = pa.chunked_array({}, pyargs("type", mapType));
    expected = cell.empty(0, 1);
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneEmptyChunks(mapType)
    pa = py.importlib.import_module("pyarrow");
    array = pa.array({}, pyargs("type", mapType));
    array = pa.chunked_array({array});
    expected = cell.empty(0, 1);
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneChunkNoNulls()
    pa = py.importlib.import_module("pyarrow");

    keyArray = pa.array({'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'});
    itemArray = pa.array(1:9);
    offsetArray = pa.array(int32([0 3 5 6 6 9]));

    array = pa.MapArray.from_arrays(offsetArray, keyArray, itemArray);
    array = pa.chunked_array({array});

    keys = string(char((65:73)'))';
    values = 1:9;

    expected = {...
                dictionary(keys(1:3), values(1:3));
                dictionary(keys(4:5), values(4:5));
                dictionary(keys(6), values(6));
                dictionary(string.empty(0, 1), double.empty(0, 1));
                dictionary(keys(7:9), values(7:9));
            };

    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneChunkWithNulls()
    pa = py.importlib.import_module("pyarrow");

    keyArray = pa.array({'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'});
    itemArray = pa.array(1:9);
    offsetArray = pa.array(int32([0 2 4 4 8 8 9]));
    nullMask = pa.array([false, false, true, false, false, false]);

    array = pa.MapArray.from_arrays(offsetArray, keyArray, itemArray, ...
        pyargs("mask", nullMask));
    array = pa.chunked_array({array});

    keys = string(char((65:73)'))';
    items = 1:9;

    expected = {...
                dictionary(keys(1:2), items(1:2));
                dictionary(keys(3:4), items(3:4));
                missing;
                dictionary(keys(5:8), items(5:8));
                dictionary(string.empty(0, 1), double.empty(0, 1));
                dictionary(keys(9), items(9));
            };
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneChunkOnlyNulls(mapType)
    pa = py.importlib.import_module("pyarrow");

    array = pa.array({py.None, py.None, py.None}, pyargs("type", mapType));
    array = pa.chunked_array({array});

    expected = {missing; missing; missing};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createMultipleChunks()
    pa = py.importlib.import_module("pyarrow");

    keys = string(char((65:90))')';
    items = 1:26;

    keyArray = pa.array(cellstr(keys));
    itemArray = pa.array(items);

    offsetArray = pa.array(int32([0 2 6 10 10 14 14 16 20 22 22 24 26]));

    nullIndices = false([1 12]);
    nullIndices([4 6 10]) = true;
    nullMask = pa.array(nullIndices);

    array = pa.MapArray.from_arrays(offsetArray, keyArray, itemArray, ...
        pyargs("mask", nullMask));

    array1 = array.slice(0, 5);
    array2 = array.slice(5, 4);
    array3 = array.slice(9, 3);

    array = pa.chunked_array({array1, array2, array3});

    expected = {...
                dictionary(keys(1:2), items(1:2));
                dictionary(keys(3:6), items(3:6));
                dictionary(keys(7:10), items(7:10));
                missing;
                dictionary(keys(11:14), items(11:14));
                missing;
                dictionary(keys(15:16), items(15:16));
                dictionary(keys(17:20), items(17:20));
                dictionary(keys(21:22), items(21:22));
                missing;
                dictionary(keys(23:24), items(23:24));
                dictionary(keys(25:26), items(25:26));
            };
    testdata = struct(Array=array, Expected={expected});
end