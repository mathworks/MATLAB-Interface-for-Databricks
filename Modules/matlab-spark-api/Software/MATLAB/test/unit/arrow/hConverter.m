classdef hConverter < matlab.unittest.TestCase
%HCONVERTER Helper test class for all ChunkedArrayConverter tests.

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter, Abstract)
        ConverterTestData
    end

    properties
        Converter
    end

    properties
        ConstraintFcn = @(expected) matlab.unittest.constraints.IsEqualTo(expected)
    end

    methods (Test)
        function testConverter(testCase, ConverterTestData)
            array = ConverterTestData.Array;
            expected = ConverterTestData.Expected;
            converter = testCase.Converter;

            actual = converter.convert(array);
            testCase.verifyThat(actual, testCase.ConstraintFcn(expected));

            actual = converter.convert(array, true);
            testCase.verifyThat(actual, testCase.ConstraintFcn(expected));

            actual = converter.convert(array, false);
            testCase.verifyThat(actual, testCase.ConstraintFcn(expected));
        end
    end

end