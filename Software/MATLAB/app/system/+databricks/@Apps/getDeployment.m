function [result, errorResponse] = getDeployment(obj, appName, deploymentId)
    % GETDEPLOYMENT Method to get an app deployment

    %  Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
        deploymentId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.CreateDeploymentResponse
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("apps", appName);
    URI.Path(end+1) = "deployments";
    URI.Path(end+1) = deploymentId;

    request = obj.getRequestMessage('GET');
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.CreateDeploymentResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.CreateDeploymentResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
