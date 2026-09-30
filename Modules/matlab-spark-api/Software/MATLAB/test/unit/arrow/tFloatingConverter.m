classdef tFloatingConverter < hConverter
%TFLOATINGONVERTER Contains unit tests for
% matlab.internal.arrow.ChunkedFloatingArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        FloatingType = {...
                {'double' py.pyarrow.float64()},...
                {'single' py.pyarrow.float32()},...
            }
    end

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function initializeConverter(testCase, FloatingType)
            import matlab.internal.arrow.ChunkedFloatingArrayConverter
            testCase.Converter = ChunkedFloatingArrayConverter(FloatingType{1});
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData(FloatingType)
            
            ConverterTestData = struct();

            matlabType = FloatingType{1};
            arrowType = FloatingType{2};
            
            ConverterTestData.ZeroChunks = createZeroChunks(arrowType, matlabType);

            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(arrowType, matlabType);
        
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(arrowType, matlabType);
        
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(arrowType, matlabType);
        
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(arrowType, matlabType);

            ConverterTestData.MultipleChunks = createMultipleChunks(arrowType, matlabType);
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

function testdata = createOneChunkOnlyNulls(arrowType, matlabType)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=cast([NaN; NaN], matlabType));
end

function testdata = createOneChunkWithNulls(arrowType, matlabType)
    nullIndices = [3 5];
    expected = cast(1:15, matlabType);
    c = num2cell(expected);
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", arrowType));
    array = py.pyarrow.chunked_array(array);
    expected(nullIndices) = NaN;
    testdata = struct(Array=array, Expected=expected');
end

function testdata = createMultipleChunks(numericType, matlabType)
    vals = cast(1:20, matlabType);
    c = num2cell(vals);
    c([1 5 10 11 21]) = {py.None};
    vals([1 5 10 11 21]) = cast(NaN, matlabType);
    array = py.pyarrow.array(c, pyargs("type", numericType));
    array1 = array.slice(0, 5);
    array2 = array.slice(5, 10);
    array3 = array.slice(15, 6);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    testdata = struct(Array=array, Expected=vals');
end

