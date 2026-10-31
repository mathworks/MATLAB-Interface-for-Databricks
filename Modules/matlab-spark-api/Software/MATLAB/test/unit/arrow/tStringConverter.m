classdef tStringConverter < hConverter
%TSTRINGCONVERTER Unit tests for matlab.internal.arrow.ChunkedStringArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        StringType = {...
                struct(ArrowType=py.pyarrow.utf8(), OffsetType="int32"),...
                struct(ArrowType=py.pyarrow.large_utf8(), OffsetType="int64")...
            }
    end

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)

        function seedRandomNumberGenerator(~)
            rng(1);
        end

        function initializeTestData(testCase, StringType)
            import  matlab.internal.arrow.ChunkedStringArrayConverter
            testCase.Converter = ChunkedStringArrayConverter(StringType.OffsetType);
        end
    end

    methods(TestParameterDefinition, Static)
        function ConverterTestData = initializetestConverterTestData(StringType)
            stringType = StringType.ArrowType;
            offsetType = StringType.OffsetType;

            ConverterTestData.ZeroChunks        = createZeroChunks(stringType);
            ConverterTestData.OneEmptyChunk     = createOneEmptyChunk(stringType);
            ConverterTestData.OneChunkNoNulls   = createOneChunkNoNulls(stringType);
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(stringType);
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(stringType);
            ConverterTestData.MultipleChunks    = createMultipleChunks(stringType);

            % Invalid UTF-8 sequences.

            % The sequence F0 9F 8E is too short (i.e. missing the last
            % continuation byte).
            bytes = [0xF0 0x9F 0x8E 0xF0 0x9F 0x8E 0xAE];
            ConverterTestData.TooShortByteSequence = createInvalidUTF8Sequence(bytes, offsetType);

            % The sequence begins with continuation bytes.
            bytes = [0x9F 0x8E 0x9F 0x8E 0x8E 0x61 0x20];
            ConverterTestData.TooLongByteSequence = createInvalidUTF8Sequence(bytes, offsetType);

            % The sequence ED A0 80 decodes to a surrogate character (i.e.
            % decoded character is in the range U+D800 to U+DFFF)
            bytes = [0xE2 0x82 0xAC 0xED 0xA0 0x80 0x62];
            ConverterTestData.SurrogateCharacter = createInvalidUTF8Sequence(bytes, offsetType);

            % The sequence 0xF4 0x90 0x80 0x80 0x64 decodes to a too large
            % charactr (i.e. the decoded character is greater than U+10FFFF).
            bytes = [0xF4 0x90 0x80 0x80 0x64 0x65];
            ConverterTestData.TooLargeSequence = createInvalidUTF8Sequence(bytes, offsetType);

            % The sequence C1 A2 is overlong (.e. more bytes than required
            % are used to represent the code point U+62).
            bytes = [0xC1 0xA2];
            ConverterTestData.OverlongSequence = createInvalidUTF8Sequence(bytes, offsetType);

            % F8 has too many set header bits (i.e. the five higher bits
            % are set).
            bytes = [0xF8 0x80 0x80 0x80 0x80];
            ConverterTestData.TooManyHeaderBitsSet = createInvalidUTF8Sequence(bytes, offsetType);
        end

    end
end

function testdata = createZeroChunks(stringType)
    array = py.pyarrow.chunked_array({}, pyargs("type", stringType));
    testdata = struct(Array=array, Expected=string.empty(0, 1));
end

function testdata = createOneEmptyChunk(stringType)
    array = py.pyarrow.array(py.list(), pyargs("type", stringType));
    array = py.pyarrow.chunked_array({array});
    testdata = struct(Array=array, Expected=string.empty(0, 1));
end

function testdata = createOneChunkNoNulls(stringType)
    strs = createStringArray(20);
 
    array = py.pyarrow.array(cellstr(strs), pyargs("type", stringType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=strs');
end

function testdata = createOneChunkWithNulls(stringType)
    nullIndices = [4 10 15];
    str = createStringArray(15);
    c = cellstr(str);
    c(nullIndices) = {py.None};
    str(nullIndices) = missing;
    array = py.pyarrow.array(c, pyargs("type", stringType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=str');
end

function testdata = createOneChunkOnlyNulls(stringType)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", stringType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=repmat(string(missing), [2 1]));
end

function testdata = createMultipleChunks(stringType)
    vals = createStringArray(50);
    c = cellstr(vals);
    nullIndices = [2 3 7 10 11 16 21 35 44];
    c(nullIndices) = {py.None};
    vals(nullIndices) = missing;
    array = py.pyarrow.array(c, pyargs("type", stringType));
    array1 = array.slice(0, 20);
    array2 = array.slice(20, 16);
    array3 = array.slice(36, 14);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    testdata = struct(Array=array, Expected=vals');
end

function strs = createStringArray(numStrings)
    strs = strings([1 numStrings]);
    numChars = randi(25, [1 numStrings]);
    for ii = 1:numStrings
        data = randi(94, [1 numChars(ii)], "uint8") + 31;
        strs(ii) = char(data);
    end
end

function testdata = createInvalidUTF8Sequence(bytes, offsetType)
    pa = py.importlib.import_module("pyarrow");

    fromBuffersFcn = getFromBuffersFcn(offsetType, pa);
    values = pa.array(bytes);
    offsets = pa.array(cast([0 numel(bytes)], offsetType));
    array = fromBuffersFcn(1, offsets.buffers{2}, values.buffers{2});
    array = pa.chunked_array({array});

    testdata = struct(Array=array, Expected=string(native2unicode(bytes, "UTF-8")));
end

function fcn = getFromBuffersFcn(offsetType, pa)
    if offsetType == "int32"
        fcn = @(varargin) pa.StringArray.from_buffers(varargin{:});
    else
        fcn = @(varargin) pa.LargeStringArray.from_buffers(varargin{:});
    end
end
