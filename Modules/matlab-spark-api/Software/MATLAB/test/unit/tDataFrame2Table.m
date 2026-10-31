classdef tDataFrame2Table < matlab.unittest.TestCase
%TDATAFRAME2TABLE Unit tests for matlab.pyspark.sql.DataFrame/table().

% Copyright 2026 The MathWorks, Inc.

    properties
        TempFolderFixture
        TempFolder
        IsDatabricks
        Spark
    end

    properties (TestParameter)
        TestFile = ...
            { ...
                "TimestampPrecision.parquet",...
                "TimestampRange.parquet",...
                "TimestampAndNumbers.parquet",...
                "NumbersOnly.parquet",...
                "TimestampNoTimeZone.parquet",...
                "MultipleTimestampColumns.parquet"
            }
    end

    methods (TestClassSetup)

        function createTemporaryFolder(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture
            testCase.TempFolderFixture = testCase.applyFixture(TemporaryFolderFixture);
            testCase.TempFolder = testCase.TempFolderFixture.Folder;
        end

        function createTimestampPrecisionParquetFile(testCase)
            fname = fullfile(testCase.TempFolder, "TimestampPrecision.parquet");
            d1 = datetime(2020, 1, 1, 10, 40, 50, 123, TimeZone="Pacific/Auckland");
            d2 = datetime(2020, 1, 2, 55, 21, 5, 672, TimeZone="Pacific/Auckland");
            d3 = datetime("now", TimeZone="Pacific/Auckland");
            nat = NaT(TimeZone="Pacific/Auckland");
            dates = [d1; nat; d2; d3; nat];
            t = table(dates, VariableNames="UTC Timestamps");
            parquetwrite(fname, t);
        end

        function createTimestampRangeParquetFile(testCase)
            fname = fullfile(testCase.TempFolder, "TimestampRange.parquet");

            % Why do I have to +/- 2/1 here? It should be at the max.
            % NOTE: The Pandas DF -> Table functionality returns a
            % different answer.
            % NOTE: isequal returns false even though each component (Y, M,
            % D, etc.) are equal between texp and tact in the test. best
            % guess is floating point precision.
            d1 = datetime(intmin("int64")/1e3 + 2, ConvertFrom="epochtime", TicksPerSecond=1e6, TimeZone="UTC");
            d2 = datetime(intmax("int64")/1e3 - 1, ConvertFrom="epochtime", TicksPerSecond=1e6, TimeZone="UTC");

            nat = NaT(TimeZone="UTC");
            dates = [d1; nat; d2; nat];
            t = table(dates, VariableNames="UTC Timestamps");
            parquetwrite(fname, t);
        end

        function createTimestampAndNumbersParquetFile(testCase)
            fname = fullfile(testCase.TempFolder, "TimestampAndNumbers.parquet");

            d1 = datetime(2220, 1, 4, 22, 13, 5, 23, "TimeZone", "Africa/Tunis");
            d2 = datetime(2120, 10, 22, 42, 51, 10, 49, "TimeZone", "Africa/Tunis");
            nat = NaT("TimeZone", "Africa/Tunis");
            dates = [d1; nat; d2; nat];
            t = table((1:4)', dates, (5:8)', VariableNames=["Name Space", "UTC Timestamps", "#Numbers"]);

            parquetwrite(fname, t);
        end

        function createNumbersOnlyParquetFile(testCase)
            fname = fullfile(testCase.TempFolder, "NumbersOnly.parquet");
            t = table((1:4)', (5:8)', VariableNames=["Name Space", "#Numbers"]);
            parquetwrite(fname, t);
        end

        function createTimestampNoTimeZoneParquetFile(testCase)
            fname = fullfile(testCase.TempFolder, "TimestampNoTimeZone.parquet");
            dates = datetime(2026, 10, 31, 5, 6, 1) + days(0:10)';
            dates([3 5 7]) = NaT;
            t = table(dates, VariableNames="NoTimeZone");
            parquetwrite(fname, t);
        end

        function createTMultipleTimestampColumnsFile(testCase)
            fname = fullfile(testCase.TempFolder, "MultipleTimestampColumns.parquet");
            dates1 = datetime(2026, 10, 31, 5, 6, 1) + days(0:9)';
            dates1([3 5 7]) = NaT;
            dates2 = datetime(2027, 9, 20, 4, 1, 2) + days(0:9)';
            dates2([1 2 6 8]) = NaT;
            
            t = table((1:10)', dates1, (11:20)', dates2, VariableNames=compose("Col%d", 1:4));
            parquetwrite(fname, t);
        end

        function createReservedTableNamesFile(testCase)
            fname = fullfile(testCase.TempFolder, "ReservedTableNames.parquet");
            t = table(1, 2, 3);
            parquetwrite(fname, t, VariableNames=["Properties", "RowNames", ":"]);
        end

        function setUpSparkSession(testCase)
            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');
            testCase.IsDatabricks = isDatabricksEnvironment;
            if testCase.IsDatabricks
                testCase.Spark = getDatabricksSession();
            else
                testCase.Spark = getDefaultSparkSession(appName='DataFrame2Table');
            end
        end

    end

    methods
        function df = setUpDataFrame(testCase, localTestFile)
            absoluteFilePath = fullfile(testCase.TempFolder, localTestFile);
            if testCase.IsDatabricks
                dbFiles = databricks.Files;
                dbDstFile = "/Volumes/main/default/myvolume/UnitTests/" + localTestFile;
                dbFiles.upload(absoluteFilePath, dbDstFile);
                df = testCase.Spark.read.format("parquet").load(dbDstFile);
            else
                df = testCase.Spark.read.format("parquet").load(addFileProtocol(absoluteFilePath));
            end
        end
    end

    methods (Test)
        function testDataFrame2Table(testCase, TestFile)
            localFile = fullfile(testCase.TempFolder, TestFile);
            texp = readParquetFile(localFile);
            df = testCase.setUpDataFrame(TestFile);
            tact = table(df);
            testCase.verifyEqual(tact, texp);
        end

        function testReservedTableNames(testCase)
            localFile = "ReservedTableNames.parquet";
            df = testCase.setUpDataFrame(localFile);
            fcn = @() table(df);
            tact = testCase.verifyWarning(fcn, "sparkapi:ModifiedColumnNames");
            testCase.verifyEqual(tact.Properties.VariableNames, {'Properties_1', 'RowNames_1', ':_1'});
        end

    end

end

function t = readParquetFile(file)
    t = parquetread(file, VariableNamingRule="preserve");
    if isDatabricksEnvironment()
        idx = t.Properties.VariableTypes == "datetime";
        vars = t.Properties.VariableNames(idx);
        for ii = 1:numel(vars)
            if ~isempty(t.(vars{ii}).TimeZone)
                % adjust to UTC
                t.(vars{ii}).TimeZone = "UTC";
                % remove TimeZone
                t.(vars{ii}).TimeZone = "";
            end
        end
    end

end