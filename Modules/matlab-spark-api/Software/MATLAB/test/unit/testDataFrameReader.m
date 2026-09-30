classdef testDataFrameReader < matlab.unittest.TestCase
    % TESTDATAFRAMEREADER Unit tests for the dataframe reader
    
    % Copyright 2019-2026 MathWorks, Inc.
    
    properties
        sparkSession;
        isDatabricks;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testDataFrameReader');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a singleton SparkSession using the getOrCreate() method
            testCase.isDatabricks = isDatabricksEnvironment;
            
            appName = 'DataFrameReaderUnitTests';
            if testCase.isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;
            
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testConstructor(testCase)
            dfr = matlab.pyspark.sql.readwriter.DataFrameReader();
            testCase.verifyClass(dfr,'matlab.pyspark.sql.readwriter.DataFrameReader');
        end
        
        function testFormat(testCase)
            % Set the format to CSV
            myDataSet = testCase.sparkSession.read.format('csv');
            
            % Check that it was successful
            objType = 'matlab.pyspark.sql.readwriter.DataFrameReader';
            testCase.verifyClass(myDataSet, objType);
        end
        
        function testOption(testCase)
            % Create a dataset
            myDataSet = testCase.sparkSession...
                .read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true');
            
            % Check that it was successful
            objType = 'matlab.pyspark.sql.readwriter.DataFrameReader';
            testCase.verifyClass(myDataSet, objType);
        end
        
        function testLoad(testCase)
            % Read a slice of data
            if testCase.isDatabricks
                % Testcase databricks
                inputLocation = '/data/airlinedelay/2008.csv';
            else
                % Testcase Spark
                inputLocation = addFileProtocol(which('airlinesmall.csv'));
            end
            % Create a dataset
            myDataSet = testCase.sparkSession...
                .read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(inputLocation);
            
            % Check that it was successful
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(myDataSet, objType);

        end
        
        function testText(testCase)
            % Read a slice of data
            fixtureDir = getSparkApiRoot('test', 'fixtures');
            lettersFile = fullfile(fixtureDir, 'letters.txt');
            testCase.verifyTrue(isfile(lettersFile));

            if testCase.isDatabricks
                d = databricks.DBFS;
                d.upload(lettersFile, '/data/');
                inputLocation = '/data/letters.txt';
            else
                inputLocation = addFileProtocol(lettersFile);
            end

            % Create a dataset
            df1 = testCase.sparkSession.read.text(inputLocation);
            % Check that it was successful
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(df1, objType);            

            t1 = sortrows(table(df1));
            % testCase.verify column name is value and 1 row per line
            % 
            %  +----------+
            %  | value    |
            %  +----------+
            %  | alpha, 1 |
            %  | beta, 2  |
            %  | gamma, 3 |
            %  +----------+
            testCase.verifyTrue(istable(t1));
            testCase.verifyEqual(t1.Properties.VariableNames{1}, 'value');
            testCase.verifyEqual(t1.value(1), "alpha, 1");
            testCase.verifyEqual(t1.value(2), "beta, 2");
            testCase.verifyEqual(t1.value(3), "gamma, 3");
            testCase.verifyEqual(height(t1), 3);

            df2 = testCase.sparkSession.read.option('lineSep',',').text(inputLocation);
            t2 = sortrows(table(df2));
            % testCase.verify ...
            %
            %  +----------+
            %  | value    |
            %  +----------+
            %  | alpha    |
            %  | 1\nbeta  |
            %  | 2\ngamma |
            %  | 3\n      |
            %  +----------+
            testCase.verifyTrue(istable(t2));
            testCase.verifyEqual(t2.Properties.VariableNames{1}, 'value');
            testCase.verifyEqual(t2.value(4), "alpha");
            testCase.verifyEqual(t2.value(1), " 1" + newline + "beta");
            testCase.verifyEqual(t2.value(2), " 2" + newline + "gamma");
            testCase.verifyEqual(t2.value(3), " 3");
            testCase.verifyEqual(height(t2), 4);
            
        end

        function testTextFile(testCase)
            % Read a slice of data
            fixtureDir = getSparkApiRoot('test', 'fixtures');
            lettersFile = fullfile(fixtureDir, 'letters.txt');

            if testCase.isDatabricks
                d = databricks.DBFS;
                d.upload(lettersFile, '/data/');
                inputLocation = '/data/letters.txt';
            else
                inputLocation = addFileProtocol(lettersFile);
            end

            % Create a dataset
            % NOTE: No textFile method in pyspark
            df1 = testCase.sparkSession.read.text(inputLocation);
            % Check that it was successful
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(df1, objType); 

            t1 = sortrows(table(df1));
            % testCase.verify column name is value and 1 row per line
            % 
            %  +----------+
            %  | value    |
            %  +----------+
            %  | alpha, 1 |
            %  | beta, 2  |
            %  | gamma, 3 |
            %  +----------+
            testCase.verifyTrue(istable(t1));
            testCase.verifyEqual(t1.Properties.VariableNames{1}, 'value');
            testCase.verifyEqual(t1.value(1), "alpha, 1");
            testCase.verifyEqual(t1.value(2), "beta, 2");
            testCase.verifyEqual(t1.value(3), "gamma, 3");
            testCase.verifyEqual(height(t1), 3);


            % NOTE: No textFile method in pyspark
            df2 = testCase.sparkSession.read.option('lineSep',',').text(inputLocation);
            t2 = sortrows(table(df2));
            % testCase.verify ...
            %
            %  +----------+
            %  | value    |
            %  +----------+
            %  | alpha    |
            %  | 1\nbeta  |
            %  | 2\ngamma |
            %  | 3\n      |
            %  +----------+
            testCase.verifyTrue(istable(t2));
            testCase.verifyEqual(t2.Properties.VariableNames{1}, 'value');
            testCase.verifyEqual(t2.value(4), "alpha");
            testCase.verifyEqual(t2.value(1), " 1" + newline + "beta");
            testCase.verifyEqual(t2.value(2), " 2" + newline + "gamma");
            testCase.verifyEqual(t2.value(3), " 3");
            testCase.verifyEqual(height(t2), 4);
            
        end
    end
    
end

