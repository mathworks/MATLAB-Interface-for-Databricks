function result = destroy(obj, destroyRequest)
    % DESTROY Deletes an execution context
    %
    % Example:
    %
    %   result = ce.destroy(destroyRequest);
    %
    % % Required Inputs:
    %   CreateRequest
    %       Description:
    %           Request object to create a context
    %       Type: 
    %           databricks.datastructures.commandexecution.CreateRequest
    %       Required Properties in the data structure which must be set:
    %           clusterId
    %           contextId
    %
    % Outputs:
    %   result
    %       Description:
    %           True on success
    %       Type:
    %           logical or databricks.datastructures.commandexecution.ErrorResponse
    %
    % Example:
    %   commandExecution = databricks.CommandExecution;
    %   destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    %   destroyRequest.clusterId = clusterId;
    %   destroyRequest.contextId = contextId;
    %   destroyResponse = commandExecution.destroy(destroyRequest);
    
    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        destroyRequest (1,1) databricks.datastructures.commandexecution.DestroyRequest
    end

    % Get URI
    URI = obj.getURI('contexts', 'destroy');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "clusterId",...
        "contextId"
    ]; 

    optionalProperties = [
    ];

    request.Body(1).Payload = destroyRequest.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end