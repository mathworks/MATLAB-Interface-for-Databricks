classdef testColumn < matlab.unittest.TestCase
    % TESTCOLUMN Unit tests for the Spark Dataset abstraction
    
    % Copyright 2020-2026 MathWorks, Inc.
    
    properties
        ds
        dsNames
        dsNums
        dsLogical
        dsNulls
        count
        sparkSession
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp("Running: testSetup");

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session

            appName = 'ColumnsUnitTest';
            if isDatabricksEnvironment
                spark = getDatabricksSession();
                % spark = getDatabricksSession(serverless=true);
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;
            
            localNullFile = getSparkApiRoot('test', 'fixtures', 'ds_with_nulls.parquet');
            if isDatabricksEnvironment
                % Use a test file - this needs to exists on the cluster for
                % tests to pass
                inputLocation = '/data/airlinedelay/2008.csv';
                sparkNullFile = sprintf("/tmp/delete_me/cicd_%s", string(datetime('now', 'Format','ddMMMuuuu_HHmmss_SSS')));
                db = databricks.DBFS();
                db.upload(localNullFile, sparkNullFile);
            else
                % inputLocation = addFileProtocol(which('airlinesmall.csv'));
                inputLocation = addFileProtocol(getSparkApiRoot('test', 'fixtures', '2008_small.csv'));
                sparkNullFile = addFileProtocol(localNullFile);
            end
            
            % Create a dataset by pointing to all the CSV content
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(inputLocation);
            
            cleanedDS = sparkDataSet ...
                .withColumn('ArrDelay', sparkDataSet.col('ArrDelay').cast('int')) ...
                .withColumn('DepDelay', sparkDataSet.col('DepDelay').cast('int')) ...
                .withColumn('ActualElapsedTime', sparkDataSet.col('ActualElapsedTime').cast('int')) ...
                .withColumn('CRSElapsedTime', sparkDataSet.col('CRSElapsedTime').cast('int')) ...
                .withColumn('Distance', sparkDataSet.col('Distance').cast('int'));
            
            testCase.ds = cleanedDS;
            testCase.count = testCase.ds.count();

            testCase.dsNulls = spark.read.format("parquet").load(sparkNullFile);

            S = struct(...
                'Name', {"Alice", "Bob", "Céline", "Dimitri", "Esperanza", "Fredrik"}, ...
                'Age', {25, 35, 30, 40, 50, 20}, ...
                'FavColor', {"Blue", "Green", "Pink", "Tartufo", "Green", "Green"}, ...
                'Pet', {"Dog", "Cat", "Iguana", "Iguana", "Giraffe", "Cat"}, ...
                'Grade', {55, 35, 90, 88, 70, 77}...
                );
            T = struct2table(S);
                
            testCase.dsNames = matlab.sparkutils.table2dataset(T, spark);
            
            S = struct( ...
                'A', num2cell(linspace(1,100,100)), ...
                'B', num2cell(linspace(-1000,1000,100)) ...
                );
            testCase.dsNums = matlab.sparkutils.table2dataset(struct2table(S), spark);
            
            S = struct( ...
                'A', num2cell(logical([0, 0, 1, 1])), ...
                'B', num2cell(logical([0, 1, 0, 1])) ...
                );
            testCase.dsLogical = matlab.sparkutils.table2dataset(struct2table(S), spark);
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testIsNullAndNot(testCase)
            DS = testCase.dsNulls;

            DS_OUT = DS ...
                .withColumn("SweetIsNull", DS.col("Sweet").isNull) ...
                .withColumn("FruitIsNotNull", DS.col("Fruit").isNotNull);
            T_OUT = DS_OUT.table();
            Sweet = T_OUT.Sweet;
            Fruit = T_OUT.Fruit;

            SweetIsNull = T_OUT.SweetIsNull;
            FruitIsNotNull = T_OUT.FruitIsNotNull;

            nullSweets = ismissing(Sweet);
            nullFruits = ismissing(Fruit);
            testCase.verifyEqual(nullSweets, SweetIsNull);
            testCase.verifyEqual(nullFruits, ~FruitIsNotNull);

        end


        function testBooleanOps(testCase)

            DS = testCase.dsLogical;
            colA = DS.col("A");
            colB = DS.col("B");
            dsOps = DS.withColumn("And", colA & colB) ...
                      .withColumn("Or",  colA | colB);

            T = table(dsOps);
            head(T)
            A = T.A;
            B = T.B;
            And = T.And;
            Or  = T.Or;

            testCase.assertEqual(A & B, And);
            testCase.assertEqual(A | B, Or);
        end
        
        function testOpsAnotherCol(testCase)
            DS = testCase.dsNums;
            colA = DS.col("A");
            colB = DS.col("B");
            dsOps = DS ...
                .withColumn("Mul", colA .* colB) ...
                .withColumn("Sub", colA -  colB) ...
                .withColumn("Add", colA +  colB) ...
                .withColumn("Div", colA ./ colB) ...
                .withColumn("GT",  colA >  colB) ...
                .withColumn("LT",  colA <  colB) ...
                .withColumn("GE",  colA >= colB) ...
                .withColumn("LE",  colA <= colB) ...
                .withColumn("EQ",  colA == colB) ...
                .withColumn("NE",  colA ~= colB) ...
                ;

            T = table(dsOps);
            % head(T)
            A   = T.A;
            B   = T.B;
            Mul = T.Mul;
            Sub = T.Sub;
            Add = T.Add;
            Div = T.Div;
            GT  = T.GT;
            LT  = T.LT;
            GE  = T.GE;
            LE  = T.LE;
            EQ  = T.EQ;
            NE  = T.NE;
            testCase.assertEqual(A.*B, Mul);
            testCase.assertEqual(A-B,  Sub);
            testCase.assertEqual(A+B,  Add);
            testCase.assertEqual(A./B, Div);
            testCase.assertEqual(A>B,  GT);
            testCase.assertEqual(A<B,  LT);
            testCase.assertEqual(A>=B, GE);
            testCase.assertEqual(A<=B, LE);
            testCase.assertEqual(A==B, EQ);
            testCase.assertEqual(A~=B, NE);
        end

        function testOpsScalar(testCase)
            DS = testCase.dsNums;
            colA = DS.col("A");
            scalarValue = 5.0;
            dsOps = DS.withColumn("Mul", colA .* scalarValue) ...
                      .withColumn("Mulb",colA *  scalarValue) ...
                      .withColumn("Sub", colA -  scalarValue) ...
                      .withColumn("Add", colA +  scalarValue) ...
                      .withColumn("Div", colA ./ scalarValue) ...
                      .withColumn("Divb",colA /  scalarValue) ...
                      .withColumn("GT",  colA >  scalarValue) ...
                      .withColumn("LT",  colA <  scalarValue) ...
                      .withColumn("GE",  colA >= scalarValue) ...
                      .withColumn("LE",  colA <= scalarValue) ...
                      .withColumn("EQ",  colA == scalarValue) ...
                      .withColumn("NE",  colA ~= scalarValue) ...
                      ;

            T = table(dsOps);
            % head(T)
            A = T.A;
            testCase.assertEqual(A.*scalarValue, T.Mul);
            testCase.assertEqual(A*scalarValue,  T.Mulb);
            testCase.assertEqual(A-scalarValue,  T.Sub);
            testCase.assertEqual(A+scalarValue,  T.Add);
            testCase.assertEqual(A./scalarValue, T.Div);
            testCase.assertEqual(A/scalarValue,  T.Divb);
            testCase.assertEqual(A>scalarValue,  T.GT);
            testCase.assertEqual(A<scalarValue,  T.LT);
            testCase.assertEqual(A>=scalarValue, T.GE);
            testCase.assertEqual(A<=scalarValue, T.LE);
            testCase.assertEqual(A==scalarValue, T.EQ);
            testCase.assertEqual(A~=scalarValue, T.NE);

        end
        
        function testMultiply(testCase)
            % Create a column
            DS = testCase.dsNames;
            sparkColumn = DS.col("Age"); 
            
            % Multiply by number
            ds2 = DS.withColumn("Age", DS.col("Age").multiply(10));
            t2 = table(ds2.filter("Name like 'Bob'").select("Age"));
            testCase.assertEqual(t2.Age(1),350);
            
            % Multiply by another column
            sparkColumn2 = DS.col("Grade");
            ds2 = DS.withColumn("AgeGrade", sparkColumn.multiply(sparkColumn2));
            t2 = table(ds2.filter("Name like 'Bob'").select("AgeGrade"));
            testCase.assertEqual(t2.AgeGrade(1),1225);

        end

        function testDivide(testCase)
            % Create a column
            DS = testCase.dsNames;
            sparkColumn = DS.col("Age");

            % Divide by number
            ds2 = DS.withColumn("Age", sparkColumn.divide(10));
            t2 = table(ds2.filter("Name like 'Bob'").select("Age"));
            testCase.assertEqual(t2.Age(1),3.5);
            
            % Divide by another column
            sparkColumn2 = DS.col("Grade");
            ds2 = DS.withColumn("AgeGrade", sparkColumn.divide(sparkColumn2));
            t2 = table(ds2.filter("Name like 'Bob'").select("AgeGrade"));
            testCase.assertEqual(t2.AgeGrade(1),1);
            
        end
        
        function testPlus(testCase)
            % Create a column
            DS = testCase.dsNames;
            sparkColumn = DS.col("Age");

            % Add a number
            ds2 = DS.withColumn("Age", sparkColumn.plus(10));
            t2 = table(ds2.filter("Name like 'Bob'").select("Age"));
            testCase.assertEqual(t2.Age(1),45);
            
            % Add another column
            sparkColumn2 = DS.col("Grade");
            ds2 = DS.withColumn("AgeGrade", sparkColumn.plus(sparkColumn2));
            t2 = table(ds2.filter("Name like 'Bob'").select("AgeGrade"));
            testCase.assertEqual(t2.AgeGrade(1),70);
            
        end
        
        function testMinus(testCase)
            % Create a column
            DS = testCase.dsNames;
            sparkColumn = DS.col("Age");

            % Subtract a number
            ds2 = DS.withColumn("Age", sparkColumn.minus(10));
            t2 = table(ds2.filter("Name like 'Bob'").select("Age"));
            testCase.assertEqual(t2.Age(1),25);
            
            % Subtract another column
            sparkColumn2 = DS.col("Grade");
            ds2 = DS.withColumn("AgeGrade", sparkColumn.minus(sparkColumn2));
            t2 = table(ds2.filter("Name like 'Bob'").select("AgeGrade"));
            testCase.assertEqual(t2.AgeGrade(1),0);
        end
        
        function testExplain(testCase)
            % Create a column
            if isa(testCase.sparkSession, "matlab.pyspark.sql.session.SparkSession")
                % Don't test this, no explain in spark-connect
                return;
            end

            DS = testCase.dsNames;
            sparkColumn = DS.col("Age");

            % Output explain results
            sparkColumn.explain(true);
            
            % verify only logical values work as an argument
            testCase.verifyError(@()sparkColumn.explain("Error"), 'SPARK:ERROR');
        end
        
        function testOtherwise_(testCase)
            df = testCase.sparkSession.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), schema=["age", "name"]);
            df2= df.select(df.name, matlab.pyspark.sql.functions.when(df.age > 3, int32(1)).otherwise_(int32(0)));
            t = table(df);
            testCase.assertEqual(t.name(1), "Alice");
            testCase.assertEqual(t.name(2), "Bob");
            testCase.assertEqual(t.age(1), int64(2));
            testCase.assertEqual(t.age(2), int64(5));
            t2 = table(df2);
            testCase.assertEqual(t2.name(1), "Alice");
            testCase.assertEqual(t2.name(2), "Bob");
            testCase.assertEqual(t2{1,2}, int32(0));
            testCase.assertEqual(t2{2,2}, int32(1));
        end
    end
end
