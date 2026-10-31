classdef tIntegerConverter < hConverter
%TINTEGERONVERTER Contains unit tests for
% matlab.internal.arrow.ChunkedIntegerArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        CastToDouble = {true, false}
        IntegerType = {...
                {'int8' py.pyarrow.int8()},...
                {'int16' py.pyarrow.int16()},...
                {'int32' py.pyarrow.int32()},...
                {'int64' py.pyarrow.int64()},...
                {'uint8' py.pyarrow.uint8()},...
                {'uint16' py.pyarrow.int16()},...
                {'uint32' py.pyarrow.uint32()},...
                {'uint64' py.pyarrow.uint64()},...
            }
    end

    properties(TestParameter)
        ConverterTestData
    end


    methods (TestClassSetup)
        function setupConverter(testCase, CastToDouble, IntegerType)
            import matlab.internal.arrow.ChunkedIntegerArrayConverter
            testCase.Converter = ChunkedIntegerArrayConverter(IntegerType{1}, CastToDouble);
        end
    end


    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData(CastToDouble, IntegerType)
            
            ConverterTestData = struct();

            matlabType = IntegerType{1};
            arrowType = IntegerType{2};
            
            ConverterTestData.ZeroChunks = createZeroChunks(arrowType, matlabType);

            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(arrowType, matlabType);
        
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(arrowType, matlabType);
        
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(arrowType, matlabType, CastToDouble);

            ConverterTestData.OneChunkOnlyhNulls = createOneChunkOnlyNulls(arrowType, matlabType, CastToDouble);
        
            ConverterTestData.MultipleChunks = createMultipleChunks(arrowType, matlabType, CastToDouble);
        end
    end

end

function testdata = createZeroChunks(arrowType, matlabType)
    array = py.pyarrow.chunked_array({}, pyargs("type", arrowType));
    testdata = struct(Array=array, Expected=cast(double.empty(0, 1), matlabType));
end

function testdata = createOneEmptyChunk(arrowType, matlabType)
    array = py.pyarrow.array(py.list(), pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=cast(double.empty(0, 1), matlabType));
end

function testdata = createOneChunkNoNulls(arrowType, matlabType)
    vals = cast(1:10, matlabType);
    array = py.pyarrow.array(vals, pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=vals');
end

function testdata = createOneChunkOnlyNulls(arrowType, matlabType, castToDouble)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    expected = [NaN; NaN];
    if ~castToDouble
        expected = cast(expected, matlabType);
    end

    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkWithNulls(arrowType, matlabType, castToDouble)
    expected = 1:10;
    nullIndices = [1 5 8];
    expected(nullIndices) = NaN;
    vals = num2cell(cast(expected, matlabType));
    vals(nullIndices) = {py.None};
    
    array = py.pyarrow.array(vals, pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    if ~castToDouble
        expected = cast(expected, matlabType);
    end

    testdata = struct(Array=array, Expected=expected');
end

function testdata = createMultipleChunks(numericType, matlabType, castToDouble)
    expected = 1:30;
    nullIndices = [9 14 20 21 27];
    expected(nullIndices) = NaN;
    c = num2cell(cast(expected, matlabType));
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", numericType));
    array1 = array.slice(0, 5);
    array2 = array.slice(5, 10);
    array3 = array.slice(15, 9);
    array4 = array.slice(24, 7);
    array = py.pyarrow.chunked_array({array1, array2, array3, array4});

    if ~castToDouble
        expected = cast(expected, matlabType);
    end
    testdata = struct(Array=array, Expected=expected');
end
