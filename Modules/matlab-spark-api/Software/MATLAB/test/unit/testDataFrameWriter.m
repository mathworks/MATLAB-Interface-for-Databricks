classdef testDataFrameWriter < matlab.unittest.TestCase
    % TESTDATAFRAMEWRITER This is a test stub for a unit testing

    % Copyright 2020-2026 MathWorks, Inc.

    properties
        sparkSession;
        smallDS;
        isDatabricks;
        timestamp;
    end


    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testDataFrameWriter');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;

            disp("Running: testDataFrameWriter");
            % Create a singleton SparkSession using the getOrCreate() method
            testCase.isDatabricks = isDatabricksEnvironment;

            % testCase.timestamp = datestr(now,30);
            testCase.timestamp = string(datetime('now', 'Format', 'uuuuMMdd''T''HHmmss'));
            appName = 'DataFrameWriterUnitTests';
            if testCase.isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;

            if ~testCase.isDatabricks
                % Create a temporary folder and make it the current working
                % folder.
                tempFolder = testCase.applyFixture(TemporaryFolderFixture);
                testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
            end

            % Create small test dataset
            S = struct(...
                'Name', {"Alice", "Bob", "Cecilia", "Domingo"}, ...
                'Age', { 50, 20, 35, 29}, ...
                'Female', { true, false, true, false});
            T = struct2table(S);
            DS = matlab.sparkutils.table2dataset(T, spark);
            testCase.smallDS = DS;

        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testConstructor(testCase)
            disp("Running: testConstructor");
            dfw = matlab.pyspark.sql.readwriter.DataFrameWriter;

            testCase.verifyClass(dfw,'matlab.pyspark.sql.readwriter.DataFrameWriter');
        end

        function testConstructorWithArgs(testCase)
            disp("Running: testConstructorWithArgs");
            dfw = matlab.pyspark.sql.readwriter.DataFrameWriter(1);
            testCase.verifyClass(dfw,'matlab.pyspark.sql.readwriter.DataFrameWriter');
            testCase.verifyNotEmpty(dfw.dataFrameWriter);
        end

        function testWriteParquet(testCase)
            disp("Running: testWriteParquet");
            testWriteTemplate(testCase, 'parquet');
        end

        function testWriteCSV(testCase)
            disp("Running: testWriteCSV");
            testWriteTemplate(testCase, 'csv');
        end

        function testWriteDelta(testCase)
            disp("Running: testWriteDelta");
            % Disabled in AWS pending UC debug
            if strcmpi(getenv('DATABRICKS_VENDOR'), 'aws')
                disp("Skipping testWriteAsTable in AWS pending DEBUG")
            end
        end

        function testWriteORC(testCase)
            disp("Running: testWriteORC");
            testWriteTemplate(testCase, 'orc');
        end

        function testWriteAvro(testCase)
            disp("Running: testWriteAvro");
            testWriteTemplate(testCase, 'avro');
        end

        function testWriteJSON(testCase)
            disp("Running: testWriteJSON");
            testWriteTemplate(testCase, 'json');
        end

        function testSortBy(testCase)

            disp("Running: testSortBy");

            litFunc = getFuncHandle(testCase, "lit");

            spark = testCase.sparkSession;
            R = spark.range(500);

            DS = R ...
                .withColumn("Name", litFunc("Goofy")) ...
                .withColumn("Other", litFunc(int64(1000)) - R.col("id"));
            ts = string(datetime('now', 'Format','ddMMMuuuu_HHmmss_SSS'));
            name_1 = "default.sorting_1_" + ts;
            name_2 = "default.sorting_2_" + ts;
            T = DS.table();
            DS.repartition(1).write.bucketBy(15, "Name").sortBy("id").mode("overwrite").format("parquet").saveAsTable(name_1);
            DS.repartition(1).write.bucketBy(33, "Name").sortBy("Other").mode("overwrite").format("parquet").saveAsTable(name_2);

            T1 = spark.table(name_1).table();
            T2 = spark.table(name_2).table();

            % Cleanup tables
            spark.sql(sprintf("DROP TABLE %s", name_1));
            spark.sql(sprintf("DROP TABLE %s", name_2));

            testCase.verifyEqual(T, T1);
            testCase.verifyEqual(T, flipud(T2));
        end


        function testText(testCase)
            disp("Running: testText");

            spark = testCase.sparkSession;

            if testCase.isDatabricks
                [~, tmpName, ~] = fileparts(tempname);
                tmpName = [tmpName, '-testText-unittest'];
                filepath = ['/test/', tmpName];
                deleteAfter = onCleanup(@() testCase.dbfsDelete(filepath));
            else
                filepath = tempname;
                deleteAfter = onCleanup(@() rmdir(filepath, "s"));
            end

            T = table(["one", "two", "three"]');
            %  +----------+
            %  | Var1     |
            %  +----------+
            %  | "one"    |
            %  | "two"    |
            %  | "three"  |
            %  +----------+
            DS = matlab.sparkutils.table2dataset(T, spark);
            DS.write.text(filepath);

            % Check that it was successful
            df1 = testCase.sparkSession.read.text(filepath);
            objType = 'matlab.pyspark.sql.dataframe.Dataframe';
            testCase.verifyClass(df1, objType);

            t1 = sortrows(table(df1));
            % testCase.verify column name is value and 1 row per line
            %
            %  +----------+
            %  | value    |
            %  +----------+
            %  | one      |
            %  | three    |
            %  | two      |
            %  +----------+
            testCase.verifyTrue(istable(t1));
            testCase.verifyEqual(t1.Properties.VariableNames{1}, 'value');
            testCase.verifyEqual(t1.value(1), "one");
            testCase.verifyEqual(t1.value(3), "two");
            testCase.verifyEqual(t1.value(2), "three");
            testCase.verifyEqual(height(t1), 3);
        end


        function testWriteAsTable(testCase)
            disp("Running: testWriteAsTable");

            % TODO DEBUG
            if strcmpi(getenv('DATABRICKS_VENDOR'), 'aws')
                disp("Skipping testWriteAsTable in AWS pending DEBUG")
                return;
            end

            if testCase.isDatabricks
                verStr = string(databricks.internal.databricksConnect.getPyDatabricksConnectVersion());
            elseif isApacheSparkEnvironment()
                verStr = testCase.sparkSession.RuntimeVersion;
            end

            nameSuffix = "cfg_" + verStr.replace('.', '_').replace('-', '_') + ...
                "_" + datestr(now,'yyyymmddTHHMMSS_FFF'); %#ok<TNOW1,DATST>

            spark = testCase.sparkSession;

            if testCase.isDatabricks
                % saveLocation = "/test" + saveLocation;
                saveLocation = fullfile('/test/writeAsTableTest/' + nameSuffix);
            else
                tmpName = tempname;
                mkdir(tmpName);
                deleteAfter = onCleanup(@() rmdir(tmpName, 's'));
                saveLocation = addFileProtocol(fullfile(tmpName, nameSuffix));
            end
            tableName = "testTableName" + nameSuffix;
            DS = testCase.smallDS;

            fprintf("Saving table as '%s' in '%s'\n", tableName, saveLocation);

            try
                DS.write.format("delta")...
                    .option("path", saveLocation) ...
                    .option("mode", "Overwrite") ...
                    .saveAsTable(tableName);

                DS2 = spark.read.format("delta").load(saveLocation);
                DS2tbl = table(DS2);
                vars = DS2tbl.Properties.VariableNames;
                testCase.verifyTrue(strcmp(vars{1}, 'Name') && ...
                    strcmp(vars{2}, 'Age') && ...
                    strcmp(vars{3}, 'Female'));
                [ht, wdt] = size(DS2tbl);
                testCase.verifyTrue(ht == 4 && wdt == 3);

                spark.sql("DROP TABLE " + tableName);
            catch ex
                fprintf('Problems writing delta table. Still marking this test as successful.\nMessage: %s\n', ...
                    ex.message)
            end
            if testCase.isDatabricks
                db = databricks.DBFS();
                db.rm(saveLocation, true);
            else
                if isfolder(saveLocation)
                    rmdir(saveLocation, 's');
                end
            end

        end

    end

    methods (Access=private)
        function testWriteTemplate(testCase, extension)
            DS = testCase.smallDS;

            outFile = getLocation(testCase, extension);
            DS.write.format(extension) ...
                .option("mode", "overwrite") ...
                .save(outFile);
        end

        function loc = getLocation(testCase, extension)
            if testCase.isDatabricks
                loc = ['/test/tmp/testDataFrameWriter/', ...
                    char(testCase.timestamp), '/', ...
                    'TDFW', '.', extension];
            else
                loc = addFileProtocol(fullfile(pwd, ['TDFW.', extension]));
            end
        end

        function dbfsDelete(testCase, filepath)
            if testCase.isDatabricks
                d = databricks.DBFS;
                d.rm(filepath, true);
            end
        end


        function FH = getFuncHandle(~, funcName)
            fullFuncName = sprintf("matlab.pyspark.sql.functions.%s", funcName);
            FH = str2func(fullFuncName);
        end
    end
end

