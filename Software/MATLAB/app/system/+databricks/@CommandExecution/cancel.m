function result = cancel(obj, cancelRequest)
    % cancel Cancels a currently running command within an execution context
    % The command ID is obtained from a prior successful call to execute.
    %
    % Example:
    %
    %   cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
    %   cancelRequest.clusterId = clusterId;
    %   cancelRequest.contextId = contextId;
    %   cancelRequest.commandId = commandId;
    %   cancelResponse = commandExecution.cancel(cancelRequest);
    %
    % Required Inputs:
    %   cancelRequest
    %       Description:
    %           Request object to cancel a command
    %       Type: 
    %           databricks.datastructures.commandexecution.CancelRequest
    %       Required Properties in the data structure which must be set:
    %           contextId
    %           commandId
    %           clusterId
    %
    % Outputs:
    %   result  
    %       Description:
    %           True on success
    %       Type:
    %           logical or databricks.datastructures.commandexecution.ErrorResponse
    %

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        cancelRequest (1,1) databricks.datastructures.commandexecution.CancelRequest
    end

    % Get URI
    URI = obj.getURI('commands', 'cancel');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "clusterId",...
        "contextId",...
        "commandId"
    ]; 

    optionalProperties = [
    ];

    request.Body(1).Payload = cancelRequest.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end