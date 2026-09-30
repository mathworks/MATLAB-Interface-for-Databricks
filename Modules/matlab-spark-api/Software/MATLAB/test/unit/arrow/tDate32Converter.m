classdef tDate32Converter < hConverter
%TDATE32CONVERTER Unit tests for matlab.internal.arrow.ChunkedDate32ArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function setUpConverter(testCase)
            testCase.Converter = matlab.internal.arrow.ChunkedDate32ArrayConverter();
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = intitializeConverterTestData()
            date32Type = py.pyarrow.date32();

            ConverterTestData = struct();

            ConverterTestData.ZeroChunks = createZeroChunks(date32Type);

            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(date32Type);

            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(date32Type);

            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(date32Type);

            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(date32Type);

            ConverterTestData.MultipleChunks = createMultipleChunks(date32Type);
        end
    end
end

function testdata = createZeroChunks(date32Type)
    array = py.pyarrow.chunked_array({}, pyargs("type", date32Type));
    testdata = struct(Array=array, Expected=datetime.empty(0, 1));
end

function testdata = createOneEmptyChunk(date32Type)
    array = py.pyarrow.array(py.list(), pyargs("type", date32Type));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=datetime.empty(0, 1));
end

function testdata = createOneChunkNoNulls(date32Type)
    dates = datetime(2020, 1, 1) + days(0:10);
    vals = int32(days(dates - datetime(1970, 1, 1)));
    array = py.pyarrow.array(vals, pyargs("type", date32Type));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=dates');
end

function testdata = createOneChunkWithNulls(date32Type)
    nullIndices = [5 20 22];
    dates = datetime(2020, 1, 1) + days(0:25);
    vals = int32(days(dates - datetime(1970, 1, 1)));
    c = num2cell(vals);
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", date32Type));
    array = py.pyarrow.chunked_array(array);
    expected = dates';
    expected(nullIndices) = NaT;
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkOnlyNulls(date32Type)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", date32Type));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=[NaT; NaT]);
end

function testdata = createMultipleChunks(date32Type)
    dates = datetime(2020, 1, 1) + days(0:20);
    vals = int32(days(dates - datetime(1970, 1, 1)));
    c = num2cell(vals);
    c([1 5 10 11 21]) = {py.None};
    dates([1 5 10 11 21]) = NaT;
    array = py.pyarrow.array(c, pyargs("type", date32Type));
    array1 = array.slice(0, 5);
    array2 = array.slice(5, 10);
    array3 = array.slice(15, 6);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    testdata = struct(Array=array, Expected=dates');
end
