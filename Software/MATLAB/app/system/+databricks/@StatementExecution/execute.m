function [result, errorResponse] = execute(obj, executeStatementRequest)
    % EXECUTE Execute a SQL statement
    %
    % Submits a SQL statement execution request to Databricks. The
    % executeStatementRequest input controls the SQL text, result format,
    % disposition, timeout behavior, catalog, schema, and other statement
    % execution options.
    %
    % Example:
    %
    %   statementExecution = databricks.StatementExecution;
    %   request = databricks.datastructures.statementexecution.ExecuteStatementRequest;
    %   request.statement = "SELECT 1";
    %   request.warehouseId = warehouseId;
    %
    %   [result, errorResponse] = statementExecution.execute(request);
    %
    % Required Inputs:
    %   executeStatementRequest
    %       Description:
    %           Statement execution request data structure.
    %       Type:
    %           databricks.datastructures.statementexecution.ExecuteStatementRequest
    %
    % Outputs:
    %   result
    %       Description:
    %           Statement execution response containing statement ID, status,
    %           manifest, and result data when available.
    %       Type:
    %           databricks.datastructures.statementexecution.StatementResponse
    %
    %   errorResponse
    %       Description:
    %           Empty on success, otherwise the Databricks error response.
    %       Type:
    %           databricks.datastructures.ErrorResponse
    %
    % See also: runStatement, getStatement, getResultChunkN

    % Copyright 2026, The MathWorks, Inc.
    
    arguments (Input)
        obj databricks.StatementExecution
        executeStatementRequest databricks.datastructures.statementexecution.ExecuteStatementRequest
    end
    arguments (Output)
        result databricks.datastructures.statementexecution.StatementResponse
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("sql", "statements");

    request = obj.getRequestMessage("POST");
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = executeStatementRequest.getPayload;

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.statementexecution.StatementResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.statementexecution.StatementResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
