classdef testFunctions < matlab.unittest.TestCase
    % TESTFUNCTIONS Unit tests for the Spark SQL Functions
    
    % Copyright 2020-2026 MathWorks, Inc.
    
    properties
        ds;
        dateDS;
        dateTable;
        numTable;
        numDS;
        trigDS;
        logDS;
        count;
        sparkSession;
        isDatabricks;
        dsNames;

    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            disp('Running: testFunctions');

            testCase.assumeTrue(matlab.sparkutils.internal.hasSparkEnvironment(), ...
                'Ensure Spark Session is available');

            % Create a Spark configuration and shared Spark session
            testCase.isDatabricks = isDatabricksEnvironment;
            
            appName = 'FunctionsUnitTests';
            if testCase.isDatabricks
                spark = getDatabricksSession();
            else
                spark = getDefaultSparkSession(appName=appName);
            end
            testCase.sparkSession = spark;
            
            if testCase.isDatabricks
                inputLocation = '/test/unit-test-data/outages.csv';
            else
                inputLocation = addFileProtocol(which('outages.csv'));
            end
            
            % Create a dataset by pointing to all the CSV content
            sparkDataSet = spark.read.format('csv')...
                .option('header','true')...
                .option('inferSchema','true')...
                .load(inputLocation);
            
            tmpDS = sparkDataSet ...
                .withColumn("OutageDate", matlab.pyspark.sql.functions.to_date(sparkDataSet.col("OutageTime"))) ...
                .withColumn("OutageTimestamp", matlab.pyspark.sql.functions.to_timestamp(sparkDataSet.col("OutageTime"))) ...
                .withColumn("RestorationTime", matlab.pyspark.sql.functions.to_date(sparkDataSet.col("RestorationTime"))) ...
                ;
            
            testCase.ds = tmpDS;
            testCase.count = testCase.ds.count();
            
            old = cd(getSparkApiRoot('test', 'fixtures'));
            goBack = onCleanup(@() cd(old));
            
            testCase.dateTable = dateExamplesTable();
            testCase.dateDS = matlab.sparkutils.table2dataset(testCase.dateTable, spark);
            
            testCase.numTable = numExamplesTable();
            testCase.numDS = matlab.sparkutils.table2dataset(testCase.numTable, spark);
            testCase.trigDS = matlab.sparkutils.table2dataset(trigonometryTable(), spark);
            testCase.logDS = matlab.sparkutils.table2dataset(logarithmTable(), spark);
            
            S = struct(...
                'Name', {"Alice", "Bob", "Céline", "Dimitri", "Esperanza", "Fredrik"}, ...
                'Age', {25, 35, 30, 40, 50, 20}, ...
                'FavColor', {"Blue", "Green", "Pink", "Tartufo", "Green", "Green"}, ...
                'Pet', {"Dog", "Cat", "Iguana", "Iguana", "Giraffe", "Cat"}, ...
                'Grade', {55, 35, 90, 88, 70, 77}...
                );
            T = struct2table(S);
                
            testCase.dsNames = matlab.sparkutils.table2dataset(T, spark);
        end
        
    end
    
    methods (TestClassTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        
        function testYears(testCase)
            testTimeHelper(testCase, "OutageYears", 2000, 2016, getFuncHandle(testCase, "year"));
        end
        
        function testMonths(testCase)
            testTimeHelper(testCase, "OutageMonths", 1, 12, getFuncHandle(testCase, "month"));
        end
        
        function testHours(testCase)
            testTimeHelper(testCase, "OutageHours", 0, 24, getFuncHandle(testCase, "hour"));
        end
        
        function testMinutes(testCase)
            testTimeHelper(testCase, "OutageMinutes", 0, 60, getFuncHandle(testCase, "minute"));
        end
        
        function testSeconds(testCase)
            testTimeHelper(testCase, "OutageSeconds", 0, 60, getFuncHandle(testCase, "second"));
        end
        
        function testDayOfYear(testCase)
            testTimeHelper(testCase, "OutageDayOfYear", 1, 366, getFuncHandle(testCase, "dayofyear"));
        end
        
        function testDayOfMonth(testCase)
            testTimeHelper(testCase, "OutageDayOfMonth", 1, 32, getFuncHandle(testCase, "dayofmonth"));
        end
        
        function testDayOfWeek(testCase)
            testTimeHelper(testCase, "OutageDayOfWeek", 1, 7, getFuncHandle(testCase, "dayofweek"));
        end
        
        function testWeekOfYear(testCase)
            testTimeHelper(testCase, "OutageWeekOfYear", 1, 53, getFuncHandle(testCase, "weekofyear"));
        end
        
        
        function testWindow(testCase)

            outages = testCase.ds;

            winFunc = getFuncHandle(testCase, "window");
            rgds = outages.groupBy(winFunc(outages.col("OutageTime"), "1 week"));
            d2 = rgds.count();
            counts = table(d2.select("count"));
            testCase.verifyEqual(int64(sum(counts.count)), int64(outages.count));
            
            % Different argument handling
            rgds = outages.groupBy(winFunc(outages.col("OutageTime"), "1 week", slideDuration="1 day"));

            d2 = rgds.count();
            counts = table(d2.select("count"));
            testCase.verifyGreaterThan(sum(counts.count), outages.count);
            
            rgds = outages.groupBy(...
                winFunc(outages.col("OutageTime"), "1 day"), ...
                outages.col("Loss"));
            
        end
        
        function testToDate(testCase)
            
            toDateFunc = getFuncHandle(testCase, "to_date");
            DS = testCase.dateDS;
            NDS = DS ...
                .withColumn('C1', toDateFunc(DS.col("yyyyMMdd_HHmmssdotSSSS"))) ...
                .withColumn('C2', toDateFunc(DS.col("yyyyMMdd_HHmmss"))) ...
                .withColumn('C3', toDateFunc(DS.col("yyyyMMdd_HHmm"))) ...
                .withColumn('C4', toDateFunc(DS.col("yyyyMMdd"))) ...
                .withColumn('C5', toDateFunc(DS.col("ddMMyyyy"), "dd-MM-yyyy")) ...
                ;
            NT = table(NDS);
            testCase.verifyEqual(NT.C1, NT.C2);
            testCase.verifyEqual(NT.C1, NT.C3);
            testCase.verifyEqual(NT.C1, NT.C4);
            testCase.verifyEqual(NT.C1, NT.C5);
        end
        
        function testToTimestamp(testCase)
            toTimestampFunc = getFuncHandle(testCase, "to_timestamp");
            DS = testCase.dateDS;
            T = testCase.dateTable;
            NDS = DS ...
                .withColumn('C1', toTimestampFunc(DS.col("yyyyMMdd_HHmmssdotSSSS"))) ...
                .withColumn('C2', toTimestampFunc(DS.col("yyyyMMdd_HHmmss"))) ...
                .withColumn('C3', toTimestampFunc(DS.col("yyyyMMdd_HHmm"))) ...
                .withColumn('C4', toTimestampFunc(DS.col("yyyyMMdd"))) ...
                .withColumn('C5', toTimestampFunc(DS.col("ddMMyyyy"), "dd-MM-yyyy")) ...
                ;
            NT = table(NDS);
            
            testCase.verifyEqual(NT.C4, NT.C5);
        end
        
        function testDateAdd(testCase)
            % Tests both date_add and date_sub
            dateAddFunc = getFuncHandle(testCase, "date_add");
            dateSubFunc = getFuncHandle(testCase, "date_sub");

            DS = testCase.ds;
            DSD = DS ...
                .withColumn("DatePlus5Days", dateAddFunc(DS.col("OutageTime"), 5)) ...
                .withColumn("DateMinus10Days", dateSubFunc(DS.col("OutageTime"), 10)) ...
                ... Now just keep the columns we need
                .select("OutageDate", "DatePlus5Days", "DateMinus10Days");
            
            TD = table(DSD);
            OD = TD.OutageDate;
            testCase.verifyTrue(all(TD.DatePlus5Days-OD==days(5)));
            testCase.verifyTrue(all(OD-TD.DateMinus10Days==days(10)));
            
        end
        
        function testAddMonths(testCase)
            
            dateAddFunc = getFuncHandle(testCase, "add_months");
            monthFunc = getFuncHandle(testCase, "month");
            DS = testCase.ds;
            DSD = DS ...
                .withColumn("DatePlus2Months", dateAddFunc(DS.col("OutageTime"), 2)) ...
                .withColumn("DateMinus3Months", dateAddFunc(DS.col("OutageTime"), -3)) ...
                ... Now just keep the columns we need
                .select("OutageDate", "DatePlus2Months", "DateMinus3Months");
            DSM = DSD ...
                .withColumn("M", monthFunc(DSD.col("OutageDate"))) ...
                .withColumn("Mp2", monthFunc(DSD.col("DatePlus2Months"))) ...
                .withColumn("Mm3", monthFunc(DSD.col("DateMinus3Months"))) ...
                ... Now just keep the columns we need
                .select("OutageDate", "M", "Mp2", "Mm3");
            
            TD = table(DSM);
            Mp2D = TD.Mp2-TD.M;
            Mm3D = TD.M-TD.Mm3;
            
            Mp2DNegIdx = Mp2D<0;
            Mp2D(Mp2DNegIdx) = int32(12)+Mp2D(Mp2DNegIdx);
            
            testCase.verifyTrue(all(Mp2D==2));
            
            Mm3DNegIdx = Mm3D<0;
            Mm3D(Mm3DNegIdx) = int32(12)+Mm3D(Mm3DNegIdx);
            testCase.verifyTrue(all(Mm3D==3));
            
        end
        
        function testRound(testCase)
            
            roundFunc = getFuncHandle(testCase, "round");
            DS = testCase.numDS;
            numT = testCase.numTable;
            testCase.verifyEqual(int64(DS.count()), int64(height(numT)));
            
            rDS = DS ...
                .withColumn("Round", roundFunc(DS.col("X"))) ...
                .withColumn("Round2", roundFunc(DS.col("X"), 2)) ...
                .withColumn("Round5", roundFunc(DS.col("X"), 5)) ...
                ;
            
            TDS = table(rDS);
            testCase.verifyTrue(all(round(numT.X) == TDS.Round));
            testCase.verifyTrue(all(round(numT.X, 2) == TDS.Round2));
            testCase.verifyTrue(all(round(numT.X, 5) == TDS.Round5));
            
        end
        
        function testSum(testCase)
            
            yearFunc = getFuncHandle(testCase, "year");
            monthFunc = getFuncHandle(testCase, "month");
            sumFunc = getFuncHandle(testCase, "sum");
            DS = testCase.ds;
            
            sDS = DS ...
                .groupBy(...
                yearFunc(DS.col('OutageTime')), ...
                monthFunc(DS.col('OutageTime')) ...
                );
            
            XDS = sDS ...
                .agg(sumFunc(DS.col("Customers"))) ...
                .sort("year(OutageTime)", "month(OutageTime)") ...
                ;
            TDS = table(XDS);
            
            TOrig = table(DS.select("Customers"));
            CustOrig = TOrig.Customers;
            SumOriginal = sum(CustOrig(~isnan(CustOrig)));
            CustAgg = TDS{:,"sum(Customers)"};
            SumAgg = sum(CustAgg(~isnan(CustAgg)));
            
            testCase.verifyLessThan(abs(SumAgg-SumOriginal),4e-3);
            
        end
        
        function testMean(testCase)
            
            yearFunc = getFuncHandle(testCase, "year");
            meanFunc = getFuncHandle(testCase, "mean");
            DS = testCase.ds;
            
            sDS = DS ...
                .groupBy(...
                yearFunc(DS.col('OutageTime')));
            
            XDS = sDS ...
                .agg(meanFunc(DS.col("Customers"))) ...
                .sort("year(OutageTime)") ...
                ;
            TDS = table(XDS);
            
        end
        
        function testMin(testCase)

            yearFunc = getFuncHandle(testCase, "year");
            minFunc = getFuncHandle(testCase, "min");
            DS = testCase.ds;

            sDS = DS ...
                .groupBy(...
                yearFunc(DS.col('OutageTime')));
            
            minDS = sDS ...
                .agg(minFunc(DS.col("Customers"))) ...
                .sort("year(OutageTime)") ...
                ;
            T= table(minDS);
            testCase.verifyClass(T, 'table');

        end            
        
        function testMax(testCase)
            yearFunc = getFuncHandle(testCase, "year");
            maxFunc = getFuncHandle(testCase, "max");
            DS = testCase.ds;

            sDS = DS ...
                .groupBy(...
                yearFunc(DS.col('OutageTime')));

            maxDS = sDS ...
                .agg(maxFunc(DS.col("Customers"))) ...
                .sort("year(OutageTime)") ...
                ;
            T= table(maxDS);
            testCase.verifyClass(T, 'table');

        end            
        
        function testAbs(testCase)
            absFunc = getFuncHandle(testCase, "abs");
            DS = testCase.trigDS;
            DS2 = DS ...
                .withColumn("SparkAbsX", absFunc(DS.col("X")));
            T = table(DS2.select(["AbsX", "SparkAbsX"]));
            testCase.assertEqual(T.AbsX, T.SparkAbsX);
        end
        
        function testAsin(testCase)
            asinFunc = getFuncHandle(testCase, "asin");
            DS = testCase.trigDS;
            DS2 = DS ...
                .withColumn("SparkArcsine", asinFunc(DS.col("Sine")));
            T = table(DS2.select(["Arcsine", "SparkArcsine"]));
            testCase.assertEqual(T.Arcsine, T.SparkArcsine);
        end
        
        function testAcos(testCase)
            acosFunc = getFuncHandle(testCase, "acos");
            DS = testCase.trigDS;
            DS2 = DS ...
                .withColumn("SparkArkTangent", acosFunc(DS.col("Cosine")));
            T = table(DS2.select(["Arccosine", "SparkArkTangent"]));
            testCase.assertEqual(T.Arccosine, T.SparkArkTangent);
        end
        
        function testAtan(testCase)
            atanFunc = getFuncHandle(testCase, "atan");
            DS = testCase.trigDS;
            DS2 = DS ...
                .withColumn("SparkArkTangent", atanFunc(DS.col("Tangent")));
            T = table(DS2.select(["Arctangent", "SparkArkTangent"]));
            testCase.assertEqual(T.Arctangent, T.SparkArkTangent);
        end
        
        function testLn(testCase)
            logFunc = getFuncHandle(testCase, "ln");
            DS = testCase.logDS;
            DS2 = DS ...
                .withColumn("SparkLog", logFunc(DS.col("x")));
            %MATLAB log(0) = -Inf
            %pyspark.sql.functions.ln(0) = NULL
            %na.replace not implemented yet
            %DS3=DS2.na.replace('Inf', 'NaN');
            DS3=DS2.na.fill(-Inf);

            T = table(DS3.select(["Log", "SparkLog"]));
            if testCase.isDatabricks
                testCase.assertEqual(T.Log, T.SparkLog, "Inf and Nan are ok to pass");
            else
                testCase.assertEqual(T.Log, T.SparkLog, ...
                    "Inf and Nan are ok to pass", "AbsTol", 1e-12);
           end
        end
        
        function testLog1p(testCase)
            logFunc = getFuncHandle(testCase, "log1p");
            DS = testCase.logDS;
            DS2 = DS ...
                .withColumn("SparkLog1p", logFunc(DS.col("x")));
            T = table(DS2.select(["Log1p", "SparkLog1p"]));
            testCase.assertEqual(T.Log1p, T.SparkLog1p);
        end
        
        function testLog2(testCase)
            logFunc = getFuncHandle(testCase, "log2");
            DS = testCase.logDS;
            DS2 = DS ...
                .withColumn("SparkLog2", logFunc(DS.col("x")));
            DS3=DS2.na.fill(-Inf);
            T = table(DS3.select(["Log2", "SparkLog2"]));

            if isMATLABReleaseOlderThan("R2024b")
                testCase.assertEqual(round(T.Log2, 5), round(T.SparkLog2, 5));
            else
                testCase.assertTrue(all(isapprox(T.Log2, T.SparkLog2, 'loose')));
            end
        end
        
        function testCurrentTimestamp(testCase)
            curTSFunc = getFuncHandle(testCase, "current_timestamp");

            DS = testCase.dateDS;
            
            DS2 = DS ...
                .withColumn("CleanTimestamp", curTSFunc());
            T = table(DS2);
            testCase.verifyLength(unique(T.CleanTimestamp), 1);
            testCase.verifyClass(T.CleanTimestamp, 'datetime');
        end
        
        function testDateFormat(testCase)
            toTSFunc = getFuncHandle(testCase, "to_timestamp");
            dateFormatFunc = getFuncHandle(testCase, "date_format");
            
            DS = testCase.dateDS;
            
            DS2 = DS ...
                .withColumn("Timestamp", toTSFunc(DS.col("yyyyMMdd_HHmmss")));
            DS3 = DS2 ...
                .withColumn("T1", dateFormatFunc(DS2.col("Timestamp"), "yyyy-MM-dd:HHmmss")) ...
                .withColumn("T2", dateFormatFunc(DS2.col("Timestamp"), "MM/dd/yyyy?HH-mm-ss")) ...
                .withColumn("T3", dateFormatFunc(DS2.col("Timestamp"), "dd-MM-yyyy @ HH.mm.ss")) ...
                .withColumn("T4", dateFormatFunc(DS2.col("Timestamp"), "y-M-d:Hms")) ...
                .withColumn("T5", dateFormatFunc(DS2.col("Timestamp"), "yy-MMM-dd HH:mm:ss")) ...
                ;
            T = table(DS3);
            testCase.verifyClass(T.Timestamp, 'datetime');
            testCase.verifyClass(T.T1, 'string');
            testCase.verifyClass(T.T2, 'string');
            testCase.verifyClass(T.T3, 'string');
            testCase.verifyClass(T.T4, 'string');
            testCase.verifyClass(T.T5, 'string');
        end
        
        
        function testUnixTime(testCase)
            % Test unix_timestamp and from_unixtime
            toTSFunc = getFuncHandle(testCase, "to_timestamp");
            unixTSFunc = getFuncHandle(testCase, "unix_timestamp");
            fromUnixFunc = getFuncHandle(testCase, "from_unixtime");
            
            DS = testCase.dateDS;
            
            DS2 = DS ...
                .withColumn("Timestamp", toTSFunc(DS.col("yyyyMMdd_HHmmss")));
            
            DS3 = DS2 ...
                .withColumn("UT1", unixTSFunc()) ...
                .withColumn("UT2", unixTSFunc(DS2.col("Timestamp"))) ...
                .withColumn("UT3", unixTSFunc(DS2.col("yyyyMMdd_HHmmss"), "yyyy-MM-dd HH:mm:ss")) ...
                ;

            DS4 = DS3 ...
                .withColumn("T1", fromUnixFunc(DS3.col("UT2"), "yyyy-MM-dd:HHmmss")) ...
                .withColumn("T2", fromUnixFunc(DS3.col("UT3"))) ...
                ;
            T = table(DS4);

            testCase.verifyClass(T.UT1 ,'int64');
            testCase.verifyClass(T.UT2 ,'int64');
            testCase.verifyClass(T.UT3 ,'int64');
            
            testCase.verifyClass(T.T1, 'string')
            testCase.verifyClass(T.T2, 'string')

        end
        
        function testUtcFunctions(testCase)
            % Testing to_utc_timestamp and from_utc_timestamp
            
            toTSFunc = getFuncHandle(testCase, "to_timestamp");
            fromUTCTSFunc = getFuncHandle(testCase, "from_utc_timestamp");
            
            DS = testCase.dateDS;
            DS2 = DS ...
                .withColumn("Timestamp", toTSFunc(DS.col("yyyyMMdd_HHmmss")));

            tCol = DS2.col("yyyyMMdd_HHmmss");
            DS3 = DS2 ...
                .withColumn("GMT", fromUTCTSFunc(tCol, "GMT")) ...
                .withColumn("EST", fromUTCTSFunc(tCol, "EST")) ...
                .withColumn("Mixed", fromUTCTSFunc(tCol, DS2.col("TimeZone"))) ...
                ;

            tCol = DS3.col("yyyyMMdd_HHmmss");
            DS4 = DS3 ...
                .withColumn("UTC1", fromUTCTSFunc(tCol, "GMT")) ...
                .withColumn("UTC2", fromUTCTSFunc(tCol, "EST")) ...
                .withColumn("UTC3", fromUTCTSFunc(tCol, DS2.col("TimeZone"))) ...
                .select("yyyyMMdd_HHmmss", "GMT", "EST", "Mixed", "UTC1", "UTC2", "UTC3") ...
                ;

            T = table(DS4);
            testCase.verifyClass(T.GMT, 'datetime');
            testCase.verifyClass(T.EST, 'datetime');
            testCase.verifyClass(T.Mixed, 'datetime');
            testCase.verifyEqual(T.Mixed(1), T.GMT(1));
            testCase.verifyEqual(T.Mixed(2), T.EST(2));
            testCase.verifyNotEqual(T.Mixed(1), T.EST(1));
            testCase.verifyNotEqual(T.Mixed(2), T.GMT(2));

            testCase.verifyClass(T.UTC1, 'datetime');
            testCase.verifyClass(T.UTC2, 'datetime');
            testCase.verifyClass(T.UTC3, 'datetime');
            testCase.verifyEqual(T.UTC1(1), T.UTC3(1));
            testCase.verifyEqual(T.UTC2(2), T.UTC3(2));
            testCase.verifyNotEqual(T.UTC1(2), T.UTC3(2));
            testCase.verifyNotEqual(T.UTC2(1), T.UTC3(1));
        end
        
        function testLit(testCase)
            litFunc = getFuncHandle(testCase, "lit");
            
            % Add a column with a number
            dsN = testCase.dsNames.withColumn("litNumTest", ...
                                                litFunc(1));
            % Add a column with a string
            dsN2 = dsN.withColumn("litStringTest", ...
                litFunc("Hello"));
            
            colCount = numel(dsN2.columns);
            t1 = table(dsN2);
            
            testCase.verifyEqual(colCount, 7);
            testCase.verifyTrue(strcmp("Hello", t1.litStringTest(4)));            
        end
        
        function testColumn(testCase)
            columnFunc = getFuncHandle(testCase, "column");
            
            % Add a column 
            
            dsN = testCase.dsNames.withColumn("testCol", columnFunc("Age"));
            colCount = numel(dsN.columns);
            
            testCase.verifyEqual(colCount, 6);

            errId = 'MATLAB:validators:mustBeTextScalar';
            testCase.verifyError(@()dsN.withColumn(...
                        columnFunc(6)), errId);            
        end
        
        function testWhen(testCase)
            whenFunc = getFuncHandle(testCase, "when");
            
            % Add a column based on a single column value 
            petCol = testCase.dsNames.col("Pet");
            dsN = testCase.dsNames.withColumn(...
                "testCol", ...
                whenFunc(petCol == "Cat", "C")...
                .when(petCol == "Giraffe", "G")...
                .when(petCol == "Iguana", "I")...
                .otherwise_("F"));

            colCount = numel(dsN.columns);
            t1 = table(dsN);
            testColValF = t1.testCol(1);
            testColValC = t1.testCol(2);
            testColValI = t1.testCol(3);
            testColValG = t1.testCol(5);
            
            
            testCase.verifyEqual(colCount, 6);
            testCase.verifyTrue(strcmp("F", testColValF));
            testCase.verifyTrue(strcmp("C", testColValC));
            testCase.verifyTrue(strcmp("I", testColValI));
            testCase.verifyTrue(strcmp("G", testColValG));
            
            % Test multiple columns
            
        end

        function testAggPRoduct(testCase)
            % testAggPRoduct
            % Test creation and results borrowed from:
            % https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.functions.product.html
            spark = testCase.sparkSession;
            df = spark.sql("SELECT id % 3 AS mod3, id AS value FROM RANGE(10)");
            out = df.groupBy('mod3').agg(matlab.pyspark.sql.functions.product('value')).orderBy('mod3');
            outT = out.table();
            testCase.verifyEqual(outT.mod3, int64([0,1,2]'), "mod3 problem")
            testCase.verifyLessThan(max(abs(outT.('product(value)')-[0, 28, 80]')), 1e-10, "product problem")
            % +----+--------------+
            % |mod3|product(value)|
            % +----+--------------+
            % |   0|           0.0|
            % |   1|          28.0|
            % |   2|          80.0|
            % +----+--------------+
        end
    end
    methods (Access=protected)
        function FH = getFuncHandle(~, funcName)
            fullFuncName = sprintf("matlab.pyspark.sql.functions.%s", funcName);
            FH = str2func(fullFuncName);
        end
    end
end

function testTimeHelper(testCase, newColName, limitLow, limitHigh, sqlFunc)
    import matlab.spark.sql.*
    
    outages = testCase.ds;
    dsh = outages ...
        .withColumn(newColName, sqlFunc(outages.col('OutageTime')));
    
    origColumns = outages.columns;
    newColumns = dsh.columns;
    
    diffCols = setdiff(newColumns, origColumns);
    testCase.verifyEqual(length(newColumns), length(origColumns)+1);
    testCase.verifyEqual(diffCols, newColName);
    
    dsOH = dsh.select(newColName);
    TOH = table(dsOH);
    OH = TOH.(newColName);
    
    testCase.verifyGreaterThanOrEqual(max(OH),limitLow)
    testCase.verifyLessThanOrEqual(max(OH),limitHigh);
end
