classdef testDataframeBracket < matlab.unittest.TestCase
    % testDataframeBracket Unit tests for the Spark Dataframe bracket method

    % Copyright 2025-2026 MathWorks, Inc.

    properties
        Outages
        Outages_count
        DFNamesArgs
        sparkSession
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');
            
            % Create a Spark configuration and shared Spark session

            isDatabricks = isDatabricksEnvironment();

            appName = 'DataframeBracketUnitTests';

            if isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            if isDatabricks
                % Use a test file - this needs to exists on the cluster for
                % tests to pass
                tmpDF = spark.sql("SELECT * FROM main.default.outages LIMIT 100");
            else
                % inputLocation = addFileProtocol(which('airlinesmall.csv'));
                inputLocation = addFileProtocol(which('outages.csv'));
                % Create a dataset by pointing to all the CSV content
                sparkDataSet = spark.read.format('csv')...
                    .option('header','true')...
                    .option('inferSchema','true')...
                    .load(inputLocation);

                tmpDF = sparkDataSet ...
                    .withColumn("OutageDate", matlab.pyspark.sql.functions.to_date(sparkDataSet.col("OutageTime"))) ...
                    .withColumn("OutageTimestamp", matlab.pyspark.sql.functions.to_timestamp(sparkDataSet.col("OutageTime"))) ...
                    .withColumn("RestorationTime", matlab.pyspark.sql.functions.to_date(sparkDataSet.col("RestorationTime"))) ...
                    ;

            end
            testCase.Outages = tmpDF;
            testCase.Outages_count = testCase.Outages.count();

            tmpDF2 = spark.range(10);
            dfNames = tmpDF2 ...
                .withColumn('col', tmpDF2.id) ...
                .withColumn('filter', tmpDF2.id) ...
                .withColumn('where', tmpDF2.id) ...
                .withColumn('withColumn', tmpDF2.id) ...
                .withColumn('withColumnRenamed', tmpDF2.id) ...
                .drop('id');
            testCase.DFNamesArgs = dfNames;

        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)

        function testColumnRetrieval(testCase)
            df = testCase.Outages;
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(df, objType);

            cols = df.columns;
            for k=1:numel(cols)
                colName = cols(k);
                colObj = df.(colName);
                testCase.verifyClass(colObj, 'matlab.pyspark.sql.column.Column');
                testCase.verifyEqual(colObj.string, sprintf("Column<'%s'>", colName));
            end
        end

        function testBadNamesArgs(testCase)
            df = testCase.DFNamesArgs;
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(df, objType);

            cols = df.columns;
            for k=1:numel(cols)
                colName = cols(k);

                errId = 'MATLAB:minrhs';
                testCase.verifyError(@() df.(colName), errId);

            end
        end

        function testDeepNesting(testCase)
            DF = testCase.Outages;

            filterCol = DF.Cause.isin(["winter storm", "attack"]);
            testCase.verifyClass(filterCol, 'matlab.pyspark.sql.column.Column');

            filteredDF = DF.(filterCol);
            testCase.verifyClass(filteredDF, 'matlab.pyspark.sql.dataframe.Dataframe');

            filteredCount = filteredDF.count();

            testCase.verifyLessThan(filteredCount, testCase.Outages_count);
        end

    end
end
