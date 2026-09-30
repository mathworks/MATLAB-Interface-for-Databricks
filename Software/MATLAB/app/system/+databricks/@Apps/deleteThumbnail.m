function [result, errorResponse] = deleteThumbnail(obj, appName)
    % DELETETHUMBNAIL Method to delete an app thumbnail
    %
    % Example:
    %   apps = databricks.Apps;
    %   [result, errorResponse] = deleteThumbnail(apps, "myAppName");
    %
    % See also: https://docs.databricks.com/api/apps/v1/delete-app-thumbnail

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.DeleteThumbnailResponse
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("apps", appName);
    URI.Path(end+1) = "thumbnail";

    request = obj.getRequestMessage('DELETE');

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.DeleteThumbnailResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.DeleteThumbnailResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
