classdef testSparkSession < matlab.unittest.TestCase
    % TESTSPARKSESSION Unit tests for the Spark Session abstraction

    % (c) 2019-2021 MathWorks, Inc.
    properties
        sparkSession;
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            % Create shared Spark session

            % This will create a singleton SparkSession using the getOrCreate() method
            spark = getDatabricksSession();
            testCase.sparkSession = spark;
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testCreateSparkSession(testCase)
            % Fetch the spark session
            spark = testCase.sparkSession;

            % Verify that we can create a valid sparkSession
            if isa(spark, 'matlab.pyspark.sql.session.SparkSession')
                % All good
            else
                testCase.verifyTrue(false, 'Bad class for spark session');
            end
            testCase.verifyNotEmpty(spark.sparkSession);

            %% Store the sparkContext
            testCase.sparkSession = spark;
        end

        function verifySingletonBehavior(testCase)
            % Call getDatabricksSession again, verify that it is the
            % exact same Java object underneath
            spark = testCase.sparkSession;
            spark2 = getDatabricksSession();
            testCase.verifyTrue(spark.toPy==spark2.toPy)

            sparkNew = getDatabricksSession(forceNewSession=true);
            testCase.verifyFalse(spark.toPy==sparkNew.toPy)
        end

        function readCSVSampleFile(testCase)
            disp('Reading CSV using Spark');

            % Fetch the spark session
            spark = testCase.sparkSession;

            % if strcmp('DATABRICKS_RUNTIME_VERSION','13.3')
            %     disp("=====Spark session debug=======");
            %     s = spark.sparkSession
            %     s.isTraceEnabled
            %     getenv('SPARK_CONNECT_LOG_LEVEL')
            %     c = s.client
            %     cfg = c.configuration
            %     cfg.port
            %     cfg.userName
            %     cfg.userId
            %     cfg.userAgent
            %     cfg.token
            %     cfg.host
            %     cfg.isSslEnabled
            %     cfg.metadata
            %     disp("===============================");
            % end

            % This file needs to exist on the Databricks cluster for this
            % test to pass
            inputLocation = '/MathWorks/unit-test/data/airlinesmall.csv';

            % Create a dataframe by pointing to all the CSV content
            tic;
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(inputLocation);
            numRows = sparkDataSet.count();
            toc;

            % Verify that we have valid dataset
            testCase.verifyClass(sparkDataSet,'matlab.pyspark.sql.dataframe.Dataframe');
            testCase.verifyNotEmpty(sparkDataSet.dataframe);

            testCase.verifyGreaterThan(numRows, 0);
        end

        function testSQL(testCase)

            % Fetch the spark session
            spark = testCase.sparkSession;


            % Call query
            outDF = spark.sql("USE CATALOG samples");
            testCase.verifyClass(outDF,'matlab.pyspark.sql.dataframe.Dataframe');

            outDF = spark.sql("USE DATABASE nyctaxi");
            testCase.verifyClass(outDF,'matlab.pyspark.sql.dataframe.Dataframe');

            outDF = spark.sql("SELECT * FROM trips LIMIT 100");
            testCase.verifyClass(outDF,'matlab.pyspark.sql.dataframe.Dataframe');

            outDF = spark.sql("USE CATALOG hive_metastore");
            testCase.verifyClass(outDF,'matlab.pyspark.sql.dataframe.Dataframe');

            outDF = spark.sql("USE DATABASE default");
            testCase.verifyClass(outDF,'matlab.pyspark.sql.dataframe.Dataframe');

        end

        function testTableString(testCase)

            % Fetch the spark session
            spark = testCase.sparkSession;

            % Call query
            myDS = spark.table("airlinesmall_csv");
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');

        end

        function testRangeCreation(testCase)

            % Fetch the spark session
            spark = testCase.sparkSession;

            % Create a range of 10 long integers
            myDS = spark.range(0,10);
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');

            % Create a range of 20 long integers with a step size of 2
            myDS = spark.range(0, 20, 2);
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');

            % Create a range with a specific number of partitions (5 in this case)
            myDS = spark.range(0, 20, 2, 5);
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');

        end

        function testLongSupport(testCase)

            % Fetch the spark session
            spark = testCase.sparkSession;

            % Create a range of 10 long integers
            myDS = spark.range(0,10);
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');


            % Cast into a MATLAB table
            matlabTable = table(myDS);
            testCase.verifyClass(matlabTable,'table');

            % Check for the right types
            testCase.verifyClass(matlabTable.id, 'int64');

        end

        function testTableSupport(testCase)

            % Fetch the spark session
            spark = testCase.sparkSession;

            % Read a known table marshal into MATLAB
            myDS = spark...
                .read.format('delta')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load('/MathWorks/unit-test/data/medium');

            % Verify we have a dataset
            testCase.verifyClass(myDS,'matlab.pyspark.sql.dataframe.Dataframe');


            % Cast the dataset into a MATLAB table
            matlabTable = table(myDS.limit(100));
            testCase.verifyClass(matlabTable,'table');

            % Note that the types for this sample dataslice uses the
            % following schema. Additional assertions are needed here.
            % StructType@27489
            %     "StructType(StructField(Year,IntegerType,true),
            %      StructField(Month,IntegerType,true),
            %      StructField(DayofMonth,IntegerType,true),
            %      StructField(DayOfWeek,IntegerType,true),
            %      StructField(DepTime,StringType,true),
            %      StructField(CRSDepTime,IntegerType,true),
            %      StructField(ArrTime,StringType,true),
            %      StructField(CRSArrTime,IntegerType,true),
            %      StructField(UniqueCarrier,StringType,true),
            %      StructField(FlightNum,IntegerType,true),
            %      StructField(TailNum,StringType,true),
            %      StructField(ActualElapsedTime,StringType,true),
            %      StructField(CRSElapsedTime,StringType,true),
            %      StructField(AirTime,StringType,true),
            %      StructField(ArrDelay,StringType,true),
            %      StructField(DepDelay,StringType,true),
            %      StructField(Origin,StringType,true),
            %      StructField(Dest,StringType,true),
            %      StructField(Distance,IntegerType,true),
            %      StructField(TaxiIn,StringType,true),
            %      StructField(TaxiOut,StringType,true),
            %      StructField(Cancelled,IntegerType,true),
            %      StructField(CancellationCode,StringType,true),
            %      StructField(Diverted,IntegerType,true),
            %      StructField(CarrierDelay,StringType,true),
            %      StructField(WeatherDelay,StringType,true),
            %      StructField(NASDelay,StringType,true),
            %      StructField(SecurityDelay,StringType,true),
            %      StructField(LateAircraftDelay,StringType,true))"
        end
    end
end
