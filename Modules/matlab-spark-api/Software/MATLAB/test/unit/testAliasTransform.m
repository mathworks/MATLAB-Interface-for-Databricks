classdef testAliasTransform < matlab.unittest.TestCase
    % TESTALIASTRANSFORM Unit tests for Transform and Alias functions

    % Copyright 2025-2026 MathWorks, Inc.

    properties
        DF1
        DF2
        sparkSession
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            isDatabricks = isDatabricksEnvironment();
            appName = 'AliasTransformUnitTests';
            if isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            R = spark.range(100);
            df = R.withColumn("id_str", R.('id').cast('string'));
            testCase.DF1 = df;
            testCase.DF2 = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema={'age', 'name'});
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testAliasDataframe(testCase)
            import matlab.pyspark.sql.functions.col
            import matlab.pyspark.sql.functions.desc

            DF = testCase.DF2;
            df_as1 = DF.alias("df_as1");
            df_as2 = DF.alias("df_as2");
            joined_df = df_as1.join(df_as2, on=col("df_as1.name") == col("df_as2.name"), how='inner');
            joined_df2 = joined_df.select("df_as1.name", "df_as2.name", "df_as2.age").sort(desc("df_as1.name"));

            testCase.verifyEqual(joined_df2.columns, ["name", "name", "age"], 'The selected columns do not match the expected output.');

            T = DF.table();
            T = sortrows(T, "name", "descend");
            T_joined = joined_df2.table();
            cols = string(T_joined.Properties.VariableNames);
            testCase.verifyEqual(cols, ["name", "name_1", "age"], 'The selected columns do not match the expected output.');

            testCase.verifyEqual(T_joined.name, T_joined.name_1, "First two columns should be equal");
            testCase.verifyEqual(T.name, T_joined.name);
            testCase.verifyEqual(T.age, T_joined.age);
        end

        function testAliasColumn(testCase)
            DF = testCase.DF1;
            aCol = DF.('id').alias('nummer');
            bCol = DF.('id_str').alias('sträng');
            testCase.verifyEqual(string(aCol), "Column<'id AS nummer'>", 'The alias name does not match the expected value.');
            testCase.verifyEqual(string(bCol), "Column<'id_str AS sträng'>", 'The alias name does not match the expected value.');

            DF_new = DF.select(aCol, bCol);
            testCase.verifyEqual(DF_new.columns, ["nummer", "sträng"]);
            T_new = DF_new.table();
            testCase.verifyEqual(string(T_new.Properties.VariableNames), ["nummer", "sträng"]);
        end

        function testDataframeTransform_MATLAB(testCase)
            DF = testCase.DF2;
            transformedDF = DF.transform(@tf_addHello);
            cols = transformedDF.columns;
            testCase.verifyEqual(cols, ["age", "name", "hello"]);
            T = transformedDF.table();
            testCase.verifyEqual(T.hello, repmat("Hello", height(T), 1));
        end

        function testDataframeTransform_Python(testCase)
            DF = testCase.DF2;
            transformedDF = DF.transform(@tf_addHello).transform(tf_doubled());
            cols = transformedDF.columns;
            testCase.verifyEqual(cols, ["age", "name", "hello", "doubled"]);
            T = transformedDF.table();
            testCase.verifyEqual(T.hello, repmat("Hello", height(T), 1));
            testCase.verifyEqual(T.age*2, T.doubled);
        end

        function testAliasExample(testCase)
            df = testCase.sparkSession.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema={'age', 'name'});
            df_as1 = df.alias("df_as1");
            df_as2 = df.alias("df_as2");
            joined_df = df_as1.join(df_as2, on=df_as1.col('name') == df_as2.col('name'), how='inner');
            df2 = joined_df.select("df_as1.name", "df_as2.name", "df_as2.age").sort(desc(df_as1.name));
            t2 = table(df2);
            testCase.verifyEqual(height(t2), 3);
            testCase.verifyEqual(t2.Properties.VariableNames, {'name', 'name_1', 'age'});
            testCase.verifyEqual(t2.age(1), int64(14));
            testCase.verifyEqual(t2.age(2), int64(16));
            testCase.verifyEqual(t2.age(3), int64(23));
            testCase.verifyEqual(t2.name(1), "Tom");
            testCase.verifyEqual(t2.name(2), "Bob");
            testCase.verifyEqual(t2.name(3), "Alice");
        end
    end
end

function transformedDF = tf_addHello(DF)
    % tf_addHello MATLAB function that operates on Dataframe
    import matlab.pyspark.sql.functions.lit
    transformedDF = DF.withColumn("hello", lit("Hello"));
end

function pyTransform = tf_doubled()
    % tf_doubled Returns python function doing transform

    funcDef = ...
        "def myfunc(DF):" + ...
        "    return DF.withColumn('doubled', DF['age'] * 2)";
    funcReturn = "a = myfunc";
    pyTransform = pyrun([funcDef, funcReturn], "a");
end
