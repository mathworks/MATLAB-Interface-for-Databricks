classdef testDataClasses < matlab.unittest.TestCase
    % testDataClasses Test implementation classes for data

    % Copyright 2020-2024 MathWorks, Inc.

    properties
    end

    methods (TestClassSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)

        function testDataImplementation(testCase)
            % Test that data implementation classes work, somehow

            % Just instantiate an array of non-abstract classes
            try
                DataClasses = [ ...
                    compiler.build.spark.data.DoubleType, ...
                    compiler.build.spark.data.FloatType, ...
                    compiler.build.spark.data.DateType, ...
                    compiler.build.spark.data.TimestampType, ...
                    compiler.build.spark.data.BooleanType, ...
                    compiler.build.spark.data.LongType, ...
                    compiler.build.spark.data.IntegerType, ...
                    compiler.build.spark.data.ShortType, ...
                    compiler.build.spark.data.ArrayType]; %#ok<NASGU>
            catch ME
                testCase.verifyTrue(false);
            end
        end
    end
end

