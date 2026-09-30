classdef testWindowing < matlab.unittest.TestCase
    % testWindowing Unit tests for the Spark Dataset Windowing
    
    % Copyright 2026 MathWorks, Inc.
    
    properties
        alicebob 
        tomalicebob
        idcat
        ids
        sparkSession;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Setup: testWindowing');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');
            % Create a Spark configuration and shared Spark session

            isDatabricks = isDatabricksEnvironment();
            
            appName = 'WindowingUnitTests';
            
            if isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            testCase.alicebob = spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), ...
                schema=["age", "name"]);

            testCase.tomalicebob = spark.createDataFrame( ...
                py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);

            testCase.idcat = spark.createDataFrame(py.str('[(1, "a"), (1, "a"), (2, "a"), (1, "b"), (2, "b"), (3, "b")]'), ...
                schema=["id", "category"]);

            testCase.ids = spark.createDataFrame(py.str('[1, 1, 2, 3, 3, 4]'), schema='value');
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testOver(testCase)
            % testOver
            % Test creation and results borrowed from:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Column.over.html#pyspark.sql.Column.over
            import matlab.pyspark.sql.Window
            df = testCase.alicebob;
            window = Window.partitionBy("name") ...
                .orderBy("age") ...
                .rowsBetween(Window.unboundedPreceding, Window.currentRow);

            out = df.withColumn("rank", matlab.pyspark.sql.functions.rank().over(window)) ...
                .withColumn("min", matlab.pyspark.sql.functions.min('age').over(window)) ...
                .sort(matlab.pyspark.sql.functions.desc("age"));
            outT = out.table();
            
            testCase.verifyEqual(outT.age, int64([5;2]), "age problem")
            testCase.verifyEqual(outT.name, ["Bob"; "Alice"], "name problem")
            testCase.verifyEqual(outT.rank, int32([1;1]), "rank problem")
            testCase.verifyEqual(outT.min, int64([5;2]), "min problem")
            % +---+-----+----+---+
            % |age| name|rank|min|
            % +---+-----+----+---+
            % |  5|  Bob|   1|  5|
            % |  2|Alice|   1|  2|
            % +---+-----+----+---+
        end
        
        function testWindowOrderPartition(testCase)
            % testWindowOrderPartition
            % Test creation and results borrowed from:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Window.orderBy.html
            import matlab.pyspark.sql.Window
            df = testCase.idcat;

            window = Window.partitionBy("id").orderBy("category");
            out = df.withColumn("row_number", matlab.pyspark.sql.functions.row_number().over(window));

            outT = out.table();
            testCase.verifyEqual(outT.id, int64([1,1,1,2,2,3]'), "idproblem")
            testCase.verifyEqual(outT.category, ["a", "a", "b", "a", "b", "b"]', "category problem")
            testCase.verifyEqual(outT.row_number, int32([1,2,3,1,2,1]'), "min problem");
            % +---+--------+----------+
            % | id|category|row_number|
            % +---+--------+----------+
            % |  1|       a|         1|
            % |  1|       a|         2|
            % |  1|       b|         3|
            % |  2|       a|         1|
            % |  2|       b|         2|
            % |  3|       b|         1|
            % +---+--------+----------+
        end

        function testRepartitionByRange(testCase)
            % testRepartitionByRange
            % Test creation and results borrowed from:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.repartitionByRange.html
            import matlab.pyspark.sql.Window
            df = testCase.tomalicebob;
            out = df.repartitionByRange(2, "age") ...
                .select("age", "name", matlab.pyspark.sql.functions.spark_partition_id());
            outT = out.table();
            testCase.verifyEqual(outT.age, int64([14; 16; 23]), "age problem")
            testCase.verifyEqual(outT.name, ["Tom"; "Bob"; "Alice"], "name problem")
            testCase.verifyEqual(outT.("SPARK_PARTITION_ID()"), int32([0;0;1]), "partition_id problem")

            % +---+-----+--------------------+
            % |age| name|SPARK_PARTITION_ID()|
            % +---+-----+--------------------+
            % | 14|  Tom|                   0|
            % | 16|  Bob|                   0|
            % | 23|Alice|                   1|
            % +---+-----+--------------------+
        end

        function testPercentRank(testCase)
            % testPercentRank
            % Test creation and results borrowed from:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.percent_rank.html
            import matlab.pyspark.sql.Window
            df = testCase.ids;
            w = Window.orderBy("value");
            out = df.withColumn("pr", matlab.pyspark.sql.functions.percent_rank().over(w));
            outT = out.table();
            testCase.verifyEqual(outT.value, int64([1,1,2,3,3,4]'), "value problem")
            testCase.verifyLessThan(max(abs(outT.pr-[0, 0, 0.4, 0.6, 0.6, 1]')), 1e-10, "pr problem")
            % +-----+---+
            % |value| pr|
            % +-----+---+
            % |    1|0.0|
            % |    1|0.0|
            % |    2|0.4|
            % |    3|0.6|
            % |    3|0.6|
            % |    4|1.0|
            % +-----+---+
        end
    end
end
