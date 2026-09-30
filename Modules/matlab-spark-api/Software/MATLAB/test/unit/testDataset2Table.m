classdef testDataset2Table < matlab.unittest.TestCase
    % testDataset2Table Unit tests for the Dataset table conversion
    
    % Copyright 2021-2026 MathWorks, Inc.
    
    properties
        ds
        dsNames
        dsBinary
        count
        sparkSession
        Table
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testDataset2Table');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            isDatabricks = isDatabricksEnvironment;
                        
            appName = 'Dataset2TableUnitTests';
            binFile = getSparkApiRoot('test', 'fixtures', 'hihohum.parquet');
            
            if isDatabricks
                spark = getDatabricksSession();
                db = databricks.DBFS();
                dbDstFile = '/test/unit-test-data/hihohum.parquet';
                db.upload(binFile, dbDstFile);
                testCase.dsBinary = spark.read.format("parquet").load(dbDstFile);
            else
                spark = getDefaultSparkSession(appName=appName);
                % spark.toPy.conf.set("spark.sql.session.timeZone", "UTC")
                testCase.dsBinary = spark.read.format("parquet").load(addFileProtocol(binFile));
            end
            
            testCase.sparkSession = spark;
            
            basicStruct = struct('a','qwerty', 'b',-pi);
            basicTable = struct2table(basicStruct); %#ok<NASGU>
            basicMap = dictionary("a", 123, "b", -pi);
            basicArray = {5,3,2};
            
            % dv = datetime('now', 'TimeZone','local');
            dv = datetime();
            dv.Second = round(dv.Second, 3);
            dv = num2cell(dv + (1:8));
            
            dur = num2cell(duration + (1:8));

            S = struct(...
                'String1',  {"Alice", "Bob", "Céline", "Dimitri", "Esperanza", "Fredrik", 'George', 'Helen'}, ...
                'String2',  {"Blue", "Green", "Pink", "Tartufo", "Green", "", "", missing}, ...
                'Double',   {25, 35, 30, 40, 50, pi, NaN, missing}, ...
                'Single',   num2cell(single([25, 35, 30, 40, 50, pi, NaN, missing])), ...
                'Int64',    num2cell(repmat(int64([intmax('int64'), intmin('int64'), 0, NaN]),1,2)), ...
                'Int32',    num2cell(repmat(int32([intmax('int32'), intmin('int32'), 0, NaN]),1,2)), ...
                'Int16',    num2cell(repmat(int16([intmax('int16'), intmin('int16'), 0, NaN]),1,2)), ...
                'Int8',     num2cell(repmat(int8( [intmax('int8'),  intmin('int8'),  0, NaN]),1,2)), ...
                'Logical',  num2cell(repmat([true,false],1,4)), ...
                'Date',     dv, ...
                'Duration', dur, ...
                'Struct',   repmat({basicStruct},1,8),  ...
                ...'Table',    repmat({basicTable}, 1,8),  ... %TODO: table is converted into a struct, so converting back will never match
                'Map',      repmat({basicMap},   1,8),  ...
                'Array',    repmat({basicArray}, 1,8)   ...
                );
            T = struct2table(S);
            
            % NOTE: remove the containers.Map for now. Does dictionary work?
            testCase.Table = T;
            
            testCase.dsNames = matlab.sparkutils.table2dataset(T, spark);
        end
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        
        function testNameTable(testCase)

            % testCase.assumeTrue(isDatabricksEnvironment(), ...
            %     "Spark has some issues with UTC vs local timezone");
            DS = testCase.dsNames;
            
            T = DS.table();
            
            testCase.verifyEqual(int64(DS.count), int64(height(T)));
            
            testCase.verifyEqual(T.String1, testCase.Table.String1)
            testCase.verifyEqual(T.String2, testCase.Table.String2)
            testCase.verifyEqual(T.Double, testCase.Table.Double)
            testCase.verifyEqual(T.Single, testCase.Table.Single)
            testCase.verifyEqual(T.Int64, testCase.Table.Int64)
            testCase.verifyEqual(T.Int32, testCase.Table.Int32)
            testCase.verifyEqual(T.Int16, testCase.Table.Int16)
            testCase.verifyEqual(T.Int8, testCase.Table.Int8)
            testCase.verifyEqual(T.Logical, testCase.Table.Logical)
            
            % testCase.verifyEqual(T.Date, testCase.Table.Date)
            % testCase.verifyEqual(T.Date, testCase.Table.Date, 'AbsTol', milliseconds(10))
            

            T.Date, testCase.Table.Date
            T.Date.TimeZone, testCase.Table.Date.TimeZone
            if isDatabricksEnvironment()
                testCase.verifyLessThan(seconds(T.Date-testCase.Table.Date), 10e-3)
                testCase.verifyEqual(T.Duration, testCase.Table.Duration)
            elseif isApacheSparkEnvironment()
                % Fallback to string-based tests due to timezone issues
                testCase.verifyEqual(string(T.Date), string(testCase.Table.Date))
            else
                % SKIP
            end

            % Pandas conversion makes a struct into a dictionary.
            % Unclear if this is a good choice.
            
            % testCase.verifyEqual(T.Map, testCase.Table.Map)
            % A struct here. Unclear what to do.
            
            
            % TODO: Due to the splitting of arrays, this can't be done
            % here right now for Python.
            
            DS.show, disp(T)
        end
        
        function testBinaryData(testCase)
            DS = testCase.dsBinary;
            
            T = DS.table();
            
            testCase.verifyEqual(int64(DS.count), int64(height(T)));
            testCase.verifyClass(T.bin, 'cell');
            testCase.verifyClass(T.bin{1}, 'uint8');
        end

        function testArrayWithNoneElements(testCase)
            % Verify the pandas-backed Spark-to-MATLAB conversion
            % functionality supports Spark Arrays with missing elements.
            %
            % Issue: #171 

            spark = testCase.sparkSession;
    
            df = spark.createDataFrame(py.str("[([1.0, 2.0], [5.0]), ([3.0, 4.0], None)]"),...
                schema=["a", "b"]);
            
            % Restore the old value of DataFrame/getSetUseToArrow on test teardown.
            oldValue = df.getSetUseToArrow();
            testCase.addTeardown(@() df.getSetUseToArrow(oldValue));
           
            % Force DataFrame/table to use the Pandas-backed functionality.
            df.getSetUseToArrow(false);

            texp = table({[1 2]; [3 4]}, {5; missing}, VariableNames=["a", "b"]);
            tact = df.table();
            
            testCase.verifyEqual(tact, texp);
        end
        
    end
end
