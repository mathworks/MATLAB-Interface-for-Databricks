classdef testFunctions2 < matlab.unittest.TestCase
    % TESTFUNCTIONS2 Unit tests for the Spark SQL functions (part 2)
    
    % Copyright 2026 MathWorks, Inc.
    
    properties
        spark;
        isDatabricks;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Setup: testFunctions2');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            testCase.isDatabricks = isDatabricksEnvironment;
            
            appName = 'FunctionsUnitTests2';
            if testCase.isDatabricks
                testCase.spark = getDatabricksSession();
                % testCase.spark = getDatabricksSession(serverless=true);
            else
                testCase.spark = getDefaultSparkSession(appName=appName);
            end
        end
    end
    
    methods (Test)
        
        function testAcoshFunction(testCase)
            % testAcoshFunction
            % Test creation and results based on:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.acosh.html
            
            df = testCase.spark.sql("SELECT EXPLODE(ARRAY(1.0, 2.0, 5.0)) AS value");
            out = df.select(matlab.pyspark.sql.functions.acosh(df.col('value')));
            outT = out.table();
            
            expected = [0.0; 1.3169578969248166; 2.292431669561177];
            % Can't address like this because the () make it not a valid variable name
            % actual = outT.("ACOSH(value)");
            actual = outT{:,1};
            
            testCase.verifyLessThan(max(abs(actual - expected)), 1e-10, "acosh results do not match expected values");
        end

        function testAcoshExample(testCase)
            % testAcoshExample
            % Test the example provided in the acosh.m documentation
            
            value = [1.0; 2.0; 5.0];
            T = table(value);
            df = matlab.sparkutils.table2dataset(T, testCase.spark);
            
            out = df.select(matlab.pyspark.sql.functions.acosh(df.col("value")).alias("acosh_value"));
            outT = out.table();
            
            expected = [0.0; 1.3169578969248166; 2.292431669561177];
            actual = outT.acosh_value;
            
            testCase.verifyLessThan(max(abs(actual - expected)), 1e-10, "acosh example results do not match expected values");
        end


        function testE(testCase)
            df = testCase.spark.range(1).select(matlab.pyspark.sql.functions.e());
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, exp(1), "AbsTol", 1e-10);
        end


        function testPi(testCase)
            df = testCase.spark.range(1).select(matlab.pyspark.sql.functions.pi());
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, pi, "AbsTol", 1e-10);
        end

        
        function testSinhFunction(testCase)
            df = testCase.spark.createDataFrame([-1; 0; 1], schema="value");
            df2 = df.select(matlab.pyspark.sql.functions.sinh("value"));
            T = table(df2);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, sinh(-1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,1}, sinh(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,1}, sinh(1), "AbsTol", 1e-10);

            df = testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.sinh("value"));
            T = table(df);
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, sinh(NaN));
            testCase.verifyEqual(T{2,2}, sinh(NaN));
        end


        function testAsinh(testCase)
            df = testCase.spark.createDataFrame(py.str('[(-0.5,), (0.0,), (0.5,)]'), schema="value");
            T = table(df.select("*", matlab.pyspark.sql.functions.asinh(df.value)));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, asinh(-0.5), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, asinh(0.0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, asinh(0.5), "AbsTol", 1e-10);

            T= table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.asinh("value")));
            testCase.verifyEqual(T{1,2}, sinh(NaN));
            testCase.verifyEqual(T{2,2}, sinh(NaN));
        end


        function testSin(testCase)
            T = table(testCase.spark.sql("SELECT * FROM VALUES (0.0), (PI() / 2), (PI() / 4) AS TAB(value)").select("*", matlab.pyspark.sql.functions.sin("value")));
            testCase.verifyEqual(T{1,2}, sin(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, sin(pi/2), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, sin(pi/4), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.sin("value")));
            testCase.verifyEqual(T{1,2}, sin(NaN));
            testCase.verifyEqual(T{2,2}, sin(NaN));
        end


        function testSqrt(testCase)
            T = table(testCase.spark.sql("SELECT * FROM VALUES (-1), (0), (1), (4), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.sqrt("value")));
            testCase.verifyEqual(height(T), 5, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, NaN); % does not return complex result 
            testCase.verifyEqual(T{2,2}, sqrt(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, sqrt(1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{4,2}, sqrt(4), "AbsTol", 1e-10);
            testCase.verifyEqual(T{5,2}, NaN);
        end


        function testTan(testCase)
            T = table(testCase.spark.sql("SELECT * FROM VALUES (0.0), (PI() / 4), (PI() / 6) AS TAB(value)").select("*", matlab.pyspark.sql.functions.tan("value")));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, tan(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, tan(pi/4), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, tan(pi/6), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.tan("value")));
            testCase.verifyEqual(T{1,2}, tan(NaN));
            testCase.verifyEqual(T{2,2}, tan(NaN));
        end


        function testTanh(testCase)
            T = table(testCase.spark.createDataFrame([-1; 0; 1], schema="value").select("*", matlab.pyspark.sql.functions.tanh("value")));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, tanh(-1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, tanh(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, tanh(1), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.tanh("value")));
            testCase.verifyEqual(T{1,2}, tanh(NaN));
            testCase.verifyEqual(T{2,2}, tanh(NaN));
        end


        function testRandn(testCase)
            T = table(testCase.spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn()));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyTrue(isnumeric(T{1,2}), 'Output should be numeric.');
            testCase.verifyTrue(isnumeric(T{2,2}), 'Output should be numeric.');

            T1 = table(testCase.spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn(int64(42))));
            T2 = table(testCase.spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn(42)));
            testCase.verifyEqual(height(T1), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(height(T2), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T1{1,2}, T2{1,2});
            testCase.verifyEqual(T1{1,2}, T2{1,2});
        end


        function testRandstr(testCase)
            rtVerSV = matlab.utils.SemVer(testCase.spark.RuntimeVersion);
            if (testCase.isDatabricks && rtVerSV >= "17") || (isApacheSparkEnvironment && rtVerSV >= "4")
                T = table(testCase.spark.range(0, 10, 1, 1).select("*", matlab.pyspark.sql.functions.randstr(16,3)));
                testCase.verifyEqual(height(T), 10, 'The number of rows does not match the expected output.');
                testCase.verifyTrue(isstring(T{1,2}), 'Output should be string.');
                testCase.verifyEqual(strlength(T{1,2}), 16);
            else
                fprintf("Skipping testRandstr, requires runtime 17 or greater for Databricks, " + ...
                    "and runtime 4 or greater for Apache SPark.\n");
            end
        end


        function testAtan2(testCase)
            T = table(testCase.spark.range(1).select(py.pyspark.sql.functions.atan2(py.pyspark.sql.functions.lit(1), py.pyspark.sql.functions.lit(2))));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, 0.4636476090008061, "AbsTol", 1e-6);
        end


        function testAtanh(testCase)
            value = [1.0; 2.0; 5.0];
            Tv = table(value);
            df = matlab.sparkutils.table2dataset(Tv, testCase.spark);
            T = table(df.select(matlab.pyspark.sql.functions.atanh(df.col("value")).alias("atanh_value")));
            testCase.verifyEqual(T{1,1}, Inf);
            testCase.verifyEqual(T{2,1}, NaN);
            testCase.verifyEqual(T{2,1}, NaN);

            df = testCase.spark.createDataFrame([-0.5; 0.0; 0.5], schema="value");
            T = table(df.select("*", matlab.pyspark.sql.functions.atanh(df.value)));
            testCase.verifyEqual(T{1,2}, atanh(-0.5), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, atanh(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, atanh(0.5), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (-2), (2), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.atanh("value")));
            testCase.verifyEqual(height(T), 4, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, NaN);
            testCase.verifyEqual(T{2,2}, NaN);
            testCase.verifyEqual(T{3,2}, NaN);
            testCase.verifyEqual(T{4,2}, NaN);
        end


        function testCos(testCase)
            T = table(testCase.spark.sql("SELECT * FROM VALUES (PI()), (PI() / 4), (PI() / 16) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cos("value")));
            testCase.verifyEqual(T{1,2}, cos(pi), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, cos(pi/4), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, cos(pi/16), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cos("value")));
            testCase.verifyEqual(T{1,2}, cos(NaN));
            testCase.verifyEqual(T{2,2}, cos(NaN));
        end


        function testCosh(testCase)
            T = table(testCase.spark.createDataFrame([-1; 0; 1], schema="value").select("*", matlab.pyspark.sql.functions.cosh("value")));
            testCase.verifyEqual(T{1,2}, cosh(-1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, cosh(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, cosh(1), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cos("value")));
            testCase.verifyEqual(T{1,2}, cosh(NaN));
            testCase.verifyEqual(T{2,2}, cosh(NaN));
        end
        

        function testCot(testCase)
            T = table(testCase.spark.sql("SELECT * FROM VALUES (PI() / 4), (PI() / 16) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cot("value")));
            testCase.verifyEqual(T{1,2}, cot(pi/4), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, cot(pi/16), "AbsTol", 1e-10);

            T = table(testCase.spark.sql("SELECT * FROM VALUES (0.0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*", matlab.pyspark.sql.functions.cot("value")));
            testCase.verifyEqual(T{1,2}, cot(0));
            testCase.verifyEqual(T{2,2}, cot(NaN));
            testCase.verifyEqual(T{3,2}, cot(NaN));
        end


        function testCount(testCase)
            df = testCase.spark.createDataFrame([missing; "a"; "b"; "c"], schema="alphabets");
            T = table(df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(4));

            T = table(df.select(matlab.pyspark.sql.functions.count(df.alphabets)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(3));

            df = testCase.spark.createDataFrame(py.str('[(1, "apple"), (2, "banana"), (3, None)]'), schema=["id", "fruit"]);
            T = table(df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(3));

            df = testCase.spark.createDataFrame(py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})}), schema=["id", "fruit"]);
            T = table(df.select(matlab.pyspark.sql.functions.count(matlab.pyspark.sql.functions.expr("*"))));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(3));

            T = table(df.select(matlab.pyspark.sql.functions.count(df.id), matlab.pyspark.sql.functions.count(df.fruit)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(3));
            testCase.verifyEqual(T{1,2}, int64(2));
        end


        function testCount_Distinct(testCase)
            df = testCase.spark.createDataFrame(py.str('[(1,), (1,), (3,)]'), schema=["value"]); %#ok<NBRAK1>
            T = table(df.select(matlab.pyspark.sql.functions.count_distinct(df.value)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(2));

            df = testCase.spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"]);
            T = table(df.select(matlab.pyspark.sql.functions.count_distinct(df.value1, df.value2)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(2));

            df = testCase.spark.createDataFrame(py.str('[(1, 1), (1, 2)]'), schema=["value1", "value2"]);
            T = table(df.select(matlab.pyspark.sql.functions.count_distinct("value1", "value2")));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(2));
        end


        function testCurrentTimezone(testCase)
            T = table(testCase.spark.range(1).select(matlab.pyspark.sql.functions.current_timezone()));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            if testCase.isDatabricks
                testCase.verifyEqual(T{1,1}, "Etc/UTC");
            elseif isApacheSparkEnvironment
                testCase.verifyTrue(strlength(T{1,1}) >= 3);
            end
        end


        function testCurrentUser(testCase)
            T = table(testCase.spark.range(1).select(matlab.pyspark.sql.functions.current_user()));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            userName = T{1,1};
            if isDatabricksEnvironment
                testCase.verifyTrue(contains(userName, "@"));
                testCase.verifyTrue(endsWith(userName, ".com")); % assumes a .com email address
            else
                pat = '^[a-z][-a-z0-9_]*\$?$';

                % Validate the username against the regex pattern
                [sIdx, eIdx] = regexp(userName, pat, 'once');

                testCase.verifyTrue(isscalar(sIdx));
                testCase.verifyTrue(isscalar(eIdx));
                testCase.verifyEqual(sIdx, 1);
                testCase.verifyEqual(eIdx, strlength(userName));
            end
        end


        function testExp(testCase)
            df = testCase.spark.sql("SELECT id AS value FROM RANGE(5)");
            T = table(df.select("*", matlab.pyspark.sql.functions.exp(df.value)));
            testCase.verifyEqual(height(T), 5, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, exp(0), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, exp(1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, exp(2), "AbsTol", 1e-10);
            testCase.verifyEqual(T{4,2}, exp(3), "AbsTol", 1e-10);
            testCase.verifyEqual(T{5,2}, exp(4), "AbsTol", 1e-10);
        end


        function testExpr(testCase)
            df = testCase.spark.createDataFrame(["Alice"; "Bob"], schema="name");
            T = table(df.select("*", matlab.pyspark.sql.functions.expr("length(name)")));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, int32(5));
            testCase.verifyEqual(T{2,2}, int32(3));
        end


        function testIsnan(testCase)
            df = testCase.spark.createDataFrame(py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})}), schema=["a", "b"]);
            T = table(df.select("*", matlab.pyspark.sql.functions.isnan("a"), matlab.pyspark.sql.functions.isnan(df.b)));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,3}, false);
            testCase.verifyEqual(T{1,4}, true);
            testCase.verifyEqual(T{2,3}, true);
            testCase.verifyEqual(T{2,4}, false);
        end


        function testIsNotNull(testCase)
            df = testCase.spark.createDataFrame({py.None; 1}, schema="e");
            T = table(df.select('*', matlab.pyspark.sql.functions.isnotnull(df.e)));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, false);
            testCase.verifyEqual(T{2,2}, true);

            T = table(df.select('*', matlab.pyspark.sql.functions.isnotnull('e')));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, false);
            testCase.verifyEqual(T{2,2}, true);
        end


        function testIsNull(testCase)
            df = testCase.spark.createDataFrame(py.list({py.tuple({1, py.None}), py.tuple({py.None, 2})}), schema = ["a", "b"]);
            T = table(df.select("*", matlab.pyspark.sql.functions.isnull("a"), matlab.pyspark.sql.functions.isnull(df.b)));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,3}, false);
            testCase.verifyEqual(T{1,4}, true);
            testCase.verifyEqual(T{2,3}, true);
            testCase.verifyEqual(T{2,4}, false);
        end


        function testLength(testCase)
            T = table(testCase.spark.createDataFrame("ABC ", schema="a").select('*', matlab.pyspark.sql.functions.length('a')));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, int32(4));
        end


        function testLog(testCase)
            df = testCase.spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)");
            T = table(df.select("*", matlab.pyspark.sql.functions.log(2.0, df.value)));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, log2(1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, log2(2), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, log2(4), "AbsTol", 1e-10);

            df = testCase.spark.sql("SELECT * FROM VALUES (1), (2), (0), (-1), (NULL) AS t(value)");
            T = table(df.select("*", matlab.pyspark.sql.functions.log(3.0, df.value)));
            testCase.verifyEqual(height(T), 5, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, log(1)/log(3), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, log(2)/log(3), "AbsTol", 1e-10);
            testCase.verifyTrue(isnan(T{3,2}));
            testCase.verifyTrue(isnan(T{4,2}));
            testCase.verifyEqual(T{5,2}, log(NaN)/log(3), "AbsTol", 1e-10);

            df = testCase.spark.sql("SELECT * FROM VALUES (1), (2), (4) AS t(value)");
            T = table(df.select("*", matlab.pyspark.sql.functions.log(df.value)));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, log(1), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, log(2), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, log(4), "AbsTol", 1e-10);
        end


        function testLog10(testCase)
            df = testCase.spark.createDataFrame(py.str("[(1,), (10,), (100,)]"), schema = ["value"]); %#ok<NBRAK1>
            T = table(df.select("*", matlab.pyspark.sql.functions.log10(df.value)));
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,2}, log(1)/log(10), "AbsTol", 1e-10);
            testCase.verifyEqual(T{2,2}, log(10)/log(10), "AbsTol", 1e-10);
            testCase.verifyEqual(T{3,2}, log(100)/log(10), "AbsTol", 1e-10);

            df = testCase.spark.sql("SELECT * FROM VALUES (-1), (0), (FLOAT('NAN')), (NULL) AS TAB(value)").select("*",  matlab.pyspark.sql.functions.log10("value"));
            T = table(df);
            testCase.verifyEqual(height(T), 4, 'The number of rows does not match the expected output.');
            testCase.verifyTrue(isnan(T{1,2}));
            testCase.verifyTrue(isnan(T{2,2}));
            testCase.verifyTrue(isnan(T{3,2}));
            testCase.verifyTrue(isnan(T{4,2}));
        end


        function testFirst(testCase)
            df = testCase.spark.createDataFrame(py.str('[("Alice", 2), ("Bob", 5), ("Alice", None)]'), schema=["name", "age"]);
            df = df.orderBy(df.age);
            T = table(df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age")).orderBy("name"));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "Alice");
            testCase.verifyEqual(T{1,2}, NaN);
            testCase.verifyEqual(T{2,1}, "Bob");
            testCase.verifyEqual(T{2,2}, 5); % A double because of the NaN
            
            T = table(df.groupBy("name").agg(matlab.pyspark.sql.functions.first("age", true)).orderBy("name"));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "Alice");
            testCase.verifyEqual(T{1,2}, int64(2));
            testCase.verifyEqual(T{2,1}, "Bob");
            testCase.verifyEqual(T{2,2}, int64(5));
        end

        function testCoalesce(testCase)

            % df = testCase.spark.createDataFrame(py.str("[('1997-02-28 05:02:11',)]"), schema="ts")
            % T_year = df.select('*', matlab.pyspark.sql.functions.date_trunc('year', df.ts)).table();
            % T_month = df.select('*', matlab.pyspark.sql.functions.date_trunc('mon', 'ts')).table();
            
            df = testCase.spark.createDataFrame(py.str('[(None, None), (1, None), (None, 2)]'), schema=["a", "b"]);
            T1 = df.select('*', matlab.pyspark.sql.functions.coalesce("a", df.("b"))).table();
            T2 = df.select('*', matlab.pyspark.sql.functions.coalesce(df.("a"), matlab.pyspark.sql.functions.lit(0.0))).table();

            testCase.verifyEqual(height(T1), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T1{1,1}, NaN);
            testCase.verifyEqual(T1{1,2}, NaN);
            testCase.verifyEqual(T1{1,3}, NaN);
            testCase.verifyEqual(T1{2,1}, 1);
            testCase.verifyEqual(T1{2,2}, NaN);
            testCase.verifyEqual(T1{2,3}, 1);
            testCase.verifyEqual(T1{3,1}, NaN);
            testCase.verifyEqual(T1{3,2}, 2);
            testCase.verifyEqual(T1{3,3}, 2);

            testCase.verifyEqual(height(T2), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T2{1,1}, NaN);
            testCase.verifyEqual(T2{1,2}, NaN);
            testCase.verifyEqual(T2{1,3}, 0);
            testCase.verifyEqual(T2{2,1}, 1);
            testCase.verifyEqual(T2{2,2}, NaN);
            testCase.verifyEqual(T2{2,3}, 1);
            testCase.verifyEqual(T2{3,1}, NaN);
            testCase.verifyEqual(T2{3,2}, 2);
            testCase.verifyEqual(T2{3,3}, 0);
        end

        function testDateTrunc(testCase)
            df = testCase.spark.createDataFrame(py.str("[('1997-02-28 05:02:11',)]"), schema="ts");
            T_year = df.select('*', matlab.pyspark.sql.functions.date_trunc('year', df.ts).alias('ts_year')).table();
            T_month = df.select('*', matlab.pyspark.sql.functions.date_trunc('mon', 'ts').alias('ts_year_mon')).table();

            ty = T_year.ts_year;
            tm = T_month.ts_year_mon;

            testCase.verifyEqual(ty.Year, 1997);
            testCase.verifyEqual(ty.Month, 1);
            testCase.verifyEqual(ty.Day, 1);
            testCase.verifyEqual(ty.Hour, 0);
            testCase.verifyEqual(ty.Minute, 0);
            testCase.verifyEqual(ty.Second, 0);

            testCase.verifyEqual(tm.Year, 1997);
            testCase.verifyEqual(tm.Month, 2);
            testCase.verifyEqual(tm.Day, 1);
            testCase.verifyEqual(tm.Hour, 0);
            testCase.verifyEqual(tm.Minute, 0);
            testCase.verifyEqual(tm.Second, 0);
        end


        function testArrayMax(testCase)
            % Test creation and results based on:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.array_max.html

            df = testCase.spark.createDataFrame(py.str('[([2, 1, 3],), ([None, 10, -1],)]'), schema="data");
            % df.select(matlab.pyspark.sql.functions.array_max(df.data)).show()
            T = table(df.select(matlab.pyspark.sql.functions.array_max(df.data)));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(3));
            testCase.verifyEqual(T{2,1}, int64(10));

            df = testCase.spark.createDataFrame(py.str("[(['apple', 'banana', 'cherry'],)]"), schema="data");
            T = table(df.select(matlab.pyspark.sql.functions.array_max("data")));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "cherry");

            df = testCase.spark.createDataFrame(py.str("[(['apple', 1, 'cherry'],)]"), schema='data');
            T = table(df.select(matlab.pyspark.sql.functions.array_max(df.data)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "cherry");

            df = testCase.spark.createDataFrame(py.str("[([[2, 1], [3, 4]],)]"), schema='data');
            T = table(df.select(matlab.pyspark.sql.functions.array_max(df.data)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyClass(T{1,1}, 'cell');
            testCase.verifyEqual(T{1,1}{1,1}, [int64(3), int64(4)]);
        end


        function testArrayMin(testCase)
            df = testCase.spark.createDataFrame(py.str('[([2, 1, 3],), ([None, 10, -1],)]'), schema="data");            
            T = table(df.select(matlab.pyspark.sql.functions.array_min(df.data)));
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, int64(1));
            testCase.verifyEqual(T{2,1}, int64(-1));

            df = testCase.spark.createDataFrame(py.str("[(['apple', 'banana', 'cherry'],)]"), schema="data");
            T = table(df.select(matlab.pyspark.sql.functions.array_min("data")));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "apple");

            df = testCase.spark.createDataFrame(py.str("[(['apple', 1, 'cherry'],)]"), schema='data');
            T = table(df.select(matlab.pyspark.sql.functions.array_min(df.data)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T{1,1}, "1");

            df = testCase.spark.createDataFrame(py.str("[([[2, 1], [3, 4]],)]"), schema='data');
            T = table(df.select(matlab.pyspark.sql.functions.array_min(df.data)));
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyClass(T{1,1}, 'cell');
            testCase.verifyEqual(T{1,1}{1,1}, [int64(2), int64(1)]);
        end
    end
end