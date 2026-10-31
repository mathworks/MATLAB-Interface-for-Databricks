classdef testStatementExecution < matlab.unittest.TestCase
    % TESTSTATEMENTEXECUTION Unit tests for StatementExecution class.

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
        function testErrorCodeEnumMembers(testCase)
            errorCodes = [
                databricks.datastructures.statementexecution.ErrorCode.UNKNOWN
                databricks.datastructures.statementexecution.ErrorCode.INTERNAL_ERROR
                databricks.datastructures.statementexecution.ErrorCode.TEMPORARILY_UNAVAILABLE
                databricks.datastructures.statementexecution.ErrorCode.IO_ERROR
                databricks.datastructures.statementexecution.ErrorCode.BAD_REQUEST
                databricks.datastructures.statementexecution.ErrorCode.SERVICE_UNDER_MAINTENANCE
                databricks.datastructures.statementexecution.ErrorCode.WORKSPACE_TEMPORARILY_UNAVAILABLE
                databricks.datastructures.statementexecution.ErrorCode.DEADLINE_EXCEEDED
                databricks.datastructures.statementexecution.ErrorCode.CANCELLED
                databricks.datastructures.statementexecution.ErrorCode.RESOURCE_EXHAUSTED
                databricks.datastructures.statementexecution.ErrorCode.ABORTED
                databricks.datastructures.statementexecution.ErrorCode.NOT_FOUND
                databricks.datastructures.statementexecution.ErrorCode.ALREADY_EXISTS
                databricks.datastructures.statementexecution.ErrorCode.UNAUTHENTICATED
            ];

            expectedValues = [
                "UNKNOWN"
                "INTERNAL_ERROR"
                "TEMPORARILY_UNAVAILABLE"
                "IO_ERROR"
                "BAD_REQUEST"
                "SERVICE_UNDER_MAINTENANCE"
                "WORKSPACE_TEMPORARILY_UNAVAILABLE"
                "DEADLINE_EXCEEDED"
                "CANCELLED"
                "RESOURCE_EXHAUSTED"
                "ABORTED"
                "NOT_FOUND"
                "ALREADY_EXISTS"
                "UNAUTHENTICATED"
            ];

            testCase.verifyClass(errorCodes, 'databricks.datastructures.statementexecution.ErrorCode');
            testCase.verifyEqual(string(errorCodes), expectedValues);

            for idx = 1:numel(errorCodes)
                testCase.verifyEqual(errorCodes(idx), errorCodes(idx));

                otherIndices = setdiff(1:numel(errorCodes), idx);
                for otherIdx = otherIndices
                    testCase.verifyNotEqual(errorCodes(idx), errorCodes(otherIdx));
                end
            end
        end

        function testErrorCodeFromJSON(testCase)
            values = [
                databricks.datastructures.statementexecution.ErrorCode.UNKNOWN
                databricks.datastructures.statementexecution.ErrorCode.INTERNAL_ERROR
                databricks.datastructures.statementexecution.ErrorCode.TEMPORARILY_UNAVAILABLE
                databricks.datastructures.statementexecution.ErrorCode.IO_ERROR
                databricks.datastructures.statementexecution.ErrorCode.BAD_REQUEST
                databricks.datastructures.statementexecution.ErrorCode.SERVICE_UNDER_MAINTENANCE
                databricks.datastructures.statementexecution.ErrorCode.WORKSPACE_TEMPORARILY_UNAVAILABLE
                databricks.datastructures.statementexecution.ErrorCode.DEADLINE_EXCEEDED
                databricks.datastructures.statementexecution.ErrorCode.CANCELLED
                databricks.datastructures.statementexecution.ErrorCode.RESOURCE_EXHAUSTED
                databricks.datastructures.statementexecution.ErrorCode.ABORTED
                databricks.datastructures.statementexecution.ErrorCode.NOT_FOUND
                databricks.datastructures.statementexecution.ErrorCode.ALREADY_EXISTS
                databricks.datastructures.statementexecution.ErrorCode.UNAUTHENTICATED
            ];
            expectedValues = [
                "UNKNOWN"
                "INTERNAL_ERROR"
                "TEMPORARILY_UNAVAILABLE"
                "IO_ERROR"
                "BAD_REQUEST"
                "SERVICE_UNDER_MAINTENANCE"
                "WORKSPACE_TEMPORARILY_UNAVAILABLE"
                "DEADLINE_EXCEEDED"
                "CANCELLED"
                "RESOURCE_EXHAUSTED"
                "ABORTED"
                "NOT_FOUND"
                "ALREADY_EXISTS"
                "UNAUTHENTICATED"
            ];

            for idx = 1:numel(expectedValues)
                errorCode = databricks.datastructures.statementexecution.ErrorCode.UNKNOWN.fromJSON(expectedValues(idx));

                testCase.verifyEqual(errorCode, values(idx));
                testCase.verifyEqual(string(errorCode), expectedValues(idx));
            end
        end

        function testDispositionEnumMembers(testCase)
            values = [
                databricks.datastructures.statementexecution.Disposition.INLINE
                databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS
            ];
            expectedValues = [
                "INLINE"
                "EXTERNAL_LINKS"
            ];

            testCase.verifyStatementExecutionEnum(values, expectedValues, ...
                'databricks.datastructures.statementexecution.Disposition');
        end

        function testDispositionFromJSON(testCase)
            disposition = databricks.datastructures.statementexecution.Disposition.INLINE.fromJSON("EXTERNAL_LINKS");

            testCase.verifyEqual(disposition, databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS);
            testCase.verifyEqual(string(disposition), "EXTERNAL_LINKS");
        end

        function testFormatEnumMembers(testCase)
            values = [
                databricks.datastructures.statementexecution.Format.FORMAT_UNSPECIFIED
                databricks.datastructures.statementexecution.Format.JSON_ARRAY
                databricks.datastructures.statementexecution.Format.ARROW_STREAM
                databricks.datastructures.statementexecution.Format.CSV
            ];
            expectedValues = [
                "FORMAT_UNSPECIFIED"
                "JSON_ARRAY"
                "ARROW_STREAM"
                "CSV"
            ];

            testCase.verifyStatementExecutionEnum(values, expectedValues, ...
                'databricks.datastructures.statementexecution.Format');
        end

        function testFormatFromJSON(testCase)
            format = databricks.datastructures.statementexecution.Format.FORMAT_UNSPECIFIED.fromJSON("JSON_ARRAY");

            testCase.verifyEqual(format, databricks.datastructures.statementexecution.Format.JSON_ARRAY);
            testCase.verifyEqual(string(format), "JSON_ARRAY");
        end

        function testTimeoutActionEnumMembers(testCase)
            values = [
                databricks.datastructures.statementexecution.TimeoutAction.TIMEOUT_ACTION_UNSPECIFIED
                databricks.datastructures.statementexecution.TimeoutAction.CONTINUE
                databricks.datastructures.statementexecution.TimeoutAction.CANCEL
            ];
            expectedValues = [
                "TIMEOUT_ACTION_UNSPECIFIED"
                "CONTINUE"
                "CANCEL"
            ];

            testCase.verifyStatementExecutionEnum(values, expectedValues, ...
                'databricks.datastructures.statementexecution.TimeoutAction');
        end

        function testTimeoutActionFromJSON(testCase)
            values = [
                databricks.datastructures.statementexecution.TimeoutAction.TIMEOUT_ACTION_UNSPECIFIED
                databricks.datastructures.statementexecution.TimeoutAction.CONTINUE
                databricks.datastructures.statementexecution.TimeoutAction.CANCEL
            ];
            expectedValues = [
                "TIMEOUT_ACTION_UNSPECIFIED"
                "CONTINUE"
                "CANCEL"
            ];

            for idx = 1:numel(expectedValues)
                timeoutAction = databricks.datastructures.statementexecution.TimeoutAction.TIMEOUT_ACTION_UNSPECIFIED.fromJSON(expectedValues(idx));

                testCase.verifyEqual(timeoutAction, values(idx));
                testCase.verifyEqual(string(timeoutAction), expectedValues(idx));
            end
        end

        function testStateEnumMembers(testCase)
            values = [
                databricks.datastructures.statementexecution.State.STATE_UNSPECIFIED
                databricks.datastructures.statementexecution.State.PENDING
                databricks.datastructures.statementexecution.State.RUNNING
                databricks.datastructures.statementexecution.State.SUCCEEDED
                databricks.datastructures.statementexecution.State.FAILED
                databricks.datastructures.statementexecution.State.CANCELED
                databricks.datastructures.statementexecution.State.CLOSED
            ];
            expectedValues = [
                "STATE_UNSPECIFIED"
                "PENDING"
                "RUNNING"
                "SUCCEEDED"
                "FAILED"
                "CANCELED"
                "CLOSED"
            ];

            testCase.verifyStatementExecutionEnum(values, expectedValues, ...
                'databricks.datastructures.statementexecution.State');
        end

        function testStateFromJSON(testCase)
            values = [
                databricks.datastructures.statementexecution.State.STATE_UNSPECIFIED
                databricks.datastructures.statementexecution.State.PENDING
                databricks.datastructures.statementexecution.State.RUNNING
                databricks.datastructures.statementexecution.State.SUCCEEDED
                databricks.datastructures.statementexecution.State.FAILED
                databricks.datastructures.statementexecution.State.CANCELED
                databricks.datastructures.statementexecution.State.CLOSED
            ];
            expectedValues = [
                "STATE_UNSPECIFIED"
                "PENDING"
                "RUNNING"
                "SUCCEEDED"
                "FAILED"
                "CANCELED"
                "CLOSED"
            ];

            for idx = 1:numel(expectedValues)
                state = databricks.datastructures.statementexecution.State.STATE_UNSPECIFIED.fromJSON(expectedValues(idx));

                testCase.verifyEqual(state, values(idx));
                testCase.verifyEqual(string(state), expectedValues(idx));
            end
        end

        function testColumnInfoTypeEnumMembers(testCase)
            values = [
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
                databricks.datastructures.statementexecution.ColumnInfoType.INTERVAL
                databricks.datastructures.statementexecution.ColumnInfoType.ARRAY
                databricks.datastructures.statementexecution.ColumnInfoType.STRUCT
                databricks.datastructures.statementexecution.ColumnInfoType.MAP
                databricks.datastructures.statementexecution.ColumnInfoType.CHAR
                databricks.datastructures.statementexecution.ColumnInfoType.NULL
                databricks.datastructures.statementexecution.ColumnInfoType.USER_DEFINED_TYPE
            ];
            expectedValues = [
                "BOOLEAN"
                "BYTE"
                "SHORT"
                "INT"
                "LONG"
                "FLOAT"
                "DOUBLE"
                "DATE"
                "TIMESTAMP"
                "STRING"
                "BINARY"
                "DECIMAL"
                "INTERVAL"
                "ARRAY"
                "STRUCT"
                "MAP"
                "CHAR"
                "NULL"
                "USER_DEFINED_TYPE"
            ];

            testCase.verifyStatementExecutionEnum(values, expectedValues, ...
                'databricks.datastructures.statementexecution.ColumnInfoType');
        end

        function testColumnInfoTypeFromJSON(testCase)
            values = [
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
                databricks.datastructures.statementexecution.ColumnInfoType.INTERVAL
                databricks.datastructures.statementexecution.ColumnInfoType.ARRAY
                databricks.datastructures.statementexecution.ColumnInfoType.STRUCT
                databricks.datastructures.statementexecution.ColumnInfoType.MAP
                databricks.datastructures.statementexecution.ColumnInfoType.CHAR
                databricks.datastructures.statementexecution.ColumnInfoType.NULL
                databricks.datastructures.statementexecution.ColumnInfoType.USER_DEFINED_TYPE
            ];
            expectedValues = [
                "BOOLEAN"
                "BYTE"
                "SHORT"
                "INT"
                "LONG"
                "FLOAT"
                "DOUBLE"
                "DATE"
                "TIMESTAMP"
                "STRING"
                "BINARY"
                "DECIMAL"
                "INTERVAL"
                "ARRAY"
                "STRUCT"
                "MAP"
                "CHAR"
                "NULL"
                "USER_DEFINED_TYPE"
            ];

            for idx = 1:numel(expectedValues)
                columnInfoType = databricks.datastructures.statementexecution.ColumnInfoType.BOOLEAN.fromJSON(expectedValues(idx));

                testCase.verifyEqual(columnInfoType, values(idx));
                testCase.verifyEqual(string(columnInfoType), expectedValues(idx));
            end
        end

        function testExecuteStatementRequestParameterPayload(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT :my_name AS my_name, CAST(:my_date AS DATE) AS my_date, :nothing AS nothing";
            request.warehouseId = "abcdef0123456789";
            request.parameters(1) = databricks.datastructures.statementexecution.Parameter( ...
                name="my_name", value="the name");
            request.parameters(2) = databricks.datastructures.statementexecution.Parameter( ...
                name="my_date", value="2020-01-01", type="DATE");
            request.parameters(3) = databricks.datastructures.statementexecution.Parameter( ...
                name="nothing");

            payload = jsondecode(request.getPayload);

            testCase.verifyEqual(payload.statement, char(request.statement));
            testCase.verifyEqual(payload.warehouse_id, char(request.warehouseId));
            testCase.verifyTrue(isfield(payload, "parameters"));
            testCase.verifyEqual(numel(payload.parameters), 3);

            testCase.verifyEqual(string(payload.parameters{1}.name), "my_name");
            testCase.verifyEqual(string(payload.parameters{1}.value), "the name");
            testCase.verifyFalse(isfield(payload.parameters{1}, "type"));

            testCase.verifyEqual(string(payload.parameters{2}.name), "my_date");
            testCase.verifyEqual(string(payload.parameters{2}.value), "2020-01-01");
            testCase.verifyEqual(string(payload.parameters{2}.type), "DATE");

            testCase.verifyEqual(string(payload.parameters{3}.name), "nothing");
            testCase.verifyFalse(isfield(payload.parameters{3}, "value"));
            testCase.verifyFalse(isfield(payload.parameters{3}, "type"));
        end

        function testExecuteStatementRequestQueryTagPayload(testCase)
            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT 1";
            request.warehouseId = "abcdef0123456789";
            request.queryTags(1) = databricks.datastructures.statementexecution.QueryTag( ...
                key="team", value="eng");
            request.queryTags(2) = databricks.datastructures.statementexecution.QueryTag( ...
                key="purpose");

            payload = jsondecode(request.getPayload);

            testCase.verifyEqual(payload.statement, char(request.statement));
            testCase.verifyEqual(payload.warehouse_id, char(request.warehouseId));
            testCase.verifyTrue(isfield(payload, "query_tags"));
            testCase.verifyEqual(numel(payload.query_tags), 2);

            testCase.verifyEqual(string(payload.query_tags{1}.key), "team");
            testCase.verifyEqual(string(payload.query_tags{1}.value), "eng");

            testCase.verifyEqual(string(payload.query_tags{2}.key), "purpose");
            testCase.verifyFalse(isfield(payload.query_tags{2}, "value"));
        end

        function testExecuteShowTablesInNYCTaxiSamples(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SHOW TABLES IN samples.nyctaxi";
            request.warehouseId = testCase.WarehouseId;
            request.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            request.disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
            request.waitTimeout = "30s";
            request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;

            statementExecution = databricks.StatementExecution;
            [result, errorResponse] = statementExecution.execute(request);

            testCase.verifyEmpty(errorResponse);
            testCase.assertEqual(result.status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(result.result.dataArray);

            resultValues = string([result.result.dataArray{:}]);
            testCase.verifyTrue(any(resultValues == "trips"), ...
                "Expected samples.nyctaxi to contain the trips table.");
        end

        function testExecuteStatementWithNamedParameters(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT id FROM range(10) WHERE id = :my_id";
            request.warehouseId = testCase.WarehouseId;
            request.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            request.disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
            request.waitTimeout = "30s";
            request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;
            request.parameters = databricks.datastructures.statementexecution.Parameter( ...
                name="my_id", value="2", type="BIGINT");

            statementExecution = databricks.StatementExecution;
            [result, errorResponse] = statementExecution.execute(request);

            testCase.verifyEmpty(errorResponse);
            testCase.assertEqual(result.status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(string(result.result.dataArray{1}{1}), "2");
        end

        function testExecuteStatementWithQueryTags(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT 1 AS tagged_value";
            request.warehouseId = testCase.WarehouseId;
            request.format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
            request.disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
            request.waitTimeout = "30s";
            request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;
            request.queryTags(1) = databricks.datastructures.statementexecution.QueryTag( ...
                key="client", value="matlab");
            request.queryTags(2) = databricks.datastructures.statementexecution.QueryTag( ...
                key="test_case", value="statement_execution_query_tags");

            statementExecution = databricks.StatementExecution;
            [result, errorResponse] = statementExecution.execute(request);

            testCase.verifyEmpty(errorResponse);
            testCase.assertEqual(result.status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(string(result.result.dataArray{1}{1}), "1");
        end

        function testRunStatementReturnsTable(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statementExecution = databricks.StatementExecution;
            [resultTable, status] = statementExecution.runStatement( ...
                "SELECT trip_distance FROM samples.nyctaxi.trips LIMIT 3", ...
                testCase.WarehouseId, verbose=false);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(height(resultTable), 3);
            testCase.verifyEqual(string(resultTable.Properties.VariableNames), "trip_distance");
        end

        function testRunStatementUsesWarehouseIdEnvironmentVariable(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            previousWarehouseId = getenv("DATABRICKS_SQL_WAREHOUSE_ID");
            cleanup = onCleanup(@() setenv("DATABRICKS_SQL_WAREHOUSE_ID", previousWarehouseId));
            setenv("DATABRICKS_SQL_WAREHOUSE_ID", testCase.WarehouseId);

            statementExecution = databricks.StatementExecution;
            [resultTable, status] = statementExecution.runStatement( ...
                "SELECT CAST(42 AS INT) AS int_col", verbose=false);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(resultTable.int_col, int32(42));

            clear cleanup
        end

        function testRunStatementCanDisableJSONSchemaTypes(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statementExecution = databricks.StatementExecution;
            [resultTable, status] = statementExecution.runStatement( ...
                "SELECT CAST('001' AS STRING) AS text_id, CAST(42 AS INT) AS int_col", ...
                testCase.WarehouseId, applySchemaTypes=false, verbose=false);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(height(resultTable), 1);
            testCase.verifyEqual(width(resultTable), 1);
            testCase.verifyEqual(string(resultTable.Properties.VariableNames), "Result");
            testCase.verifyClass(resultTable.Result, "string");
            testCase.verifyTrue(contains(resultTable.Result, "001"));
            testCase.verifyTrue(contains(resultTable.Result, "42"));
            testCase.verifyTrue(startsWith(resultTable.Result, "["));
            testCase.verifyEqual(resultTable.Properties.CustomProperties.ResultFormat, "JSON_ARRAY");
        end

        function testRunStatementAcceptsExplicitDispositionAndFormat(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statementExecution = databricks.StatementExecution;
            [resultTable, status] = statementExecution.runStatement( ...
                "SELECT CAST('001' AS STRING) AS text_id, CAST(42 AS INT) AS int_col", ...
                testCase.WarehouseId, ...
                disposition=databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS, ...
                format=databricks.datastructures.statementexecution.Format.CSV, ...
                timeout=120, verbose=false);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(height(resultTable), 1);
            testCase.verifyEqual(resultTable.text_id, "001");
            testCase.verifyClass(resultTable.int_col, "int32");
            testCase.verifyEqual(resultTable.Properties.CustomProperties.ResultFormat, "CSV");
        end

        function testRunStatementAcceptsParametersAndQueryTags(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            parameters = databricks.datastructures.statementexecution.Parameter( ...
                name="my_id", value="7", type="INT");
            queryTags(1) = databricks.datastructures.statementexecution.QueryTag( ...
                key="client", value="matlab");
            queryTags(2) = databricks.datastructures.statementexecution.QueryTag( ...
                key="test_case", value="run_statement_parameters_query_tags");

            statementExecution = databricks.StatementExecution;
            [resultTable, status] = statementExecution.runStatement( ...
                "SELECT CAST(:my_id AS INT) AS int_col", ...
                testCase.WarehouseId, ...
                parameters=parameters, ...
                queryTags=queryTags, ...
                verbose=false);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(resultTable.int_col, int32(7));
        end

        function testRunStatementDownloadsMultipleChunks(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            statementExecution = databricks.StatementExecution;
            statement = "SELECT * FROM samples.tpcds_sf1000.customer LIMIT 100000";
            [resultTable, status, statementId] = statementExecution.runStatement( ...
                statement, testCase.WarehouseId, timeout=300, debug=true);

            testCase.verifyEqual(status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyNotEmpty(statementId);
            testCase.verifyEqual(height(resultTable), 100000);
            testCase.verifyGreaterThan( ...
                resultTable.Properties.CustomProperties.TotalChunkCount, int64(1));
            testCase.verifyEqual( ...
                resultTable.Properties.CustomProperties.TotalRowCount, int64(100000));
        end

        function testGetStatementWithInvalidStatementIdReturnsErrorResponse(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            statementExecution = databricks.StatementExecution;
            invalidStatementId = "00000000-0000-0000-0000-000000000000";

            [result, errorResponse] = statementExecution.getStatement(invalidStatementId);

            testCase.verifyEmpty(result);
            testCase.verifyClass(errorResponse, "databricks.datastructures.ErrorResponse");
            testCase.verifyNotEmpty(errorResponse.errorCode);
            testCase.verifyNotEmpty(errorResponse.message);
        end

        function testExecuteExternalLinksCSVDownloadsNYCTaxiSample(testCase)
            if ~isempty(getenv("GITLAB_CI")) && ~strcmpi(getenv("DATABRICKS_VENDOR"), "azure")
                stack = dbstack;
                fprintf("Skipping test on non Azure platform: %s.\n", stack(2).name);
                return;
            end

            testCase.assumeNotEmpty(testCase.WarehouseId, ...
                "No SQL warehouse ID available from DATABRICKS_HTTP_PATH or databricks.SQLWarehouse.list.");

            request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
            request.statement = "SELECT * FROM samples.nyctaxi.trips LIMIT 10";
            request.warehouseId = testCase.WarehouseId;
            request.format = databricks.datastructures.statementexecution.Format.CSV;
            request.disposition = databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS;
            request.waitTimeout = "30s";
            request.onWaitTimeout = databricks.datastructures.statementexecution.TimeoutAction.CANCEL;

            statementExecution = databricks.StatementExecution;
            [result, errorResponse] = statementExecution.execute(request);

            testCase.verifyEmpty(errorResponse);
            testCase.assertEqual(result.status.state, ...
                databricks.datastructures.statementexecution.State.SUCCEEDED);
            testCase.verifyEqual(result.manifest.format, ...
                databricks.datastructures.statementexecution.Format.CSV);
            testCase.verifyNotEmpty(result.result.externalLinks);

            externalLink = result.result.externalLinks(1);
            testCase.verifyEqual(externalLink.rowCount, int64(10));
            testCase.verifyGreaterThan(externalLink.byteCount, int64(0));
            testCase.verifyNotEmpty(externalLink.externalLink);

            csvFile = tempname + ".csv";
            cleanup = onCleanup(@() testCase.deleteFileIfExists(csvFile));
            websave(csvFile, externalLink.externalLink);

            testCase.verifyTrue(isfile(csvFile));
            fileInfo = dir(csvFile);
            testCase.verifyGreaterThan(fileInfo.bytes, 0);

            csvText = string(fileread(csvFile));
            lines = splitlines(csvText);
            lines(strlength(lines) == 0) = [];

            testCase.verifyGreaterThanOrEqual(numel(lines), 10);
            csvData = readcell(csvFile, FileType="text");
            testCase.verifyGreaterThanOrEqual(size(csvData, 1), 10);
            testCase.verifyGreaterThanOrEqual(size(csvData, 2), 2);
            testCase.verifyTrue(any(cellfun(@(value) ~isempty(value), csvData), "all"), ...
                "Expected the downloaded CSV to contain nonempty data.");

            clear cleanup
        end
    end

    methods (Access = private)
        function warehouseId = getStatementExecutionWarehouseId(testCase)
            warehouseId = string.empty;

            warehouseId = string(getenv("DATABRICKS_SQL_WAREHOUSE_ID"));
            if strlength(warehouseId) > 0
                return
            end

            % TODO:
            % Hard coded value supporting testing on Azure only pending overhaul
            % of broader SQL based testing to adopt DATABRICKS_SQL_WAREHOUSE_ID
            % and related CI/CD updates.

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

        function verifyStatementExecutionEnum(testCase, values, expectedValues, className)
            testCase.verifyClass(values, className);
            testCase.verifyEqual(string(values), expectedValues);

            for idx = 1:numel(values)
                testCase.verifyEqual(values(idx), values(idx));

                otherIndices = setdiff(1:numel(values), idx);
                for otherIdx = otherIndices
                    testCase.verifyNotEqual(values(idx), values(otherIdx));
                end
            end
        end

        function deleteFileIfExists(~, fileName)
            if isfile(fileName)
                delete(fileName);
            end
        end
    end
end
