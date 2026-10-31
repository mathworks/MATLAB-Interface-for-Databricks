classdef testRow < matlab.unittest.TestCase
    % testRow Unit tests for Spark Row
    
    % Copyright 2026 MathWorks, Inc.
    
    properties
        spark;
        isDatabricks;
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Setup: testRow');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            testCase.isDatabricks = isDatabricksEnvironment;
            
            appName = 'testRow';
            if testCase.isDatabricks
                testCase.spark = getDatabricksSession();
                % testCase.spark = getDatabricksSession(serverless=true);
            else
                testCase.spark = getDefaultSparkSession(appName=appName);
            end
        end
    end
    
    methods (Test)
        function testConstructor(testCase)
            row = matlab.pyspark.sql.row.Row;
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            % Query if Row() should fail if there is no argument
            testCase.verifyNotEmpty(row);
        end
        
        
        function testCM1(testCase)
            cm = containers.Map({'name','age'}, {"Alice", int64(11)});
            row = matlab.pyspark.sql.row.Row(cm);
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            testCase.verifyEqual(row.bracket('name'), 'Alice');
            testCase.verifyEqual(row.bracket("name"), 'Alice');
            testCase.verifyEqual(row.bracket('age'), int64(11));
            testCase.verifyEqual(row.name, 'Alice');
            testCase.verifyEqual(row.age, int64(11));
        end

        function testCM2(testCase)
            cm = containers.Map({'name','age', 'eyeColour'}, {"Alice", int64(11), "green"});
            row = matlab.pyspark.sql.row.Row(cm);
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            testCase.verifyEqual(row.bracket('name'), 'Alice');
            testCase.verifyEqual(row.bracket("name"), 'Alice');
            testCase.verifyEqual(row.bracket('age'), int64(11));
            testCase.verifyEqual(row.name, 'Alice');
            testCase.verifyEqual(row.age, int64(11));
            testCase.verifyEqual(row.eyeColour, 'green');
        end

        function testPyRow(testCase)
            cm = containers.Map({'name','age'}, {"Alice", int64(11)});
            row = matlab.pyspark.sql.row.Row(cm);
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
            testCase.verifyClass(row.row, 'py.pyspark.sql.types.Row');
            row2 = matlab.pyspark.sql.row.Row(row.row);
            testCase.verifyClass(row2, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row2);
            testCase.verifyEqual(numel(row2), 1);
            testCase.verifyEqual(row2.bracket('name'), 'Alice');
            testCase.verifyEqual(row2.bracket("name"), 'Alice');
            testCase.verifyEqual(row2.bracket('age'), int64(11));
            testCase.verifyEqual(row2.name, 'Alice');
            testCase.verifyEqual(row2.age, int64(11));
        end

        function testNamesOnly(testCase)
            row = matlab.pyspark.sql.row.Row("name", "age");
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(numel(row), 1);
        end

        function testAsDict(testCase)
            df = testCase.spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
            row = df.collect();
            %   [Row(age=14, name='Tom'), Row(age=23, name='Alice'), Row(age=16, name='Bob')]
            
            % Check Tom
            pd = row(1).toPy.asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(14));
            name = d('name');
            testCase.verifyEqual(name{1}, "Tom");

            pd = row(1).asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(14));
            name = d('name');
            testCase.verifyEqual(name{1}, "Tom");

            % Check Alice
            pd = row(2).toPy.asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(23));
            name = d('name');
            testCase.verifyEqual(name{1}, "Alice");

            pd = row(2).asDict;
            d = dictionary(pd);
            % Verify the collected data
            age = d('age');
            testCase.verifyEqual(int64(age{1}), int64(23));
            name = d('name');
            testCase.verifyEqual(name{1}, "Alice");
            
            ds = row.asMATLABDict;
            d = ds{1};
            testCase.verifyClass(d{"age"}, "py.int");
            testCase.verifyEqual(int64(d{"age"}), int64(14));
            testCase.verifyClass(d{"name"}, "string");
            testCase.verifyEqual(d{"name"}, "Tom");

            ds = row.asDict;
            d = ds{1};
            testCase.verifyClass(d{"age"}, "py.int");
            testCase.verifyEqual(int64(d{"age"}), int64(14));
            testCase.verifyClass(d{"name"}, "py.str");
            testCase.verifyEqual(d{"name"}, py.str("Tom"));
    
            row = matlab.pyspark.sql.row.Row({"name", "age"},{"Alice", 11});
            d = row.asMATLABDict;
            testCase.verifyClass(d, 'dictionary');
            testCase.verifyEqual(d.numEntries, 2);
            testCase.verifyEqual(d("name"), {"Alice"});

            row = matlab.pyspark.sql.row.Row({"name", "age"},{"Alice", 11});
            d = row.asDict;
            testCase.verifyClass(d, 'py.dict');
            testCase.verifyEqual(double(py.len(d)), 2);
            testCase.verifyEqual(d{"name"}, py.str("Alice"));

            subrow = matlab.pyspark.sql.row.Row({"name", "age"}, {"a", 2});
            row = matlab.pyspark.sql.row.Row({"key", "value"}, {1, subrow});
            d = row.asMATLABDict;
            testCase.verifyClass(d, 'dictionary');
            testCase.verifyEqual(d.numEntries, 2);
            testCase.verifyEqual(d("key"), {1});
            v = d("value");
            testCase.verifyClass(v{1}, "py.pyspark.sql.types.Row");

            subrow = matlab.pyspark.sql.row.Row({"name", "age"}, {"a", 2});
            row = matlab.pyspark.sql.row.Row({"key", "value"}, {1, subrow});
            d = row.asDict;
            testCase.verifyClass(d, 'py.dict');
            testCase.verifyEqual(double(py.len(d)), 2);
            testCase.verifyEqual(d{"key"}, py.int(1));
            v = d{"value"};
            testCase.verifyClass(v, "py.pyspark.sql.types.Row");

            dT = row.asDict(true);
            v = dT{"value"};
            testCase.verifyClass(v, "py.dict");
        end

        function testCellArrays(testCase)
            row = matlab.pyspark.sql.row.Row({"name", "age", "eyecolour"}, {"Alice", 11, "green"});
            testCase.verifyClass(row, 'matlab.pyspark.sql.row.Row');
            testCase.verifyNotEmpty(row);
            testCase.verifyEqual(row.name, 'Alice');
            testCase.verifyEqual(row.age, 11);
            testCase.verifyEqual(row.eyecolour, 'green');
        end
    end
end