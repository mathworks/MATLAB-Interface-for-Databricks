function result = contextsStatus(obj, clusterId, contextId)
    % STATUS Gets the contextsStatus for an execution context
    %
    % Example:
    %
    %   commandExecution = databricks.CommandExecution;
    %   contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
    %   contextsStatusResponse.status
    %
    % Required Inputs:
    %   clusterId
    %       Description:
    %           ID of cluster
    %       Type:
    %           string
    %   contextId
    %       Description:
    %           ID of context
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           databricks.datastructures.commandexecution.ContextsStatusResponse on success
    %       Type:
    %           databricks.datastructures.commandexecution.ContextsStatusResponse on success
    %           databricks.datastructures.commandexecution.ErrorResponse on Error

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('contexts', 'status');
    URI.Query(end+1) = matlab.net.QueryParameter("clusterId", clusterId);
    URI.Query(end+1) = matlab.net.QueryParameter("contextId", contextId);

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.commandexecution.ContextsStatusResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end