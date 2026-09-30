classdef tDurationConverter < hConverter
%TDURATIONCONVERTER Unit tests for
%matlab.internal.arrow.ChunkedDurationArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (ClassSetupParameter)
        
        DurationType = { ...
            struct(ArrowType=py.pyarrow.duration('s'),  ConversionFactor=1),...
            struct(ArrowType=py.pyarrow.duration('ms'), ConversionFactor=1e3),...
            struct(ArrowType=py.pyarrow.duration('us'), ConversionFactor=1e6),...
            struct(ArrowType=py.pyarrow.duration('ns'), ConversionFactor=1e9)...
        }

    end

    properties (TestParameter)
        ConverterTestData
    end

    methods (TestClassSetup)
        function initializeConverter(testCase, DurationType)
            import matlab.internal.arrow.ChunkedDurationArrayConverter
            unit = string(DurationType.ArrowType.unit);
            testCase.Converter = ChunkedDurationArrayConverter(unit);
        end

        function initializeConstraintFcn(testCase)
            fcn = @(expected) matlab.unittest.constraints.IsEqualTo(expected, ...
                "Within", matlab.unittest.constraints.AbsoluteTolerance(milliseconds(1)));
            testCase.ConstraintFcn = fcn;
        end
    end

    methods (TestParameterDefinition, Static)
        function ConverterTestData = initializeConverterTestData(DurationType)
            arrowType = DurationType.ArrowType;
            conversionFactor = DurationType.ConversionFactor;
            ConverterTestData.ZeroChunks = createZeroChunks(arrowType);
            ConverterTestData.OneEmptyChunk = createOneEmptyChunk(arrowType);
            ConverterTestData.OneChunkNoNulls = createOneChunkNoNulls(arrowType, conversionFactor);
            ConverterTestData.OneChunkwithNulls = createOneChunkWithNulls(arrowType, conversionFactor);
            ConverterTestData.OneChunkOnlyNulls = createOneChunkOnlyNulls(arrowType);
            ConverterTestData.MultipleChunks = createMultipleChunks(arrowType, conversionFactor);

        end
    end
end

function testdata = createZeroChunks(arrowType)
    array = py.pyarrow.chunked_array({}, pyargs("type", arrowType));
    testdata = struct(Array=array, Expected=duration.empty(0, 1));
end

function testdata = createOneEmptyChunk(arrowType)
    array = py.pyarrow.array({},  pyargs("type", arrowType));
    array = py.pyarrow.chunked_array({array});
    testdata = struct(Array=array, Expected=duration.empty(0, 1));
end

function testdata = createOneChunkNoNulls(arrowType, conversionFactor)
    data = int64([1401030, 244535631, 5665554052]);
    array = py.pyarrow.array(data,  pyargs("type", arrowType));
    array = py.pyarrow.chunked_array({array});

    vals = seconds(double(data) / conversionFactor);
    testdata = struct(Array=array, Expected=vals');
end

function testdata = createOneChunkWithNulls(arrowType, conversionFactor)
    nullIndices = [2 9];
    data = (2.^(2:11));
    c = num2cell(data);
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", arrowType));
    array = py.pyarrow.chunked_array({array});

    vals = seconds(double(data) / conversionFactor);
    vals(nullIndices) = NaN;
    testdata = struct(Array=array, Expected=vals');
end

function testdata = createOneChunkOnlyNulls(arrowType)
    data = repmat({py.None}, [1 7]);
    array = py.pyarrow.array(data, pyargs("type", arrowType));
    array = py.pyarrow.chunked_array({array});

    expected = repmat(seconds(NaN), [7 1]);
    testdata = struct(Array=array, Expected=expected);
end

function testdata = createMultipleChunks(arrowType, conversionFactor)
    nullIndices = [4 10 5];
    data = int64(2.^(1:20));
    c = num2cell(data);
    c(nullIndices) = {py.None};
    array = py.pyarrow.array(c, pyargs("type", arrowType));
    
    array1 = array.slice(0, 5);
    array2 = array.slice(5, 0);
    array3 = array.slice(5, 11);
    array4 = array.slice(16, 4);

    array = py.pyarrow.chunked_array({array1, array2, array3, array4});

    vals = seconds(double(data) / conversionFactor);
    vals(nullIndices) = NaN;
    testdata = struct(Array=array, Expected=vals');
end