classdef testTable2Dataset < matlab.unittest.TestCase
    % TESTSPARKUTILITY Unit tests for the Spark Dataset abstraction

    % Copyright 2020-2026, MathWorks Inc.

    properties
        sparkSession;
        isDatabricks;
        TUniform
        TNonuniform
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testTable2Dataset');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session

            import matlab.spark.sql.*

            testCase.isDatabricks = isDatabricksEnvironment;

            appName = 'Table2DatasetUnitTests';
            if testCase.isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            S = struct('Name', {"A", "B"}, 'C', {1:3,4:6});
            testCase.TUniform = struct2table(S);

            S = struct('Name', {"A", "B"}, 'C', {1:3,4:7});
            testCase.TNonuniform = struct2table(S);


            if testCase.isDatabricks
                inputLocation = '/test/unit-test-data/outages.csv';
            else
                inputLocation = addFileProtocol(which('outages.csv'));
            end

        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testConvertUniformArray(testCase)
            T = testCase.TUniform;
            spark = testCase.sparkSession;
            DS = matlab.sparkutils.table2dataset(T, spark);
            dsTYPE = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(DS, dsTYPE);
            testCase.verifyEqual(int64(DS.count), int64(height(T)));
            % TODO: Test number of columns later, when arrays aren't split
            % up
            
        end

        function testConvertNonuniformArray(testCase)
            % TODO: This array cannot be converted with our Spark. In a notebook, the
            % corresponding code works
            % import pandas as pd
            % data = {
            %     'Name': ['A', 'B'],
            %     'C': [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0, 7.0]]
            % }
            % pdf = pd.DataFrame(data = data)
            % DF = spark.createDataFrame(pdf)
            % DF.show(10, False)
            % T = testCase.TNonuniform;
            % spark = testCase.sparkSession;
            % DS = matlab.sparkutils.table2dataset(T, spark);
            % testCase.verifyClass(DS, 'matlab.spark.sql.Dataset');
            % testCase.verifyEqual(DS.count, height(T));
            % testCase.verifyEqual(length(DS.columns), width(T));
        end
    end
end

