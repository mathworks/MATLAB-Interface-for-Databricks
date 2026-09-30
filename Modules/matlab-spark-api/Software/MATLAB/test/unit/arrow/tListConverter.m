classdef tListConverter < hConverter
%TLISTCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedListArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        ListType = {...
                struct(ArrowType=py.pyarrow.list_(py.pyarrow.float64()), OffsetType="int32"),...
                struct(ArrowType=py.pyarrow.large_list(py.pyarrow.float64()), OffsetType="int64")...
            }
    end

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function initializeConverter(testCase, ListType)
            import matlab.internal.arrow.*
            childConverter = ChunkedFloatingArrayConverter("double");
            testCase.Converter = ChunkedListArrayConverter(ListType.OffsetType, childConverter);
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData(ListType)
            listType = ListType.ArrowType;
            ConverterTestData.ZeroChunks = createZeroChunks(listType);
            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(listType);
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(listType);
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(listType);
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(listType);
            ConverterTestData.MultipleChunks = createMultipleChunks(listType);
            ConverterTestData.MultipleChunksWithOneEmptyChunk = createMultipleChunksWithOneEmptyChunk(listType);
        end
    end


end

function testdata = createZeroChunks(listType)
    array = py.pyarrow.chunked_array({}, pyargs("type", listType));
    testdata = struct(Array=array, Expected={cell.empty(0, 1)});
end

function testdata = createOneEmptyChunk(listType)
    array = py.pyarrow.array(cell.empty(1, 0), pyargs("type", listType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected={cell.empty(0, 1)});
end

function testdata = createOneChunkNoNulls(listType)
    data = {{1 2 3}, {}, {py.None, 5}, {6, py.None, 8}};
    array = py.pyarrow.array(data, pyargs("type", listType));
    array = py.pyarrow.chunked_array(array);
    expected = {[1 2 3]; double.empty(1, 0); [NaN 5]; [6 NaN 8]};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneChunkWithNulls(listType)
    data = {py.None, {1 2 3}, {}, {py.None, 5}, py.None, py.None, {6, py.None, 8}};
    array = py.pyarrow.array(data, pyargs("type", listType));
    array = py.pyarrow.chunked_array(array);
    expected = {missing; [1 2 3]; double.empty(1, 0); [NaN 5]; missing; missing; [6 NaN 8]};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createOneChunkOnlyNulls(listType)
    data = repmat({py.None}, [1 10]);
    array = py.pyarrow.array(data, pyargs("type", listType));
    array = py.pyarrow.chunked_array(array);
    expected = repmat({missing}, [10 1]);
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createMultipleChunks(listType)
    data = {py.None, {1 2 3}, {}, {py.None, 5}, py.None, {6, py.None, 8}, ...
            {9, 10, 11, 12}, {13}, py.None, {14, py.None, 16}};
    array = py.pyarrow.array(data, pyargs("type", listType));
    array1 = array.slice(0, 1);
    array2 = array.slice(1, 6);
    array3 = array.slice(7, 3);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    expected = {missing; [1 2 3]; double.empty(1, 0); [NaN 5]; missing; ...
        [6 NaN 8]; [9 10 11 12]; 13; missing; [14 NaN 16]};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = createMultipleChunksWithOneEmptyChunk(listType)
    data = {{1 2 3}, py.None, {4, 5, 6}, {7 NaN 9 10 NaN 12}};
    array = py.pyarrow.array(data, pyargs("type", listType));
    array1 = array.slice(0, 2);
    array2 = array.slice(2, 0);
    array3 = array.slice(2, 2);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    expected = {[1 2 3]; missing; [4 5 6]; [7 NaN 9 10 NaN 12]};
    testdata = struct(Array=array, Expected={expected});
end
