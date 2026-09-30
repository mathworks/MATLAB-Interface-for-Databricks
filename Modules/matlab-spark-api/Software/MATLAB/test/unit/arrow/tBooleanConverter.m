classdef tBooleanConverter < hConverter
%TBOOLEANCONVERTER Contains unit tests for
% matlab.internal.arrow.ChunkedBooleanArrayConverter.
  
% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        CastToDouble = {true, false}
    end

    properties (TestParameter)
        ConverterTestData
    end


    methods (TestClassSetup)
        function setupConverter(testCase, CastToDouble)
            import matlab.internal.arrow.ChunkedBooleanArrayConverter
            testCase.Converter = ChunkedBooleanArrayConverter(CastToDouble);
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData(CastToDouble)
             boolType = py.pyarrow.bool_();

            ConverterTestData = struct();
        
            ConverterTestData.ZeroChunks = createZeroChunks(boolType);

            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(boolType);
        
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(boolType);
        
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(boolType, CastToDouble);
        
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(boolType, CastToDouble);

            ConverterTestData.MultipleChunks = createMultipleChunks(boolType, CastToDouble);
        end
    end

end

function testdata = createOneEmptyChunk(boolType)
    array = py.pyarrow.array(py.list(), pyargs("type", boolType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=logical.empty(0, 1));
end

function testdata = createZeroChunks(boolType)
    array = py.pyarrow.chunked_array({} , pyargs("type", boolType));
    testdata = struct(Array=array, Expected=logical.empty(0, 1));
end

function testdata = createOneChunkNoNulls(boolType)
    vals = logical(randi(2, [1 20]) - 1);
    array = py.pyarrow.array(vals, pyargs("type", boolType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=vals');
end


function testdata = createOneChunkWithNulls(boolType, castToDouble)
    nullIndices = [5 9];
    vals = logical(randi(2, [1 10]) - 1);
    c = num2cell(vals);
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", boolType));
    array = py.pyarrow.chunked_array(array);
    if castToDouble
        expected = cast(vals, "double");
        expected(nullIndices) = NaN;
    else
        expected = vals;
        expected(nullIndices) = false;
    end

    testdata = struct(Array=array, Expected=expected');
end

function testdata = createOneChunkOnlyNulls(boolType, castToDouble)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", boolType));
    array = py.pyarrow.chunked_array(array);
    if castToDouble
        expected = [NaN; NaN];
    else
        expected = [false; false];
    end

    testdata = struct(Array=array, Expected=expected);
end

function testdata = createMultipleChunks(boolType, castToDouble)
    vals = logical(randi(2, [1 50]) - 1);
    c = num2cell(vals);
    nullIndices = [2 3 7 10 11 16 21 35 44];
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", boolType));
    array1 = array.slice(0, 20);
    array2 = array.slice(20, 16);
    array3 = array.slice(36, 14);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    
    if castToDouble
        expected = cast(vals', "double");
        expected(nullIndices) = NaN;
    else
        expected = vals';
        expected(nullIndices) = false;
    end

    testdata = struct(Array=array, Expected=expected);
end
