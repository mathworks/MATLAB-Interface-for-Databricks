function [result, errorResponse] = getResultChunkN(obj, statementId, chunkIndex)
    % GETRESULTCHUNKN Get a statement result chunk by index
    %
    % Fetches a result chunk for a SQL statement after statement execution
    % has succeeded. The first chunk is usually returned by the statement
    % status call. Subsequent chunks can be fetched with this method using
    % the nextChunkIndex value returned in the previous result data.
    %
    % Example:
    %
    %   statementExecution = databricks.StatementExecution;
    %   [result, errorResponse] = statementExecution.getResultChunkN( ...
    %       statementId, int32(1));
    %
    % Required Inputs:
    %   statementId
    %       Description:
    %           Statement ID returned by a previous statement execution call.
    %       Type:
    %           string
    %
    %   chunkIndex
    %       Description:
    %           Zero-based index of the result chunk to fetch.
    %       Type:
    %           int32
    %
    % Outputs:
    %   result
    %       Description:
    %           Result data for the requested chunk.
    %       Type:
    %           databricks.datastructures.statementexecution.ResultData
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
        chunkIndex (1,1) int32 {mustBeNonnegative}
    end
    arguments (Output)
        result databricks.datastructures.statementexecution.ResultData
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("sql", "statements/" + statementId + ...
        "/result/chunks/" + string(chunkIndex));

    request = obj.getRequestMessage("GET");

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.statementexecution.ResultData().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.statementexecution.ResultData.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
