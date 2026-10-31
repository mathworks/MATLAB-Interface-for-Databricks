function [result, errorResponse] = stop(obj, appName)
    % STOP Method to Stop an app

    %  Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.StopAppResponse
        errorResponse databricks.datastructures.ErrorResponse
    end
    
    URI = obj.getURI("apps", appName);
    URI.Path(end+1) = "stop";

    request = obj.getRequestMessage('POST');

    warnState = warning('off', 'MATLAB:http:BodyExpectedFor');
    resp = request.send(URI, obj.HTTPOptions);
    warning(warnState)

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.StopAppResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.StopAppResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
