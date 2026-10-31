function [result, errorResponse] = cancelExecution(obj, statementId)
    % CANCELEXECUTION Cancel a running SQL statement
    %
    % Requests cancellation of a SQL statement that is currently executing.
    % Cancellation is asynchronous; callers should poll the statement status
    % after this method returns to confirm the terminal state.
    %
    % Example:
    %
    %   statementExecution = databricks.StatementExecution;
    %   [result, errorResponse] = statementExecution.cancelExecution(statementId);
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
    %           True when Databricks accepts the cancellation request.
    %       Type:
    %           logical
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
        result logical
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("sql", "statements/" + statementId + "/cancel");

    request = obj.getRequestMessage("POST");
    request.Body = matlab.net.http.MessageBody;
 
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
