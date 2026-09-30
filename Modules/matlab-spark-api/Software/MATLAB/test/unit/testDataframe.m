classdef testDataframe < matlab.unittest.TestCase
    % TESTDATAFRAME Unit tests for Dataframe

    % Copyright 2026 MathWorks, Inc.

    properties
        spark
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            isDatabricks = isDatabricksEnvironment();
            appName = 'DataframeUnitTests';
            if isDatabricks
                testCase.spark = getDatabricksSession();
                % testCase.spark = getDatabricksSession(serverless=true);
            else
                testCase.spark = getDefaultSparkSession(appName=appName);
            end
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testRepartitionByRange(testCase)
            % Tests the doc example
            df = testCase.spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), schema=["age", "name"]);
            df2 = df.repartitionByRange(2, "age").select("age", "name", matlab.pyspark.sql.functions.spark_partition_id());
            T = table(df2);
            testCase.verifyEqual(T.age(1), int64(2));
            testCase.verifyEqual(T.age(2), int64(5));
            testCase.verifyEqual(T.name(1), "Alice");
            testCase.verifyEqual(T.name(2), "Bob");
            testCase.verifyEqual(T{1,3}, int32(0));
            testCase.verifyEqual(T{2,3}, int32(1));
        end

        function testCollect1(testCase)
            % Collecting all rows of a DataFrame
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            row = df.collect();
            %   [Row(age=14, name='Tom'), Row(age=23, name='Alice'), Row(age=16, name='Bob')]
            pd = row(1).toPy.asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(14));
            name = d('name');
            testCase.verifyEqual(name{1}, "Tom");
        end

        function testCollect2(testCase)
            % Collecting all rows after filtering
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            row = df.filter(df.age > 15).collect();
            %   [Row(age=23, name='Alice'), Row(age=16, name='Bob')]
            pd = row(1).toPy.asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(23));
            name = d('name');
            testCase.verifyEqual(name{1}, "Alice");
        end

        function testCollect3(testCase)
            % Collecting all rows after selecting specific columns
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            row = df.select("name").collect();
            % [Row(name='Tom'), Row(name='Alice'), Row(name='Bob')]
            d1 = row(1).asMATLABDict;
            d2 = row(2).asMATLABDict;
            d3 = row(3).asMATLABDict;
            testCase.verifyEqual(d1('name'), "Tom");
            testCase.verifyEqual(d2('name'), "Alice");
            testCase.verifyEqual(d3('name'), "Bob");
        end
  
        function testCollect4(testCase)
            % Collecting all rows from a DataFrame and converting a specific
            % column to a cell array
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            rows = df.collect();
            result = rows.bracket("name");
            testCase.verifyEqual(result{1}, 'Tom');
            testCase.verifyEqual(result{2}, 'Alice');
            testCase.verifyEqual(result{3}, 'Bob');
        end

        function testCollect5(testCase)
            % Collecting all rows after applying a function to a column
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            row = df.select(matlab.pyspark.sql.functions.upper(df.name)).collect();
            d1 = row(1).asMATLABDict;
            d2 = row(2).asMATLABDict;
            d3 = row(3).asMATLABDict;
            testCase.verifyEqual(d1('upper(name)'), "TOM");
            testCase.verifyEqual(d2('upper(name)'), "ALICE");
            testCase.verifyEqual(d3('upper(name)'), "BOB");
        end

        function testCollect6(testCase)
            % Collecting all rows from a DataFrame and converting to a list of dictionaries
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            rows = df.collect();
            for n = 1:numel(rows)
                d{n} = rows(n).asMATLABDict();
            end
            testCase.verifyEqual(d{1}("name"), {"Tom"});
            testCase.verifyEqual(d{2}("name"), {"Alice"});
            testCase.verifyEqual(d{3}("name"), {"Bob"});

            testCase.verifyEqual(d{1}("age"), {py.int(14)});
            testCase.verifyEqual(d{2}("age"), {py.int(23)});
            testCase.verifyEqual(d{3}("age"), {py.int(16)});
        end

        function testExplain(testCase)
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            df.explain();
            df.explain(extended=true);
            df.explain(mode="formatted");
            df.explain(mode="cost");
            df.explain(mode="CoSt");
            df.explain(mode="simple");
            df.explain(mode="extended");
            df.explain(mode="codegen");

            errId = "SPARKAPI:DATAFRAME:explain_arguments";
            fn = @() df.explain(mode="CoSt", extended=true);
            testCase.verifyError(fn, errId);

        end
    end
end
