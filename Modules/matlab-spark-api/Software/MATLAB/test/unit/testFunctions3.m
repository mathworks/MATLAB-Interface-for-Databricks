classdef testFunctions3 < matlab.unittest.TestCase
    % TESTFUNCTIONS3 Unit tests for the Spark SQL functions (part 3)

    % Copyright 2026 MathWorks, Inc.
    
    properties
        spark;
        isDatabricks;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Setup: testFunctions3');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            testCase.isDatabricks = isDatabricksEnvironment;
            
            appName = 'FunctionsUnitTests3';
            if testCase.isDatabricks
                testCase.spark = getDatabricksSession();
                % testCase.spark = getDatabricksSession(serverless=true);
            else
                testCase.spark = getDefaultSparkSession(appName=appName);
            end
        end
    end
    
    methods (Test)
        
        function testUpper(testCase)
            df = testCase.spark.createDataFrame(["Spark"; "PySpark"; "Pandas API"], schema="STRING");
            out = df.select("*", matlab.pyspark.sql.functions.upper("STRING"));
            outT = out.table();
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.STRING, ["Spark"; "PySpark"; "Pandas API"]);
            expected = ["SPARK"; "PYSPARK"; "PANDAS API"];
            testCase.verifyEqual(outT.("upper(STRING)"), expected);
        end

        function testToBinary(testCase)
            % Convert string to a binary with encoding specified
            df = testCase.spark.createDataFrame("abc", schema="e");
            row = df.select(matlab.pyspark.sql.functions.to_binary(df.e, matlab.pyspark.sql.functions.lit("utf-8")).alias('r')).collect();
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            %   [Row(r=bytearray(b'abc'))]
            cellVal = cell(row.toPy);
            byteVals = uint8(cellVal{1});         
            testCase.verifyEqual(byteVals(1), uint8('a'));
            testCase.verifyEqual(byteVals(2), uint8('b'));
            testCase.verifyEqual(byteVals(3), uint8('c'));

            % Convert string to a binary with encoding specified - no lit
            df = testCase.spark.createDataFrame("abc", schema="e");
            row = df.select(matlab.pyspark.sql.functions.to_binary(df.e, "utf-8").alias('r')).collect();
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            %   [Row(r=bytearray(b'abc'))]
            cellVal = cell(row.toPy);
            byteVals = uint8(cellVal{1});         
            testCase.verifyEqual(byteVals(1), uint8('a'));
            testCase.verifyEqual(byteVals(2), uint8('b'));
            testCase.verifyEqual(byteVals(3), uint8('c'));
            
            % Convert string to binary without encoding specified, asDict
            % in this case
            df = testCase.spark.createDataFrame("414243", schema="e");
            row = df.select(matlab.pyspark.sql.functions.to_binary(df.e).alias('r')).collect();
            % [Row(r=bytearray(b'ABC'))]
            pyDict = row.toPy.asDict;
            str = char(uint8(pyDict.get('r')));
            testCase.verifyEqual(str, 'ABC');

            % Use hex data
            df = testCase.spark.createDataFrame("abc", schema="txt");
            df2 = df.select("txt", matlab.pyspark.sql.functions.hex("txt").alias("hex_value"));
            row = df2.select(matlab.pyspark.sql.functions.to_binary(df2.hex_value, "hex").alias('r')).collect();
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            cellVal = cell(row.toPy);
            byteVals = uint8(cellVal{1});
            testCase.verifyEqual(byteVals(1), uint8('a'));
            testCase.verifyEqual(byteVals(2), uint8('b'));
            testCase.verifyEqual(byteVals(3), uint8('c'));
        end

        function testContains(testCase)
            df = testCase.spark.createDataFrame(["Spark SQL", "Spark"], schema=["a","b"]);
            row = df.select(contains(df.a, df.b).alias('r')).collect();
            % returns Row(r=True)
            testCase.verifyTrue(row.r);
            df = testCase.spark.createDataFrame(py.str('[("414243", "4243",)]'), schema=["c", "d"]);
            df = df.select(matlab.pyspark.sql.functions.to_binary("c").alias("c"), matlab.pyspark.sql.functions.to_binary("d").alias("d"));
            %   df.printSchema()
            df = df.select(matlab.pyspark.sql.functions.contains("c", "d"), matlab.pyspark.sql.functions.contains("d", "c"));
            outT = table(df);
            testCase.verifyEqual(height(outT), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.("contains(c, d)"), true);
            testCase.verifyEqual(outT.("contains(d, c)"), false);
        end

        function testAsc(testCase)
            % Sort DataFrame by ‘id’ column in ascending order.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
            outT = table(df.sort(matlab.pyspark.sql.functions.asc("id")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([2,3,4]'));
            testCase.verifyEqual(outT.value, ["C", "A", "B"]');

            % Use asc in orderBy function to sort the DataFrame.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
            outT = table(df.orderBy(matlab.pyspark.sql.functions.asc("value")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([3,4,2]'));
            testCase.verifyEqual(outT.value, ["A", "B", "C"]');

            % Combine asc with desc to sort by multiple columns.
            df = testCase.spark.createDataFrame(py.str("[(2, 'A', 4), (1, 'B', 3), (3, 'A', 2)]"), schema=["id", "group", "value"]);
            outT = table(df.sort(matlab.pyspark.sql.functions.asc("group"), matlab.pyspark.sql.functions.desc("value")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([2,3,1]'));
            testCase.verifyEqual(outT.group, ["A", "A", "B"]');
            testCase.verifyEqual(outT.value, int64([4,2,3]'));

            % Implement asc from column expression.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema = ["id", "value"]);
            outT = table(df.sort(df.id.asc()));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([2,3,4]'));
            testCase.verifyEqual(outT.value, ["C", "A", "B"]');
        end

        function testDsc(testCase)
            % Sort DataFrame by ‘id’ column in descending order.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
            outT = table(df.sort(matlab.pyspark.sql.functions.desc("id")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([4,3,2]'));
            testCase.verifyEqual(outT.value, ["B", "A", "C"]');

            % Use desc in orderBy function to sort the DataFrame.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
            outT = table(df.orderBy(matlab.pyspark.sql.functions.desc("value")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([2,4,3]'));
            testCase.verifyEqual(outT.value, ["C", "B", "A"]');

            % Combine asc with desc to sort by multiple columns.
            df = testCase.spark.createDataFrame(py.str("[(2, 'A', 4), (1, 'B', 3), (3, 'A', 2)]"), schema= ["id", "group", "value"]);
            outT = table(df.sort(matlab.pyspark.sql.functions.desc("group"), matlab.pyspark.sql.functions.asc("value")));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([1,3,2]'));
            testCase.verifyEqual(outT.value, int64([3,2,4]'));
            testCase.verifyEqual(outT.group, ["B", "A", "A"]');

            % Implement desc from column expression.
            df = testCase.spark.createDataFrame(py.str("[(4, 'B'), (3, 'A'), (2, 'C')]"), schema=["id", "value"]);
            outT = table(df.sort(df.id.desc()));
            testCase.verifyEqual(height(outT), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.id, int64([4,3,2]'));
            testCase.verifyEqual(outT.value, ["B", "A", "C"]');
        end

        function testConcat(testCase)
            % Concatenating string columns
            df = testCase.spark.createDataFrame(["abcd", "123"], schema=["s", "d"]);
            outT = table(df.select(matlab.pyspark.sql.functions.concat(df.s, df.d)));
            testCase.verifyEqual(height(outT), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(outT.("concat(s, d)"), "abcd123");

            % Concatenating array columns
            if ~isMATLABReleaseOlderThan('R2026a')
                df = testCase.spark.createDataFrame(py.str("[([1, 2], [3, 4], [5]), ([1, 2], None, [3])]"), schema=["a", "b", "c"]);
                df2 = df.select(matlab.pyspark.sql.functions.concat(df.a, df.b, df.c));
                outT = df2.table();
                testCase.verifyEqual(height(outT), 2, 'The number of rows does not match the expected output.');
                testCase.verifyEqual(outT{1,1}{1}, int64([1,2,3,4,5]));
            end
        end
    end
end