classdef testDataset < matlab.unittest.TestCase
    % TESTDATASET Unit tests for the Spark Dataset abstraction
    
    % Copyright 2020-2026 MathWorks, Inc.
    
    properties
        ds;
        dsNames;
        count;
        sparkSession;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testDataset');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');
            % Create a Spark configuration and shared Spark session

            isDatabricks = isDatabricksEnvironment();
            
            appName = 'DatasetUnitTests';
            
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
            
            cleanedDS = sparkDataSet ...
                .filter(~sparkDataSet.('ArrDelay').contains('NA')) ...
                .filter(~sparkDataSet.('DepDelay').contains('NA')) ...
                .withColumn('ArrDelay', sparkDataSet.col('ArrDelay').cast('int')) ...
                .withColumn('DepDelay', sparkDataSet.col('DepDelay').cast('int')) ...
                .withColumn('ActualElapsedTime', sparkDataSet.col('ActualElapsedTime').cast('int')) ...
                .withColumn('CRSElapsedTime', sparkDataSet.col('CRSElapsedTime').cast('int')) ...
                .withColumn('Distance', sparkDataSet.col('Distance').cast('int'));
            
            testCase.ds = cleanedDS;
            testCase.count = testCase.ds.count();            

            S = struct(...
                'Name', {"Alice", "Bob", "Céline", "Dimitri", "Esperanza", "Fredrik"}, ...
                'Age', {25, 35, 30, 40, 50, 20}, ...
                'FavColor', {"Blue", "Green", "Pink", "Tartufo", "Green", "Green"}, ...
                'Pet', {"Dog", "Cat", "Iguana", "Iguana", "Giraffe", "Cat"} ...
                );
            T = struct2table(S);
                
            testCase.dsNames = matlab.sparkutils.table2dataset(T, spark);
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testConstructor(testCase)
            % Create a dataset
            sparkDataset = matlab.pyspark.sql.dataframe.Dataframe();
            testCase.verifyClass(sparkDataset,'matlab.pyspark.sql.dataframe.Dataframe');
        end
        
        function testCount(testCase)
            numRows = testCase.ds.count();
            testCase.verifyGreaterThan(numRows, 0);
        end
        
        % Persist this Dataset with the default storage level (MEMORY_AND_DISK).
        function testCache(testCase)
            sparkDataset = testCase.ds.cache();
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(sparkDataset, objType);
        end
        
        function testColumns(testCase)
            cols = testCase.ds.columns();
            testCase.verifyClass(cols, 'string');
            T = table(testCase.ds.limit(10));
            Tcols = string(T.Properties.VariableNames());
            N = length(Tcols);
            testCase.verifyLength(cols, N);
            testCase.verifyLength(union(cols, Tcols), N);
            testCase.verifyLength(setdiff(cols, Tcols), 0);
        end
        
        function testSelect(testCase)
            sds = testCase.ds.select("Year", "Month", "DepTime", "ArrTime");
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(sds, objType);

            sdsCols = sds.columns;
            testCase.verifyLength(sdsCols, 4);
            testCase.verifyEqual(testCase.ds.count(), sds.count(), 'Datasets should have same length');
        end
        
        function testCol(testCase)
            name = "Year";
            year = testCase.ds.col(name);
            objType = 'matlab.pyspark.sql.column.Column';
            testCase.verifyClass(year, objType);
        end
        
        function testShow(testCase)
            output = evalc('testCase.ds.show(10)');
            testCase.verifyNotEmpty(output)
            testCase.verifyGreaterThan(length(output), 2000);
        end
        
        function testDSAgg(testCase)
            flights = testCase.ds;

            maxFunc = @matlab.pyspark.sql.functions.max;
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            groupedDS1 = flights.agg(maxFunc(flights.col("ArrDelay")));
            testCase.assertClass(groupedDS1, objType)
            testCase.assertGreaterThan(groupedDS1.count, 0);
            
            groupedDS2 = flights.agg(maxFunc(flights.col("ArrDelay")), maxFunc(flights.col("DepDelay")));
            testCase.assertClass(groupedDS2, objType)
            testCase.assertGreaterThan(groupedDS2.count, 0);
            
            groupedDS3 = flights.agg(maxFunc(flights.col("ArrDelay")), maxFunc(flights.col("DepDelay")), maxFunc(flights.col("TaxiIn")));
            testCase.assertClass(groupedDS3, objType)
            testCase.assertGreaterThan(groupedDS3.count, 0);
        end
        
        function testGroupby(testCase)
            flights = testCase.ds;
            
            gbds = flights.groupBy("Origin", "DayOfWeek");
            gbType = 'matlab.pyspark.sql.group.GroupedData';
            testCase.verifyClass(gbds, gbType);
            
            odds = gbds.count();
            dsType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(odds, dsType);
            testCase.verifyLength(odds.columns, 3);
            
            % Test ascending sort
            Tasc = table(odds.sort("count").select("count"));
            TascCount = Tasc.count;
            % Make sure it's steady state or growing
            testCase.verifyFalse(any(diff(TascCount)<0));
            
            % Test descending sort
            Tdesc = table(odds.sort(odds.col("count").desc()).select("count"));
            TdescCount = Tdesc.count;
            
            % Make sure it's steady state or growing
            testCase.verifyFalse(any(diff(TdescCount)>0));
        end
        
        function testPrintSchema(testCase)
            try
                flights = testCase.ds;
                flights.printSchema;
            catch
                testCase.verifyTrue(false);
            end
        end
        
        function testTempView(testCase)
            % Turning this off for now, because of problems with AZ platform
            return;
            flights = testCase.ds;
            spark = testCase.sparkSession;
            tempName = 'flights_temp';
            flights.select("Origin", "Dest", "Distance", "ArrDelay", "DepDelay").createOrReplaceTempView(tempName);
            C = spark.catalog();
            tableDS = C.listTables();
            tableDS_T = tableDS.toTable;
            tIdx = contains(tableDS_T.name, tempName);
            testCase.verifyEqual(sum(tIdx), 1);

            results = spark.sql("SELECT Origin, Dest, Distance FROM " + tempName + ...
                " WHERE Distance > 1500 AND Origin = 'HOU'");
            dist = table(results.select("Distance"));
            testCase.verifyGreaterThan(min(dist.Distance), 1500);
            
            dtv = C.dropTempView(tempName);
            testCase.verifyClass(dtv, 'logical')
            testCase.verifyTrue(dtv);
            
            tableDSAfter = C.listTables();
            tableDSAfter_T = tableDSAfter.toTable;
            tIdx = contains(tableDSAfter_T.name, tempName);
            testCase.verifyEqual(sum(tIdx), 0);
            
        end
        
        function testDropDuplicates(testCase)
            DS = testCase.dsNames;
            % DS.show(20, false);
            testCase.verifyEqual(int64(DS.count()), int64(6));
            
            % Verify we can drop duplicates based on a certain column
            dsColor = DS.dropDuplicates("FavColor");
            % dsColor.show(20, false);
            testCase.verifyEqual(int64(dsColor.count()), int64(4));
            
            % Verify we can drop duplicates based on a several columns as
            % separate arguments
            dsColorPet = DS.dropDuplicates("FavColor", "Pet");
            % dsColorPet.show(20, false);
            testCase.verifyEqual(int64(dsColorPet.count()), int64(5));

            % Verify we can drop duplicates based on a several columns as
            % a list of arguments
            dsColorPetArr = DS.dropDuplicates(["FavColor", "Pet"]);
            % dsColorPetArr.show(20, false);
            testCase.verifyEqual(int64(dsColorPetArr.count()), int64(5));
        end

	function testSample(testCase)
            % get a sample of rows
            flights = testCase.ds;

            % get sample from the dataset
            sampleNum = 0.1;
            flightSample = flights.sample(sampleNum);
            
            sampleSize = flightSample.count();
            % verify that sample size has roughly the expected number of 
            % rows 
            
            ratioNum = sampleSize/testCase.count;
            
            diffNum = abs(ratioNum - sampleNum);
            % The ratio will not be exactly 0.1, so we have to add some
            % extra room
            testCase.verifyTrue(diffNum <= 0.05);
            
            % verify sample is between 0 and 1
            errID = 'MATLAB:validators:mustBePositive';
            testCase.verifyError(@()flights.sample(-0.2), errID);

            errID = 'MATLAB:validators:mustBeLessThan';
            testCase.verifyError(@()flights.sample(1.1), errID);
            
        end
        
        function testJoin(testCase)
            
            spark = testCase.sparkSession;
            leftStrct = struct('Name', {'ABC', 'DEF', 'HIJ'}, ...
                'Age', {21, 22, 23});
            rightStrct = struct('Address', {'1 ABC', '2 DEF', '3 HIJ'}, ...
                'Name', {'ABC', 'DEF', 'HIJ'}, ...
                'Car',{'Honda', 'Toyota', 'Morgan'});
            
            leftTbl = struct2table(leftStrct);
            rightTbl = struct2table(rightStrct);
            
            leftDS = matlab.sparkutils.table2dataset(leftTbl, spark);
            rightDS = matlab.sparkutils.table2dataset(rightTbl, spark);

            joinedDS = leftDS.join(rightDS, on='Name');            

            % verify the number of rows is as expected
            testCase.assertEqual(int64(joinedDS.count()), int64(3));
            % ensure columns were joined
            cols = joinedDS.columns();
            testCase.assertEqual(numel(cols), 4);
            % Verify column names
            testCase.verifyEmpty(setdiff(cols, ...
                {'Name', 'Age', 'Address', 'Car'}));
            
            % % Verify inputs dataset input
            % testCase.verifyError(@()leftDS.join(leftTbl, 'Name'),...
            %     'SPARK:ERROR');
            % % Verify column must be in common
            % testCase.verifyError(@()show(leftDS.join(rightDS, 'Age')), ...
            %     'SPARK:ERROR');
            % testCase.verifyError(@()show(rightDS.join(leftDS, 'Car')), ...
            %     'SPARK:ERROR');

        end
        
        function testDrop(testCase)
            % Create a flights dataset
            flights = testCase.ds;
            
            % Record the original number of columns
            originalNumCols = numel(flights.columns);
            
            % Drop a column
            gbds = flights.drop("Year");
            oneColumnMissingCount = numel(gbds.columns);
            
            % Drop multiple columns
            prunedDS = flights.drop(["Year","Month","FlightNum"]);
            threeColsMissingCount = numel(prunedDS.columns);
            
            % Verify we see the right counts and outputs
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            
            testCase.verifyClass(gbds, objType);
            testCase.verifyEqual(oneColumnMissingCount, originalNumCols-1);
            testCase.verifyEqual(threeColsMissingCount, originalNumCols-3);
            
        end
        
    end
end

