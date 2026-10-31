classdef testDBConnect < matlab.unittest.TestCase
    % TESTDBCONNECT This is functional test for DBConnect
    % This requires test data on the Databricks system to read/write.
    
    
    % (c) 2020-2021 MathWorks, Inc.
    
    % These files need to exist and visible to the cluster for the test to
    % succeed
    properties
        inputLocation = '/data/airlinedelay/2008.csv';
        deltaLocation = ['/data/airlinedelaydeltademo',datestr(now,30)];
        sparkSession;
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase)

            % This will create a singleton SparkSession using the getOrCreate() method
            testCase.sparkSession = getDatabricksSession();
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        function testReadCSVandCount(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a CSV file
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.inputLocation);
            
            % Count the rows in the read
            numRows = sparkDataSet.count();
            
            % Assertion of the number of rows read
            testCase.assertEqual(numRows, 2389217);
        end
        
        function testWriteDeltaLake(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a CSV file
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.inputLocation);

            % Write a delta table
            sparkDataSet...
                .write.format("delta")...
                .save(testCase.deltaLocation);
            
            % Read a delta table
            deltaDataSet = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.deltaLocation);
            
            % Check the total number of records
            totalRecords = deltaDataSet.count(); %2389217
            testCase.assertEqual(totalRecords, 2389217);
 
        end
        
        function testGetHead(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a delta table
            deltaDataSet = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.deltaLocation);
            
            % Fetch the head with a single row
            dsHead = deltaDataSet.head();
            testCase.assertNotEmpty(dsHead);
            
            % Fetch the head with a single row
            numRows = 5;
            dsHead = deltaDataSet.head(numRows);
            testCase.assertEqual(numel(dsHead),numRows);

        end
        
        function testLimit(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a delta table
            deltaDataSet = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.deltaLocation);
            
            % Request a 100 rows
            reqRows = 100;
            top100 = deltaDataSet.limit(reqRows);
            actRows = top100.count();
            
            % Ensure that we get a 100 rows 
            testCase.assertEqual(actRows, 100);
        end
        
        function testFilter(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a delta table
            deltaDataSet = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.deltaLocation);
        
            % Filter dataset
            filterDataSet = deltaDataSet.filter("UniqueCarrier LIKE 'AA'");
            AAFlights = filterDataSet.count(); %204519
        
            % Ensure that we got the right number of rows
            testCase.assertEqual(AAFlights, 204519);
        end
        
        function testTableMarshaling(testCase)
            % Get the Session
            spark = testCase.sparkSession;
            
            % Read a delta table
            deltaDataSet = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(testCase.deltaLocation);
        
            % Request a 100 rows
            reqRows = 100;
            top100 = deltaDataSet.limit(reqRows);
            
            % MATLAB Table
            mlTable = table(top100);

            % Assert that we have a MATLAB table with the right number of rows
            testCase.assertEqual(size(mlTable),[reqRows 29]);
            testCase.assertClass(mlTable,'table');
        end
        
    end
    
end

