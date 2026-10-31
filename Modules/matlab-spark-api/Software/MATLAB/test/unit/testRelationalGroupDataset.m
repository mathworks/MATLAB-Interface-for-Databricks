classdef testRelationalGroupDataset < matlab.unittest.TestCase
    % TESTRELATIONALGROUPDATASET Unit tests for the RelationalGroupDataset abstraction

    % Copyright 2022-2026 MathWorks, Inc.

    properties
        Data
        ds
        sparkSession
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session


            isDatabricks = ~matlab.sparkutils.isApacheSpark;

            appName = 'RelationalGroupDatasetUnitTests';
            if isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            fruits = ["Banana", "Carrots", "Beans", "Orange", "Orange", "Banana", "Carrots", "Beans", "Orange", "Banana", "Carrots", "Beans"]';
            amounts = [1000, 1500, 1600, 2000, 2000, 400, 1200, 1500, 4000, 2000, 2000, 2000]';
            countries = ["USA", "USA", "USA", "USA", "USA", "China", "China", "China", "China", "Canada", "Canada", "Mexico"]';

            T = table(fruits, amounts, countries, ...
                'VariableNames', ["Fruit", "Amount", "Country"]);

            testCase.Data = T;
            testCase.ds = matlab.sparkutils.table2dataset(T, spark);
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)

        function testPivot(testCase)

            DS = testCase.ds;
            raw = testCase.Data;
            pivotDS = DS.groupBy("Fruit").pivot("Country").sum("Amount");

            pivotT = pivotDS.table();

            testCase.verifyEqual(4, height(pivotT));
            testCase.verifyEqual(sum(raw.Amount), sum(sum(pivotT{:,2:end}, 'omitnan')));
            testCase.verifyEqual(5, width(pivotT));

        end

        function testPivot2(testCase)

            DS = testCase.ds;
            raw = testCase.Data;
            countries = unique(string(raw.Country));
            pivotDS = DS.groupBy("Fruit").pivot("Country", countries).sum("Amount");

            pivotT = pivotDS.table();

            testCase.verifyEqual(4, height(pivotT));
            testCase.verifyEqual(sum(raw.Amount), sum(sum(pivotT{:,2:end}, 'omitnan')));
            testCase.verifyEqual(5, width(pivotT));
        end

        function testPivot3(testCase)

            DS = testCase.ds;
            
            pivotDS = DS.groupBy("Fruit").pivot("Country", "China", "Mexico").sum("Amount");

            pivotT = pivotDS.table();

            testCase.verifyEqual(4, height(pivotT));
            testCase.verifyEqual(3, width(pivotT));
        end


    end
end

