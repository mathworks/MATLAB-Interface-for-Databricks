classdef tTimestampConverter < hConverter
%TTIMESTAMPCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedTimestampArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        TimestampTypeInfo = {...
            struct(ArrowType=py.pyarrow.timestamp("s"), TicksPerSecond=1, TimeZone=""), ...
            struct(ArrowType=py.pyarrow.timestamp("ms"), TicksPerSecond=1e3, TimeZone=""),...
            struct(ArrowType=py.pyarrow.timestamp("us", pyargs("tz", "America/New_York")), TicksPerSecond=1e6, TimeZone="America/New_York"),...
            struct(ArrowType=py.pyarrow.timestamp("us"), TicksPerSecond=1e6, TimeZone=""),...
            struct(ArrowType=py.pyarrow.timestamp("ns", pyargs("tz", "America/New_York")), TicksPerSecond=1e9, TimeZone="America/New_York"),...
            struct(ArrowType=py.pyarrow.timestamp("ns"), TicksPerSecond=1e9, TimeZone=""),...
        }

    end

    properties(TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function setupConverter(testCase, TimestampTypeInfo)
            import matlab.internal.arrow.ChunkedTimestampArrayConverter
            unit = string(TimestampTypeInfo.ArrowType.unit);
            testCase.Converter = ChunkedTimestampArrayConverter(unit, TimestampTypeInfo.TimeZone);
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = intitializeConverterTestData(TimestampTypeInfo)
            ConverterTestData = struct();

            ConverterTestData.ZeroChunks = createZeroChunks(TimestampTypeInfo);

            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(TimestampTypeInfo);

            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(TimestampTypeInfo);

            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(TimestampTypeInfo);

            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(TimestampTypeInfo);

            ConverterTestData.MultipleChunks = createMultipleChunks(TimestampTypeInfo);
        end
    end
end

function testdata = createZeroChunks(info)
    array = py.pyarrow.chunked_array({}, pyargs("type", info.ArrowType));
    expected = datetime.empty(0, 1);
    expected.TimeZone = info.TimeZone;
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneEmptyChunk(info)
    array = py.pyarrow.array({}, pyargs("type", info.ArrowType));
    array = py.pyarrow.chunked_array({array});
    expected = datetime.empty(0, 1);
    expected.TimeZone = info.TimeZone;
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkNoNulls(info)
    dates = datetime(2020, 1, 1, TimeZone=info.TimeZone) + days(0:10);
    vals = convertTo(dates, "epochtime", TicksPerSecond=info.TicksPerSecond);
    array = py.pyarrow.array(vals, pyargs("type", info.ArrowType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=dates');
end

function testdata = createOneChunkWithNulls(info)
    nullIndices = [7 10 18];
    dates = datetime(2026, 4, 13, TimeZone=info.TimeZone) + days(0:20);
    vals = convertTo(dates, "epochtime", TicksPerSecond=info.TicksPerSecond);
    vals = num2cell(vals);
    vals(nullIndices) = {py.None};
    dates(nullIndices) = NaT;
    array = py.pyarrow.array(vals, pyargs("type", info.ArrowType));
    array = py.pyarrow.chunked_array(array);
    testdata = struct(Array=array, Expected=dates');
end

function testdata = createOneChunkOnlyNulls(info)
    array = py.pyarrow.array(py.list({py.None, py.None}), pyargs("type", info.ArrowType));
    array = py.pyarrow.chunked_array(array);
    expected = NaT([2 1], TimeZone=info.TimeZone);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createMultipleChunks(info)
    nullIndices = [1 4 9 10 15 17];
    dates = datetime(2010, 10, 31, TimeZone=info.TimeZone) + days(0:20);
    vals = convertTo(dates, "epochtime", TicksPerSecond=info.TicksPerSecond);
    vals = num2cell(vals);
    vals(nullIndices) = {py.None};
    dates(nullIndices) = NaT;
    array = py.pyarrow.array(vals, pyargs("type", info.ArrowType));
    array1 = array.slice(0, 9);
    array2 = array.slice(9, 4);
    array3 = array.slice(13, 9);
    array = py.pyarrow.chunked_array({array1, array2, array3});
    testdata = struct(Array=array, Expected=dates');
end
