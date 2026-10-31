classdef testNaMethods < matlab.unittest.TestCase
    % testNaMethods Unit tests for the Spark DataFrameNaFunctions class
    
    % Copyright 2020-2026 MathWorks, Inc.
    
    properties
        ds
        count
        sparkSession
        cols
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session

            isDatabricks = isDatabricksEnvironment;
            
            appName = 'DataFrameNaFunctionsUnitTest';
            if isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;
            
            if isDatabricks
                % Use a test file - this needs to exists on the cluster for
                % tests to pass
                inputLocation = '/data/airlinedelay/2008.csv';
            else
                % inputLocation = addFileProtocol(which('airlinesmall.csv'));
                inputLocation = addFileProtocol(getSparkApiRoot('test', 'fixtures', '2008_small.csv'));
            end
            
            % Create a dataset by pointing to all the CSV content
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(inputLocation);

            listOfCols = ["CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay"];
            
            filtExpr = join(listOfCols + " != 'NA'", " and ");
            sparkDataSet = sparkDataSet.filter(filtExpr);
            
            cleanedDS = sparkDataSet ...
                .withColumn('CarrierDelay', sparkDataSet.col('CarrierDelay').cast('int')) ...
                .withColumn('WeatherDelay', sparkDataSet.col('WeatherDelay').cast('int')) ...
                .withColumn('NASDelay', sparkDataSet.col('NASDelay').cast('int')) ...
                .withColumn('SecurityDelay', sparkDataSet.col('SecurityDelay').cast('int')) ...
                .withColumn('LateAircraftDelay', sparkDataSet.col('LateAircraftDelay').cast('int'));
            
            testCase.ds = cleanedDS;
            testCase.count = testCase.ds.count();            
            testCase.cols = ["CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay"];
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        function testNA(testCase)

            DS = testCase.ds;
            NA = DS.na;
            testCase.assertClass(NA, 'matlab.pyspark.sql.dataframe.DataFrameNaFunctions')
            testCase.assertClass(NA.na, 'py.pyspark.sql.connect.dataframe.DataFrameNaFunctions')
        end

        function testDropNoArg(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop();
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end

        function testDropLimit(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop(thresh=5);
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end

        function testDropLimitCols(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop(thresh=5, subset=testCase.cols);
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end

        function testDropCols(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop(subset=testCase.cols);
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end
        
        function testDropHow(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop(how="any");
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end

        function testDropHowCols(testCase)
            DS = testCase.ds;
            DS2 = DS.na.drop(how="any", subset=testCase.cols);
            numElms = DS2.count();
            testCase.assertGreaterThanOrEqual(testCase.count, numElms);
        end

    end
end
