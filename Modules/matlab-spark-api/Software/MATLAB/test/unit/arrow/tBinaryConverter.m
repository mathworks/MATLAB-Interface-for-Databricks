classdef tBinaryConverter < hConverter
%TBINARYCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedBinaryArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        BinaryType = {...
            struct(ArrowType=py.pyarrow.binary(), OffsetType="int32"),...
            struct(ArrowType=py.pyarrow.large_binary(), OffsetType="int64"),...
        }
    end

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function setUpConverter(testCase, BinaryType)
            import matlab.internal.arrow.ChunkedBinaryArrayConverter
            testCase.Converter = ChunkedBinaryArrayConverter(BinaryType.OffsetType);
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeTConverterTestData(BinaryType)
            binaryType = BinaryType.ArrowType;
            
            ConverterTestData.ZeroChunks = ZeroChunksTestCase(binaryType);

            ConverterTestData.OneEmptyChunk = OneEmptyChunkTestCase(binaryType);

            ConverterTestData.OneChunkZeroNulls = OneChunkZeroNulls(binaryType);

            ConverterTestData.OneChunkWithNulls = OneChunkWithNulls(binaryType);

            ConverterTestData.MultipleChunks = MultipleChunks(binaryType);
        end

    end

end

function testdata = ZeroChunksTestCase(binaryType)
    array = py.pyarrow.chunked_array({}, pyargs("type", binaryType));
    expected = cell.empty(0, 1);
    testdata = struct(Array=array, Expected={expected});
end

function testdata = OneEmptyChunkTestCase(binaryType)
    array = py.pyarrow.array({}, pyargs("type", binaryType));
    array = py.pyarrow.chunked_array({array});
    expected = cell.empty(0, 1);
    testdata = struct(Array=array, Expected={expected});
end

function testdata = OneChunkZeroNulls(binaryType)
    bytes = py.bytearray(uint8(1:20));
    array = py.pyarrow.array({bytes(1:5), bytes(6:15), bytes(16:20)}, pyargs("type", binaryType));
    array = py.pyarrow.chunked_array({array});
    expected = {uint8(1:5); uint8(6:15); uint8(16:20)};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = OneChunkWithNulls(binaryType)
    bytes = py.bytearray(uint8(1:20));
    array = py.pyarrow.array({bytes(1:3), py.None, bytes(4:15), py.None, bytes(16:20)}, pyargs("type", binaryType));
    array = py.pyarrow.chunked_array({array});
    expected = {uint8(1:3); missing; uint8(4:15); missing; uint8(16:20)};
    testdata = struct(Array=array, Expected={expected});
end

function testdata = MultipleChunks(binaryType)
    bytes = py.bytearray(uint8(1:20));
    array = py.pyarrow.array({bytes(1:3), py.None, bytes(4:10), ...
        bytes(11:15), py.None, bytes(16:20)}, pyargs("type", binaryType));
    array1 = array.slice(0, 1);
    array2 = array.slice(1, 3);
    array3 = array.slice(4, 2);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    expected = {uint8(1:3); missing; uint8(4:10); uint8(11:15); missing; uint8(16:20)};
    testdata = struct(Array=array, Expected={expected});
end
