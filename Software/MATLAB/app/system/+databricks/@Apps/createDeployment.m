function [result, errorResponse] = createDeployment(obj, appName, createDeploymentRequest)
    % CREATEDEPLOYMENT Method to create a new app deployment
    %
    % Example:
    %   a = databricks.Apps;
    %   cdr = databricks.datastructures.apps.CreateDeploymentRequest;
    %   cdr.sourceCodePath = "/Workspace/Users/mbrowne@mathworks.com/databricks_apps/dbx-hello-world_2026_05_01-11_53/nodejs-fastapi-hello-world-app"
    %   [result, errorResponse] = a.createDeployment("my-example-app", cdr)

    %  Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
        createDeploymentRequest (1,1) databricks.datastructures.apps.CreateDeploymentRequest
    end
    arguments (Output)
        result databricks.datastructures.apps.CreateDeploymentResponse
        errorResponse databricks.datastructures.ErrorResponse
    end
    
    URI = obj.getURI("apps", appName);
    URI.Path(end+1) = "deployments";

    request = obj.getRequestMessage('POST');
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = createDeploymentRequest.getPayload();

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.CreateDeploymentResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.CreateDeploymentResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
