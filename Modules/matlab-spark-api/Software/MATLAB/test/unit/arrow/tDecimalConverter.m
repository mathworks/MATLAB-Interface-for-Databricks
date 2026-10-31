classdef tDecimalConverter < hConverter
%TDECIMALCONVERTER  Contains unit tests for
%matlab.internal.arrow.ChunkedDecimalArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function setUpConverter(testCase)
            testCase.Converter = matlab.internal.arrow.ChunkedDecimalArrayConverter();
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData()
            type = py.pyarrow.decimal128(5, 2);

            ConverterTestData.ZeroChunks = createZeroChunks(type);
            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(type);
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(type);
            ConverterTestData.OneChunkWithNulls = createOneChunkWithNulls(type);
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(type);
            ConverterTestData.MultipleChunks = createMultipleChunks(type);

        end
    end
end

function testdata = createZeroChunks(decimalType)
    array = py.pyarrow.chunked_array({}, pyargs("type", decimalType));
    expected = double.empty(0, 1);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneEmptyChunk(decimalType)
    array = py.pyarrow.array({}, pyargs("type", decimalType));
    array = py.pyarrow.chunked_array({array});
    expected = double.empty(0, 1);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkNoNulls(decimalType)
    data = {'123.45', '999.99', '519.87'};
    data = cellfun(@(x) py.decimal.Decimal(x), data, UniformOutput=false);
    array = py.pyarrow.array(data, pyargs("type", decimalType));
    array = py.pyarrow.chunked_array({array});
    expected = [123.45; 999.99; 519.87];
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkWithNulls(decimalType)
    data = {'173.43', '931.12', '519.87'};
    data = cellfun(@(x) py.decimal.Decimal(x), data, UniformOutput=false);
    data = {py.None data{1} data{2} py.None data{3}};
    array = py.pyarrow.array(data, pyargs("type", decimalType));
    array = py.pyarrow.chunked_array({array});
    expected = [NaN; 173.43; 931.12; NaN; 519.87];
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createOneChunkOnlyNulls(decimalType)
    data = repmat({py.None}, [1 9]);
    array = py.pyarrow.array(data, pyargs("type", decimalType));
    array = py.pyarrow.chunked_array({array});
    expected = NaN([9 1]);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createMultipleChunks(decimalType)
    data = {'173.43', '931.12', '519.87', '610.04', '644.67', '145.91', ...
        '100.01', '650.07', '999.99', '111.11'};
    data = cellfun(@(x) py.decimal.Decimal(x), data, UniformOutput=false);
    data = [{py.None} data(1:3), {py.None}, data(4:8), {py.None}, data(9:10)];
    array = py.pyarrow.array(data, pyargs("type", decimalType));
    array1 = array.slice(0, 4);
    array2 = array.slice(4, 2);
    array3 = array.slice(6, 7);

    array = py.pyarrow.chunked_array({array1, array2, array3});
    expected = [ NaN; 173.43; 931.12; 519.87; NaN; 610.04; 644.67; 145.91; 100.01;
                650.07; NaN; 999.99; 111.11];
    testdata = struct(Array=array, Expected=expected);
end