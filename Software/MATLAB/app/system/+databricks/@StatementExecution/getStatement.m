function [result, errorResponse] = getStatement(obj, statementId)
    % GETSTATEMENT Get statement status and first result chunk
    %
    % Polls a SQL statement for its current status. When the statement has
    % succeeded, the response can include the result manifest and first
    % result chunk. Terminal statement states can still return a successful
    % HTTP response with the terminal state set in the status field.
    %
    % Example:
    %
    %   statementExecution = databricks.StatementExecution;
    %   [result, errorResponse] = statementExecution.getStatement(statementId);
    %
    % Required Inputs:
    %   statementId
    %       Description:
    %           Statement ID returned by a previous statement execution call.
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           Statement response containing statement ID, status, manifest,
    %           and result data when available.
    %       Type:
    %           databricks.datastructures.statementexecution.StatementResponse
    %
    %   errorResponse
    %       Description:
    %           Empty on success, otherwise the Databricks error response.
    %       Type:
    %           databricks.datastructures.ErrorResponse

    % Copyright 2026, The MathWorks, Inc.

    arguments (Input)
        obj databricks.StatementExecution
        statementId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.statementexecution.StatementResponse
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("sql", "statements/" + statementId);

    request = obj.getRequestMessage("GET");

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.statementexecution.StatementResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.statementexecution.StatementResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
