classdef testCreateDataFrame < matlab.unittest.TestCase
    % TESTCREATEDATAFRAME Unit tests for createDataFrame

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
            appName = 'CreateDataFrameUnitTests';
            if isDatabricks
                testCase.spark = getDatabricksSession();
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
        function testChar1(testCase)
            df = testCase.spark.createDataFrame('a');
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            % a is returned as a string
            testCase.verifyEqual(T.('_1'), "a");
        end


        function testChar2(testCase)
            df = testCase.spark.createDataFrame('abc');
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            % abc is returned as a string
            testCase.verifyEqual(T.('_1'), "abc");
        end


        function testString1(testCase)
            df = testCase.spark.createDataFrame("a");
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('_1'), "a");
        end


        function testString2(testCase)
            df = testCase.spark.createDataFrame("abc");
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('_1'), "abc");
        end


        function testString3(testCase)
            df = testCase.spark.createDataFrame(["abc", "def"]);
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('data1'), "abc");
            testCase.verifyEqual(T.('data2'), "def");
        end


        function testString4(testCase)
            df = testCase.spark.createDataFrame(["abc"; "def"]);
            T = table(df);
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('data'), ["abc"; "def"]);
        end


        function testString5(testCase)
            df = testCase.spark.createDataFrame({'abc'});
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('data'), "abc");
        end


        function testString6(testCase)
            df = testCase.spark.createDataFrame({'abc'; 'def'});
            T = table(df);
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('data'), ["abc"; "def"]);
        end


        function testSchema1(testCase)
            df = testCase.spark.createDataFrame("abc", schema="myvalue");
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'myvalue');
        end


        function testSchema2(testCase)
            df = testCase.spark.createDataFrame("abc", schema={'myvalue1'});
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'myvalue1');
        end


        function testSchema3(testCase)
            df = testCase.spark.createDataFrame(["abc", "def"], schema={'myvalue1', 'myvalue2'});
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'myvalue1');
            testCase.verifyEqual(T.Properties.VariableNames{2}, 'myvalue2');
        end


        function testSchema4(testCase)
            df = testCase.spark.createDataFrame(["abc", "def"], schema=["myvalue1", "myvalue2"]);
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'myvalue1');
            testCase.verifyEqual(T.Properties.VariableNames{2}, 'myvalue2');
        end


        function testSchema5(testCase)
            df = testCase.spark.createDataFrame(["abc", "def"], schema=py.list({py.str("myvalue1"), py.str("myvalue2")}));
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'myvalue1');
            testCase.verifyEqual(T.Properties.VariableNames{2}, 'myvalue2');
        end


        function testSchema6(testCase)
            df = testCase.spark.createDataFrame(["abc", "def"], schema=py.str('col1: string, col2: string'));
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Properties.VariableNames{1}, 'col1');
            testCase.verifyEqual(T.Properties.VariableNames{2}, 'col2');
        end


        function testTable1(testCase)
            LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
            Age = [38;43;38;40;49];
            Height = [71;69;64;67;64];
            Weight = [176;163;131;133;119];
            Smoker = logical([1;0;1;0;1]);
            BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
            Tsrc = table(LastName,Age,Smoker,Height,Weight,BloodPressure);
            df = testCase.spark.createDataFrame(Tsrc);
            T = table(df);
            testCase.verifyEqual(height(T), 5, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.LastName, string(LastName), 'The LastName column does not match the expected output.');
            testCase.verifyEqual(T.Age, Age, 'The Age column does not match the expected output.');
            testCase.verifyEqual(T.Height, Height, 'The Height column does not match the expected output.');
            testCase.verifyEqual(T.Weight, Weight, 'The Weight column does not match the expected output.');
            testCase.verifyEqual(T.Smoker, Smoker, 'The Smoker column does not match the expected output.');
            testCase.verifyEqual(T.BloodPressure_1, BloodPressure(:,1), 'The BloodPressure 1 column does not match the expected output.');
            testCase.verifyEqual(T.BloodPressure_2, BloodPressure(:,2), 'The BloodPressure 1 column does not match the expected output.');
        end


        function testNumericArray1(testCase)
            df = testCase.spark.createDataFrame([1; 2], schema="value");
            T = table(df);
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('value'), [1; 2]);
        end


        function testNumericArray2(testCase)
            df = testCase.spark.createDataFrame(pi, schema="value");
            T = table(df);
            testCase.verifyEqual(height(T), 1, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('value'), pi);
        end


        function testNumericArray3(testCase)
            df = testCase.spark.sql("SELECT * FROM VALUES (-0.5), (0.5), (NULL) AS TAB(value)");
            T = table(df);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('value'), [-0.5; 0.5; NaN], 'The value column does not match the expected output.');
        end


        function testNumericArray4(testCase)
            df = testCase.spark.createDataFrame(py.str("[(1,), (10,), (100,)]"), schema = ["value"]); %#ok<NBRAK1>
            T = table(df);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('value'), int64([1; 10; 100]), 'The value column does not match the expected output.');
        end


        function testNumericArray5(testCase)
            df = testCase.spark.sql("SELECT * FROM VALUES (-1), (0), (FLOAT('NAN')), (NULL) AS TAB(value)");
            T = table(df);
            testCase.verifyEqual(T.('value')(1), single(-1));
            testCase.verifyEqual(T.('value')(2), single(0));
            testCase.verifyEqual(T.('value')(3), single(NaN));
            testCase.verifyEqual(T.('value')(4), single(NaN));
        end


        function testMissing(testCase)
            df = testCase.spark.createDataFrame([missing; "a"; "b"; "c"], schema="alphabets");
            T = table(df);
            testCase.verifyEqual(height(T), 4, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.('alphabets'), [missing; "a"; "b"; "c"], 'The alphabets column does not match the expected output.');
        end


        function testTuple1(testCase)
            df = testCase.spark.createDataFrame(py.str('[(1, "apple"), (2, "banana"), (3, None)]'), schema=["id", "fruit"]);
            T = table(df);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.id(1), int64(1));
            testCase.verifyEqual(T.id(2), int64(2));
            testCase.verifyEqual(T.id(3), int64(3));
            testCase.verifyEqual(T.fruit(1), "apple");
            testCase.verifyEqual(T.fruit(2), "banana");
            testCase.verifyEqual(T.fruit(3), missing);
        end


        function testTuple2(testCase)
            df = testCase.spark.createDataFrame(py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})}), schema=["id", "fruit"]);
            T = table(df);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.id(1), 1);
            testCase.verifyEqual(T.id(2), 2);
            testCase.verifyEqual(T.id(3), 3);
            testCase.verifyEqual(T.fruit(1), "apple");
            testCase.verifyEqual(T.fruit(2), "banana");
            testCase.verifyEqual(T.fruit(3), missing);
        end


        function testList1(testCase)
            df = testCase.spark.createDataFrame(py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})}), schema=["a", "b"]);
            T = table(df);
            testCase.verifyEqual(height(T), 2, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.a(1), 1.0);
            testCase.verifyEqual(T.a(2), nan);
            testCase.verifyEqual(T.b(1), nan);
            testCase.verifyEqual(T.b(2), 2.0);
        end


        function testDouble1(testCase)
            m3 = magic(3);
            df = testCase.spark.createDataFrame(m3, schema=["x1","x2", "x3"]);
            T = table(df);
            testCase.verifyEqual(height(T), 3, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.x1, m3(:,1), 'The x1 column does not match the expected output.');
            testCase.verifyEqual(T.x2, m3(:,2), 'The x2 column does not match the expected output.');
            testCase.verifyEqual(T.x3, m3(:,3), 'The x3 column does not match the expected output.');
        end


        function testNone1(testCase)
            df = testCase.spark.createDataFrame({py.None; 1}, schema="e");
            T = table(df);
            testCase.verifyEqual(T.e(1), nan);
            testCase.verifyEqual(T.e(2), 1);
        end


        function testDatetime1(testCase)
            data = {...
                {2023, 1, 2, 14, 20, 12.345, 'UTC'};...
                {2023, 1, 2, 14, 20, 12.345, 'America/New_York'};...
                {2023, 1, 2, 14, 20, 12.345, 'Europe/Berlin'};...
                {2023, 1, 2, 14, 20, 12.345, 'Asia/Calcutta'}...
                };
            columns = {'year', 'month', 'day', 'hour', 'min', 'sec', 'tz'};
            df = testCase.spark.createDataFrame(data, schema=columns);
            df = df.withColumn("ts_no_tz", matlab.pyspark.sql.functions.make_timestamp_ntz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec"));
            df = df.withColumn("ts_with_tz", matlab.pyspark.sql.functions.make_timestamp_ltz(years="year", month="month", days="day", hours="hour", mins="min", secs="sec", timezone="tz"));
            % df.show(10, false)
            %   +------+-----+---+----+----+------+----------------+-----------------------+-----------------------+
            %   |year  |month|day|hour|min |sec   |tz              |ts_no_tz               |ts_with_tz             |
            %   +------+-----+---+----+----+------+----------------+-----------------------+-----------------------+
            %   |2023.0|1.0  |2.0|14.0|20.0|12.345|UTC             |2023-01-02 14:20:12.345|2023-01-02 14:20:12.345|
            %   |2023.0|1.0  |2.0|14.0|20.0|12.345|America/New_York|2023-01-02 14:20:12.345|2023-01-02 19:20:12.345|
            %   |2023.0|1.0  |2.0|14.0|20.0|12.345|Europe/Berlin   |2023-01-02 14:20:12.345|2023-01-02 13:20:12.345|
            %   |2023.0|1.0  |2.0|14.0|20.0|12.345|Asia/Calcutta   |2023-01-02 14:20:12.345|2023-01-02 08:50:12.345|
            %   +------+-----+---+----+----+------+----------------+-----------------------+-----------------------+
            T = table(df);
            testCase.verifyEqual(height(T), 4, 'The number of rows does not match the expected output.');
            testCase.verifyClass(T.ts_no_tz, 'datetime');
            testCase.verifyClass(T.ts_with_tz, 'datetime');
            testCase.verifyEmpty(T.ts_no_tz(1).TimeZone)
        end


        function testPDF1(testCase)
            LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
            Age = [38;43;38;40;49];
            Height = [71;69;64;67;64];
            Weight = [176;163;131;133;119];
            Smoker = logical([1;0;1;0;1]);
            BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
            Tsrc = table(LastName,Age,Smoker,Height,Weight,BloodPressure);

            % Creates a py.pandas.core.frame.DataFrame
            pdf = py.pandas.DataFrame(Tsrc);
            % Creates a matlab.pyspark.sql.dataframe.Dataframe
            df = testCase.spark.createDataFrame(pdf);
            T = table(df);
            testCase.verifyEqual(height(T), 5, 'The number of rows does not match the expected output.');
            testCase.verifyEqual(T.Age, [38;43;38;40;49]);
            testCase.verifyEqual(T.Height, [71;69;64;67;64]);
            testCase.verifyEqual(T.Weight, [176;163;131;133;119]);
            testCase.verifyEqual(T.LastName, ["Sanchez";"Johnson";"Li";"Diaz";"Brown"]);
            testCase.verifyEqual(T.BloodPressure_1, [124; 109; 125; 117; 122]);
            testCase.verifyEqual(T.BloodPressure_2, [93; 77; 83; 75; 80]);
        end
    end
end
