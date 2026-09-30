function result = create(obj, createRequest)
    % CREATE Creates an execution context for running cluster commands
    %
    % Example:
    %   commandExecution = databricks.CommandExecution();
    %   createRequest = databricks.datastructures.commandexecution.CreateRequest;
    %   createRequest.clusterId = "1117-171925-4ipnoi3i";
    %   createRequest.language = databricks.datastructures.commandexecution.Language.python;
    %   createResponse = commandExecution.create(createRequest);
    %   if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
    %       error("Context creation failed:\n  %s", createResponse.error);
    %   else
    %       contextId = createResponse.id;
    %   end
    %
    % Required Inputs:
    %   createRequest
    %       Description:
    %           Request object to create a context
    %       Type: 
    %           databricks.datastructures.commandexecution.CreateRequest
    %       Required Properties in the data structure which must be set:
    %           clusterId
    %           language
    %
    % Outputs:
    %   result
    %       Description:
    %           create ID
    %       Type:
    %           databricks.datastructures.commandexecution.CreateResponse
    %
    % See Also: databricks.datastructures.commandexecution.CreateResponse, databricks.datastructures.commandexecution.CreateRequest

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.CommandExecution
        createRequest (1,1) databricks.datastructures.commandexecution.CreateRequest
    end

    % Get URI
    URI = obj.getURI('contexts', 'create');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "clusterId",...
        "language"
    ];

    optionalProperties = [
    ];

    request.Body(1).Payload = createRequest.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.commandexecution.CreateResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.commandexecution.ErrorResponse().fromJSON(resp.Body.Data);
        if isprop(result, 'error') && isstring(result.error) && all(strlength(result.error) == 0) ...
            && isprop(resp, 'Body') && isprop(resp.Body, 'Data')
            result.error = "matlab.net.http.ResponseMessage error: " + string(resp.Body.Data);
        end
        result.throw;
    end
end