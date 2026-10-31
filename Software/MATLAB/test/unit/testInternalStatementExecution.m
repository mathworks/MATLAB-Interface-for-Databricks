classdef testInternalStatementExecution < matlab.unittest.TestCase
    % TESTINTERNALSTATEMENTEXECUTION Regression tests for internal statement execution helpers.

    % Copyright 2026 The MathWorks, Inc.

    properties
        WarehouseId string = string.empty
    end

    methods (TestClassSetup)
        function startStatementExecutionWarehouse(testCase)
            testCase.WarehouseId = testCase.getStatementExecutionWarehouseId();
        end
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testRunStatementImplTimeoutCanExpireBeforeExecute(testCase)
            testCase.verifyError(@() databricks.internal.statementexecution.runStatementImpl( ...
                "SELECT 1", "dummy-warehouse-id", timeout=0, verbose=false), ...
                "DATABRICKS:runStatementImpl:Timeout");
        end

        function testRunStatementImplExternalLinksCSVWritesResultFile(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            resultFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            [actualResultFile, status, statementId] = databricks.internal.statementexecution.runStatementImpl( ...
                "SELECT * FROM samples.nyctaxi.trips LIMIT 10", testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS, ...
                format=databricks.datastructures.statementexecution.Format.CSV, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=resultFile, ...
                verbose=false);

            testCase.verifyEqual(actualResultFile, resultFile);
            testCase.verifyEqual(status.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyTrue(isfile(resultFile));

            csvData = readcell(resultFile, FileType="text");
            testCase.verifyGreaterThanOrEqual(size(csvData, 1), 10);
            testCase.verifyGreaterThanOrEqual(size(csvData, 2), 2);
            testCase.verifyTrue(any(cellfun(@(value) ~isempty(value), csvData), "all"));

            clear cleanup
        end

        function testRunStatementImplInlineJSONWritesResultFile(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            [actualResultFile, status, statementId] = databricks.internal.statementexecution.runStatementImpl( ...
                "SELECT trip_distance FROM samples.nyctaxi.trips LIMIT 3", testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.INLINE, ...
                format=databricks.datastructures.statementexecution.Format.JSON_ARRAY, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=resultFile, ...
                verbose=false);

            testCase.verifyEqual(actualResultFile, resultFile);
            testCase.verifyEqual(status.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyTrue(isfile(resultFile));

            resultData = jsondecode(fileread(resultFile));
            testCase.verifyEqual(numel(resultData), 3);

            clear cleanup
        end

        function testResponse2TableUsesManifestSchema(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT trip_distance, fare_amount FROM samples.nyctaxi.trips LIMIT 3";
            request.warehouseId = testCase.WarehouseId;
            request.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            request.disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
            request.waitTimeout = "30s";
            request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;

            statementExecution = databricks.StatementExecution;
            [response, errorResponse] = statementExecution.execute(request);
            testCase.verifyEmpty(errorResponse);
            testCase.assertEqual(response.status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, jsonencode(response.result.dataArray), "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(height(T), 3);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ...
                ["trip_distance", "fare_amount"]);
            testCase.verifyEqual(string(T.Properties.Description), response.statementId);
            testCase.verifyEqual(numel(T.Properties.VariableDescriptions), 2);

            clear cleanup
        end

        function testResponse2TableMapsSchemaTypes(testCase)
            response = databricks.datastructures.statementexecution.StatementResponse;
            response.statementId = "synthetic-statement-id";
            response.manifest = databricks.datastructures.statementexecution.Manifest;
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalChunkCount = int32(1);
            response.manifest.totalRowCount = int64(0);
            response.manifest.truncated = false;
            response.manifest.schema = databricks.datastructures.statementexecution.Schema;

            variableNames = [
                "boolean_col"
                "byte_col"
                "short_col"
                "int_col"
                "long_col"
                "float_col"
                "double_col"
                "date_col"
                "timestamp_col"
                "string_col"
                "binary_col"
                "decimal_double_col"
                "decimal_string_col"
                "interval_col"
                "array_col"
                "struct_col"
                "map_col"
                "char_col"
                "null_col"
                "user_defined_type_col"
            ];
            columnTypes = [
                databricks.datastructures.statementexecution.ColumnInfoType.BOOLEAN
                databricks.datastructures.statementexecution.ColumnInfoType.BYTE
                databricks.datastructures.statementexecution.ColumnInfoType.SHORT
                databricks.datastructures.statementexecution.ColumnInfoType.INT
                databricks.datastructures.statementexecution.ColumnInfoType.LONG
                databricks.datastructures.statementexecution.ColumnInfoType.FLOAT
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
                databricks.datastructures.statementexecution.ColumnInfoType.DATE
                databricks.datastructures.statementexecution.ColumnInfoType.TIMESTAMP
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.BINARY
                databricks.datastructures.statementexecution.ColumnInfoType.DECIMAL
                databricks.datastructures.statementexecution.ColumnInfoType.DECIMAL
                databricks.datastructures.statementexecution.ColumnInfoType.INTERVAL
                databricks.datastructures.statementexecution.ColumnInfoType.ARRAY
                databricks.datastructures.statementexecution.ColumnInfoType.STRUCT
                databricks.datastructures.statementexecution.ColumnInfoType.MAP
                databricks.datastructures.statementexecution.ColumnInfoType.CHAR
                databricks.datastructures.statementexecution.ColumnInfoType.NULL
                databricks.datastructures.statementexecution.ColumnInfoType.USER_DEFINED_TYPE
            ];
            typePrecision = int32([
                0
                0
                0
                0
                0
                0
                0
                0
                0
                0
                0
                10
                38
                0
                0
                0
                0
                0
                0
                0
            ]);
            expectedClasses = [
                "logical"
                "int8"
                "int16"
                "int32"
                "int64"
                "single"
                "double"
                "datetime"
                "datetime"
                "string"
                "string"
                "double"
                "string"
                "string"
                "string"
                "string"
                "string"
                "string"
                "string"
                "string"
            ];

            numColumns = numel(columnTypes);
            columns(1, numColumns) = databricks.datastructures.statementexecution.Column;
            for idx = 1:numColumns
                columns(idx).name = variableNames(idx);
                columns(idx).position = int32(idx - 1);
                columns(idx).typeName = columnTypes(idx);
                columns(idx).typePrecision = typePrecision(idx);
                columns(idx).typeText = string(columnTypes(idx));
            end
            response.manifest.schema.columnCount = int32(numColumns);
            response.manifest.schema.columns = columns;

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[]", "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(width(T), numColumns);
            testCase.verifyEqual(string(T.Properties.VariableNames)', variableNames);
            for idx = 1:numColumns
                testCase.verifyClass(T.(variableNames(idx)), expectedClasses(idx));
            end

            clear cleanup
        end

        function testResponse2TablePreservesStructureMetadata(testCase)
            response = databricks.datastructures.statementexecution.StatementResponse;
            response.statementId = "metadata-statement-id";
            response.manifest = databricks.datastructures.statementexecution.Manifest;
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalChunkCount = int32(1);
            response.manifest.totalRowCount = int64(4);
            response.manifest.truncated = false;
            response.manifest.schema = databricks.datastructures.statementexecution.Schema;
            response.manifest.schema.columnCount = int32(3);

            columns(1, 3) = databricks.datastructures.statementexecution.Column;
            columns(1).name = "pickup_time";
            columns(1).position = int32(1);
            columns(1).typeName = databricks.datastructures.statementexecution.ColumnInfoType.TIMESTAMP;
            columns(1).typePrecision = int32(0);
            columns(1).typeText = "TIMESTAMP";

            columns(2).name = "trip_id";
            columns(2).position = int32(0);
            columns(2).typeName = databricks.datastructures.statementexecution.ColumnInfoType.STRING;
            columns(2).typePrecision = int32(0);
            columns(2).typeText = "STRING";

            columns(3).name = "fare_amount";
            columns(3).position = int32(2);
            columns(3).typeName = databricks.datastructures.statementexecution.ColumnInfoType.DECIMAL;
            columns(3).typePrecision = int32(10);
            columns(3).typeText = "DECIMAL(10,2)";
            response.manifest.schema.columns = columns;

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[[""trip-1"",""2026-01-01T01:02:03.000Z"",""12.50""],[" + ...
                """trip-2"",""2026-01-02T01:02:03.000Z"",""14.25""],[" + ...
                """trip-3"",""2026-01-03T01:02:03.000Z"",""16.75""],[" + ...
                """trip-4"",""2026-01-04T01:02:03.000Z"",""18.00""]]", "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(height(T), 4);
            testCase.verifyEqual(width(T), 3);
            testCase.verifyEqual(string(T.Properties.VariableNames), ...
                ["trip_id", "pickup_time", "fare_amount"]);
            testCase.verifyEqual(string(T.Properties.VariableDescriptions), ...
                ["STRING", "TIMESTAMP", "DECIMAL(10,2)"]);
            testCase.verifyEqual(string(T.Properties.Description), response.statementId);
            testCase.verifyEqual(string(T.pickup_time.TimeZone), "UTC");
            testCase.verifyEqual(string(T.trip_id), ["trip-1"; "trip-2"; "trip-3"; "trip-4"]);
            testCase.verifyEqual(T.fare_amount, [12.5; 14.25; 16.75; 18]);
            testCase.verifyEqual(T.Properties.CustomProperties.StatementId, response.statementId);
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFile, resultFile);
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(4));
            testCase.verifyEqual(T.Properties.CustomProperties.TotalChunkCount, int32(1));
            testCase.verifyFalse(T.Properties.CustomProperties.Truncated);

            clear cleanup
        end

        function testResponse2TablePopulatesSyntheticTripJSONFixture(testCase)
            response = testCase.createSyntheticStatementResponse(["trip_distance", "fare_amount"], [
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
            ]);
            response.statementId = "synthetic-trip-json-array-fixture";
            response.manifest.totalRowCount = int64(3);

            resultFile = testCase.getStatementExecutionFixture("synthetic_nyctaxi_trips_json_array.json");

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(height(T), 3);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["trip_distance", "fare_amount"]);
            testCase.verifyEqual(T.trip_distance, [1.37; 2.68; 0.92]);
            testCase.verifyEqual(T.fare_amount, [8.15; 13.05; 6.45]);
            testCase.verifyEqual(string(T.Properties.Description), response.statementId);
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFile, resultFile);
        end

        function testResponse2TablePopulatesSyntheticReviewsJSONFixture(testCase)
            response = testCase.createSyntheticStatementResponse( ...
                ["review_id", "customer_id", "rating", "review_text", "review_date"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.INT
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DATE
            ]);
            response.statementId = "synthetic-media-customer-reviews-json-array-fixture";
            response.manifest.totalRowCount = int64(3);

            resultFile = testCase.getStatementExecutionFixture( ...
                "synthetic_bakehouse_media_customer_reviews_json_array.json");

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(height(T), 3);
            testCase.verifyEqual(width(T), 5);
            testCase.verifyEqual(string(T.Properties.VariableNames), ...
                ["review_id", "customer_id", "rating", "review_text", "review_date"]);
            testCase.verifyEqual(string(T.review_id), ["lorem-1001"; "lorem-1002"; "lorem-1003"]);
            testCase.verifyEqual(string(T.customer_id), ["ipsum-001"; "ipsum-002"; "ipsum-003"]);
            testCase.verifyEqual(T.rating, int32([4; 3; 1]));
            testCase.verifyEqual(string(T.review_date.TimeZone), "UTC");
            testCase.verifyEqual(T.review_date, datetime( ...
                ["2024-04-02"; "2024-04-03"; "2024-04-04"], TimeZone="UTC"));
            testCase.verifyTrue(contains(T.review_text(1), "Lorem ipsum"));
            testCase.verifyTrue(contains(T.review_text(3), "placeholder feedback"));
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFile, resultFile);
        end

        function testRunStatementImplComparesBakehouseReviewsJSONAndExternalCSV(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statement = [
                "SELECT * "
                "FROM samples.bakehouse.media_customer_reviews "
                "ORDER BY 1 "
                "LIMIT 3"
            ];
            statement = join(statement, "");

            jsonResultFile = tempname + ".json";
            csvResultFile = tempname + ".csv";
            cleanupJSON = onCleanup(@() testCase.deleteFileIfExists(jsonResultFile));
            cleanupCSV = onCleanup(@() testCase.deleteFileIfExists(csvResultFile));

            [~, jsonStatus, jsonStatementId, jsonTable] = ...
                databricks.internal.statementexecution.runStatementImpl( ...
                statement, testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.INLINE, ...
                format=databricks.datastructures.statementexecution.Format.JSON_ARRAY, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=jsonResultFile, ...
                verbose=false);

            [~, csvStatus, csvStatementId, csvTable] = ...
                databricks.internal.statementexecution.runStatementImpl( ...
                statement, testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS, ...
                format=databricks.datastructures.statementexecution.Format.CSV, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=csvResultFile, ...
                verbose=false);

            testCase.verifyEqual(jsonStatus.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(csvStatus.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(jsonStatementId);
            testCase.verifyNotEmpty(csvStatementId);
            testCase.verifyEqual(height(jsonTable), 3);
            testCase.verifyEqual(height(csvTable), 3);
            testCase.verifyEqual(string(jsonTable.Properties.VariableNames), ...
                string(csvTable.Properties.VariableNames));
            testCase.verifyEqual(testCase.table2StringMatrix(jsonTable), ...
                testCase.table2StringMatrix(csvTable));

            clear cleanupJSON cleanupCSV
        end

        function testRunStatementImplExternalLinksCSVConvertsGeneratedTypes(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statement = [
                "SELECT "
                "CAST('001' AS STRING) AS text_id, "
                "CAST(42 AS INT) AS int_col, "
                "CAST(12.5 AS DOUBLE) AS double_col, "
                "CAST(true AS BOOLEAN) AS bool_col, "
                "CAST('2026-01-02' AS DATE) AS date_col"
            ];
            statement = join(statement, "");

            resultFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            [~, status, statementId, T] = databricks.internal.statementexecution.runStatementImpl( ...
                statement, testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS, ...
                format=databricks.datastructures.statementexecution.Format.CSV, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=resultFile, ...
                verbose=false);

            testCase.verifyEqual(status.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyEqual(T.text_id, "001");
            testCase.verifyClass(T.int_col, "int32");
            testCase.verifyEqual(T.int_col, int32(42));
            testCase.verifyEqual(T.double_col, 12.5);
            testCase.verifyClass(T.bool_col, "logical");
            testCase.verifyTrue(T.bool_col);
            testCase.verifyClass(T.date_col, "datetime");
            testCase.verifyEqual(string(T.date_col.TimeZone), "UTC");
            testCase.verifyEqual(T.date_col, datetime("2026-01-02", TimeZone="UTC"));

            clear cleanup
        end

        function testRunStatementImplExternalLinksCSVLimitZeroReturnsEmptyTable(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statement = "SELECT CAST('001' AS STRING) AS text_id, CAST(42 AS INT) AS int_col LIMIT 0";
            resultFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            [actualResultFile, status, statementId, T] = databricks.internal.statementexecution.runStatementImpl( ...
                statement, testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS, ...
                format=databricks.datastructures.statementexecution.Format.CSV, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=resultFile, ...
                verbose=false);

            testCase.verifyEqual(actualResultFile, resultFile);
            testCase.verifyEqual(status.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyEqual(height(T), 0);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["text_id", "int_col"]);
            testCase.verifyClass(T.text_id, "string");
            testCase.verifyClass(T.int_col, "int32");

            csvText = string(fileread(resultFile));
            testCase.verifyTrue(startsWith(csvText, "text_id,int_col"));
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "CSV");
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(0));

            clear cleanup
        end

        function testRunStatementImplInlineJSONLimitZeroReturnsEmptyTable(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end
            
            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statement = "SELECT CAST('001' AS STRING) AS text_id, CAST(42 AS INT) AS int_col LIMIT 0";
            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            [actualResultFile, status, statementId, T] = databricks.internal.statementexecution.runStatementImpl( ...
                statement, testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.INLINE, ...
                format=databricks.datastructures.statementexecution.Format.JSON_ARRAY, ...
                waitTimeout="30s", ...
                onWaitTimeout=databricks.datastructures.statementexecution.TimeoutAction.CANCEL, ...
                resultFile=resultFile, ...
                verbose=false);

            testCase.verifyEqual(actualResultFile, resultFile);
            testCase.verifyEqual(status.state, databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyEqual(height(T), 0);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["text_id", "int_col"]);
            testCase.verifyClass(T.text_id, "string");
            testCase.verifyClass(T.int_col, "int32");

            jsonText = strtrim(string(fileread(resultFile)));
            testCase.verifyEqual(jsonText, "[]");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(0));

            clear cleanup
        end

        function testResponse2TableRejectsMissingResultFile(testCase)
            response = testCase.createSyntheticStatementResponse("trip_id", ...
                databricks.datastructures.statementexecution.ColumnInfoType.STRING);
            missingResultFile = tempname + ".json";

            testCase.verifyError(@() databricks.internal.statementexecution.response2Table( ...
                response, missingResultFile, verbose=false), ...
                "DATABRICKS:response2Table");
        end

        function testResponse2TableRejectsDuplicateColumnPositions(testCase)
            response = testCase.createSyntheticStatementResponse(["trip_id", "fare_amount"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
            ]);
            response.manifest.schema.columns(2).position = int32(0);

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[]", "char");
            clear closeFile

            testCase.verifyError(@() databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false), ...
                "DATABRICKS:response2Table");

            clear cleanup
        end

        function testResponse2TableReadsCSVResultFile(testCase)
            response = testCase.createSyntheticStatementResponse(["trip_id", "fare_amount"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.CSV;
            response.manifest.totalRowCount = int64(2);

            resultFile = testCase.writeTempCSVResultFile();
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyEqual(height(T), 2);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["trip_id", "fare_amount"]);
            testCase.verifyEqual(string(T.trip_id), ["trip-1"; "trip-2"]);
            testCase.verifyEqual(T.fare_amount, [12.5; 18.75]);
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "CSV");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFile, resultFile);

            clear cleanup
        end

        function testResponse2TableConvertsCSVTypesFromSchema(testCase)
            response = testCase.createSyntheticStatementResponse( ...
                ["text_id", "int_col", "double_col", "bool_col", "date_col", "timestamp_col"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.INT
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
                databricks.datastructures.statementexecution.ColumnInfoType.BOOLEAN
                databricks.datastructures.statementexecution.ColumnInfoType.DATE
                databricks.datastructures.statementexecution.ColumnInfoType.TIMESTAMP
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.CSV;
            response.manifest.totalRowCount = int64(2);

            resultFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fprintf(fileId, "001,42,12.5,true,2026-01-02,2026-01-02T03:04:05.000Z\n");
            fprintf(fileId, "002,7,18.75,false,2026-01-03,2026-01-03T04:05:06.000Z\n");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false);

            testCase.verifyClass(T.text_id, "string");
            testCase.verifyEqual(T.text_id, ["001"; "002"]);
            testCase.verifyClass(T.int_col, "int32");
            testCase.verifyEqual(T.int_col, int32([42; 7]));
            testCase.verifyClass(T.double_col, "double");
            testCase.verifyEqual(T.double_col, [12.5; 18.75]);
            testCase.verifyClass(T.bool_col, "logical");
            testCase.verifyEqual(T.bool_col, [true; false]);
            testCase.verifyClass(T.date_col, "datetime");
            testCase.verifyEqual(string(T.date_col.TimeZone), "UTC");
            testCase.verifyEqual(T.date_col, datetime( ...
                ["2026-01-02"; "2026-01-03"], TimeZone="UTC"));
            testCase.verifyClass(T.timestamp_col, "datetime");
            testCase.verifyEqual(string(T.timestamp_col.TimeZone), "UTC");
            testCase.verifyEqual(T.timestamp_col, datetime( ...
                ["2026-01-02T03:04:05.000Z"; "2026-01-03T04:05:06.000Z"], ...
                InputFormat="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", TimeZone="UTC"));

            clear cleanup
        end

        function testResponse2TableCanDisableCSVSchemaTypes(testCase)
            response = testCase.createSyntheticStatementResponse(["text_id", "fare_amount"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.CSV;
            response.manifest.totalRowCount = int64(2);

            resultFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fprintf(fileId, "001,12.5\n002,18.75\n");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false, verbose=false);

            testCase.verifyNotEqual(class(T.text_id), "string");
            testCase.verifyEqual(T.text_id, [1; 2]);
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "CSV");

            clear cleanup
        end

        function testResponse2TableHandlesEmptyCSVWithSchemaTypes(testCase)
            response = testCase.createSyntheticStatementResponse(["text_id", "amount", "event_date"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
                databricks.datastructures.statementexecution.ColumnInfoType.DATE
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.CSV;
            response.manifest.totalRowCount = int64(0);

            resultFile = testCase.writeEmptyCSVResultFile();
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            T = databricks.internal.statementexecution.response2Table(response, resultFile);

            testCase.verifyEqual(height(T), 0);
            testCase.verifyEqual(width(T), 3);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["text_id", "amount", "event_date"]);
            testCase.verifyClass(T.text_id, "string");
            testCase.verifyClass(T.amount, "double");
            testCase.verifyClass(T.event_date, "datetime");
            testCase.verifyEqual(string(T.event_date.TimeZone), "UTC");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "CSV");
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(0));

            clear cleanup
        end

        function testResponse2TableHandlesEmptyCSVWithoutSchemaTypes(testCase)
            response = testCase.createSyntheticStatementResponse(["text_id", "amount"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.DOUBLE
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.CSV;
            response.manifest.totalRowCount = int64(0);

            resultFile = testCase.writeEmptyCSVResultFile();
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false);

            testCase.verifyEqual(height(T), 0);
            testCase.verifyEqual(width(T), 2);
            testCase.verifyEqual(string(T.Properties.VariableNames), ["text_id", "amount"]);
            testCase.verifyClass(T.text_id, "string");
            testCase.verifyClass(T.amount, "string");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "CSV");
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(0));

            clear cleanup
        end

        function testResponse2TableCanDisableJSONSchemaTypes(testCase)
            response = testCase.createSyntheticStatementResponse(["text_id", "int_col"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.INT
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalRowCount = int64(2);

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            rawJSON = "[[""001"",""42""],[""002"",""7""]]";
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, rawJSON, "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false, verbose=false);

            testCase.verifyEqual(height(T), 2);
            testCase.verifyEqual(width(T), 1);
            testCase.verifyEqual(string(T.Properties.VariableNames), "Result");
            testCase.verifyClass(T.Result, "string");
            testCase.verifyEqual(T.Result, ["[""001"",""42""]"; "[""002"",""7""]"]);
            testCase.verifyEqual(string(T.Properties.VariableDescriptions), ...
                "Raw JSON_ARRAY result row");
            testCase.verifyEqual(T.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
            testCase.verifyEqual(T.Properties.CustomProperties.TotalRowCount, int64(2));

            clear cleanup
        end

        function testResponse2TableReturnsEmptyRawJSONRows(testCase)
            response = testCase.createSyntheticStatementResponse(["text_id", "int_col"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.INT
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalRowCount = int64(0);

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[]", "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false, verbose=false);

            testCase.verifyEqual(height(T), 0);
            testCase.verifyEqual(width(T), 1);
            testCase.verifyEqual(string(T.Properties.VariableNames), "Result");
            testCase.verifyEqual(T.Result, strings(0, 1));

            clear cleanup
        end

        function testResponse2TablePreservesRawJSONNullRow(testCase)
            response = testCase.createSyntheticStatementResponse("maybe_null", ...
                databricks.datastructures.statementexecution.ColumnInfoType.STRING);
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalRowCount = int64(1);

            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[[null]]", "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false, verbose=false);

            testCase.verifyEqual(height(T), 1);
            testCase.verifyEqual(T.Result, "[null]");

            clear cleanup
        end

        function testResponse2TablePreservesRawJSONRowsWithNestedSyntax(testCase)
            response = testCase.createSyntheticStatementResponse(["text_col", "object_col", "array_col"], [
                databricks.datastructures.statementexecution.ColumnInfoType.STRING
                databricks.datastructures.statementexecution.ColumnInfoType.STRUCT
                databricks.datastructures.statementexecution.ColumnInfoType.ARRAY
            ]);
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalRowCount = int64(2);

            rawJSON = ['[ ["a,b","x\"y",{"k":[1,null]}] ,' ...
                ' ["second","brace } comma ,",[]] ]'];
            resultFile = tempname + ".json";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));
            fileId = fopen(resultFile, "w");
            testCase.assertGreaterThan(fileId, 0);
            closeFile = onCleanup(@() fclose(fileId));
            fwrite(fileId, rawJSON, "char");
            clear closeFile

            T = databricks.internal.statementexecution.response2Table( ...
                response, resultFile, applySchemaTypes=false, verbose=false);

            expectedRows = strings(2, 1);
            expectedRows(1) = string('["a,b","x\"y",{"k":[1,null]}]');
            expectedRows(2) = string('["second","brace } comma ,",[]]');
            testCase.verifyEqual(T.Result, expectedRows);

            clear cleanup
        end

        function testResponse2TableRejectsArrowStreamFormat(testCase)
            response = testCase.createSyntheticStatementResponse("trip_id", ...
                databricks.datastructures.statementexecution.ColumnInfoType.STRING);
            response.manifest.format = databricks.datastructures.statementexecution.Format.ARROW_STREAM;

            resultFile = testCase.writeTempJsonResultFile();
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            testCase.verifyError(@() databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false), ...
                "DATABRICKS:response2Table");

            clear cleanup
        end

        function testResponse2TableRejectsTruncatedResponse(testCase)
            response = testCase.createSyntheticStatementResponse("trip_id", ...
                databricks.datastructures.statementexecution.ColumnInfoType.STRING);
            response.manifest.truncated = true;

            resultFile = testCase.writeTempJsonResultFile();
            cleanup = onCleanup(@() testCase.deleteFileIfExists(resultFile));

            testCase.verifyError(@() databricks.internal.statementexecution.response2Table( ...
                response, resultFile, verbose=false), ...
                "DATABRICKS:response2Table");

            clear cleanup
        end
    end

    methods (Access = private)
        function response = createSyntheticStatementResponse(~, variableNames, columnTypes)
            arguments (Input)
                ~
                variableNames (:,1) string
                columnTypes (:,1) databricks.datastructures.statementexecution.ColumnInfoType
            end
            arguments (Output)
                response databricks.datastructures.statementexecution.StatementResponse
            end

            response = databricks.datastructures.statementexecution.StatementResponse;
            response.statementId = "synthetic-statement-id";
            response.manifest = databricks.datastructures.statementexecution.Manifest;
            response.manifest.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            response.manifest.totalChunkCount = int32(1);
            response.manifest.totalRowCount = int64(0);
            response.manifest.truncated = false;
            response.manifest.schema = databricks.datastructures.statementexecution.Schema;

            numColumns = numel(columnTypes);
            columns(1, numColumns) = databricks.datastructures.statementexecution.Column;
            for idx = 1:numColumns
                columns(idx).name = variableNames(idx);
                columns(idx).position = int32(idx - 1);
                columns(idx).typeName = columnTypes(idx);
                columns(idx).typePrecision = int32(0);
                columns(idx).typeText = string(columnTypes(idx));
            end
            response.manifest.schema.columnCount = int32(numColumns);
            response.manifest.schema.columns = columns;
        end

        function fixturePath = getStatementExecutionFixture(~, fileName)
            arguments (Input)
                ~
                fileName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                fixturePath string
            end

            testRoot = fileparts(fileparts(mfilename("fullpath")));
            fixturePath = fullfile(testRoot, "fixtures", "statementexecution", fileName);
        end

        function values = table2StringMatrix(~, T)
            arguments (Input)
                ~
                T table
            end
            arguments (Output)
                values string
            end

            values = strings(height(T), width(T));
            for idx = 1:width(T)
                if isdatetime(T.(idx))
                    values(:, idx) = string(T.(idx), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                else
                    values(:, idx) = string(T.(idx));
                end
            end
        end

        function resultFile = writeTempJsonResultFile(~)
            arguments (Output)
                resultFile string
            end

            resultFile = tempname + ".json";
            fileId = fopen(resultFile, "w");
            cleanup = onCleanup(@() fclose(fileId));
            fwrite(fileId, "[]", "char");
            clear cleanup
        end

        function resultFile = writeTempCSVResultFile(~)
            arguments (Output)
                resultFile string
            end

            resultFile = tempname + ".csv";
            fileId = fopen(resultFile, "w");
            cleanup = onCleanup(@() fclose(fileId));
            fprintf(fileId, "trip-1,12.5\ntrip-2,18.75\n");
            clear cleanup
        end

        function resultFile = writeEmptyCSVResultFile(~)
            arguments (Output)
                resultFile string
            end

            resultFile = tempname + ".csv";
            fileId = fopen(resultFile, "w");
            cleanup = onCleanup(@() fclose(fileId));
            clear cleanup
        end

        function warehouseId = getStatementExecutionWarehouseId(testCase)
            arguments (Output)
                warehouseId string
            end

            warehouseId = string(getenv("DATABRICKS_SQL_WAREHOUSE_ID"));
            if strlength(warehouseId) > 0
                return
            end

            % TODO: Remove this hard-coded default warehouse ID once tests use
            % a fully configurable test warehouse source.
            warehouseId = "02d6196e2aaba1a4";
            return

            httpPath = string(getenv("DATABRICKS_HTTP_PATH"));
            if strlength(httpPath) > 0 && contains(lower(httpPath), "/warehouses/")
                pathParts = split(httpPath, "/");
                warehouseId = testCase.startWarehouse(pathParts(end));
                if strlength(warehouseId) > 0
                    return
                end
            end

            try
                warehouses = databricks.SQLWarehouse.list();
            catch
                return
            end

            if isempty(warehouses)
                return
            end

            runningWarehouse = warehouses([warehouses.state] == databricks.datastructures.WarehouseState.RUNNING);
            if ~isempty(runningWarehouse)
                warehouseId = runningWarehouse(1).id;
            else
                warehouseId = testCase.startWarehouse(warehouses(1).id);
            end
        end

        function warehouseId = startWarehouse(~, warehouseId)
            if isempty(warehouseId) || strlength(warehouseId) == 0
                warehouseId = string.empty;
                return
            end

            try
                warehouse = databricks.SQLWarehouse;
                warehouse.id = warehouseId;
                warehouse.refresh();

                if warehouse.state ~= databricks.datastructures.WarehouseState.RUNNING
                    warehouse.start();
                end

                timeout = 7 * 60;
                t = tic;
                while warehouse.state == databricks.datastructures.WarehouseState.STARTING && toc(t) < timeout
                    pause(5);
                    warehouse.refresh();
                end

                if warehouse.state ~= databricks.datastructures.WarehouseState.RUNNING
                    warehouseId = string.empty;
                end
            catch
                warehouseId = string.empty;
            end
        end

        function deleteFileIfExists(~, fileName)
            if isfile(fileName)
                delete(fileName);
            end
        end
    end
end
