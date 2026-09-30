function [result, errorResponse] = deleteApp(obj, appName)
    % DELETEAPP Method to delete an app

    %  Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.DeleteAppResponse
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("apps", appName);

    request = obj.getRequestMessage('DELETE');

    % TODO check if warning is produced for delete
    %warnState = warning('off', 'MATLAB:http:BodyExpectedFor');
    resp = request.send(URI, obj.HTTPOptions);
    %warning(warnState)

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.DeleteAppResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.DeleteAppResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
