function result = execute(obj, executeResult)
    % execute Execute a cluster command in the given execution context, using the provided language
    % If successful, it returns an ID for tracking the status of the command's execution.
    %
    % Example:
    %   executeRequest = databricks.datastructures.commandexecution.ExecuteRequest;
    %   executeRequest.clusterId = clusterId;
    %   executeRequest.contextId = contextId;
    %   executeRequest.command = pythonCommand;
    %   executeRequest.language = language;
    %   executeResponse = commandExecution.execute(executeRequest);
    %   if isa(executeResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
    %       error("databricks:executePythonCommand", "Execute failed:\n  %s", executeResponse.error);
    %   else
    %       commandId = executeResponse.id;
    %   end
    %
    % Required Inputs:
    %    Properties:
    %       Description: 
    %           Request object to execute a command
    %       Type: 
    %           databricks.datastructures.commandexecution.ExecuteResult
    %       Required Properties in the data structure which must be set:
    %           clusterId
    %           contextId
    %           language
    %           command
    %
    % Outputs:
    %   result
    %       Description:
    %           databricks.datastructures.commandexecution.ExecuteResponse on success
    %           containing the id for tracking the status of the command's
    %           execution. as a string.
    %       Type:
    %           databricks.datastructures.commandexecution.ExecuteResponse on success
    %           databricks.datastructures.commandexecution.ErrorResponse on Error

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        executeResult (1,1) databricks.datastructures.commandexecution.ExecuteRequest
    end

    % Get URI
    URI = obj.getURI('commands', 'execute');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "clusterId",...
        "contextId",...
        "command",...
        "language"
    ]; 

    optionalProperties = [
    ];

    request.Body(1).Payload = executeResult.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.commandexecution.ExecuteResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end