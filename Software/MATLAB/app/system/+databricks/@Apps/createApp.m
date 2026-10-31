function [result, errorResponse] = createApp(obj, createAppRequest, options)
    % CREATEAPP Method to create a new app

    %  Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        createAppRequest (1,1) databricks.datastructures.apps.CreateAppRequest
        options.noCompute (1,1) logical = false
    end
    arguments (Output)
        result databricks.datastructures.apps.CreateAppResponse
        errorResponse databricks.datastructures.ErrorResponse
    end
    
    URI = obj.getURI('apps', '');
    
    URI.Query(end+1) = matlab.net.QueryParameter('no_compute', string(options.noCompute));

    request = obj.getRequestMessage('POST');
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = createAppRequest.getPayload();

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.CreateAppResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.CreateAppResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
