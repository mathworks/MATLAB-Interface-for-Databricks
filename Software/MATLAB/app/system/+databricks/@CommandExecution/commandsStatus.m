function result = commandsStatus(obj, clusterId, contextId, commandId)
    % commandStatus Gets the status of and, if available, the results from a currently executing command
    % The command ID is obtained from a prior successful call to execute.
    %
    % Example:
    %
    %   commandExecution = databricks.CommandExecution;
    %   commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
    %   commandsStatusResponse.status
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
    %   commandId
    %       Description:
    %           ID of command
    %       Type: 
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           databricks.datastructures.commandexecution.commandsStatusResponse on success
    %       Type:
    %           databricks.datastructures.commandexecution.commandsStatusResponse on success
    %           databricks.datastructures.commandexecution.ErrorResponse on Error

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        commandId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('commands', 'status');
    URI.Query(end+1) = matlab.net.QueryParameter("clusterId", clusterId);
    URI.Query(end+1) = matlab.net.QueryParameter("contextId", contextId);
    URI.Query(end+1) = matlab.net.QueryParameter("commandId", commandId);

    % Start a POST request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.commandexecution.CommandsStatusResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end