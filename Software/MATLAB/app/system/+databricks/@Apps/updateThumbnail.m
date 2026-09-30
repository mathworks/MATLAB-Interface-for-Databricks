function [result, errorResponse] = updateThumbnail(obj, appName, thumbnailFile)
    % UPDATETHUMBNAIL Method to update an app thumbnail
    %
    % Images PNG or JPEG format. 250KB or less in size, The recommended size is:
    % 640 x 360 pixels.
    %
    %   Note the Databricks API does not currently return a thumbnail string as
    %   documented. However for this method a empty errorResponse can be
    %   used to indicate success.
    %
    % Example:
    %   apps = databricks.Apps;
    %   [result, errorResponse] = updateThumbnail(apps, "myAppName", "C:\temp\my_thumbnail_604x360.png");
    %
    % See also: https://docs.databricks.com/api/apps/v1/update-app-thumbnail

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
        thumbnailFile string {mustBeTextScalar, mustBeNonzeroLengthText, mustBeFile}
    end
    arguments (Output)
        result databricks.datastructures.apps.Thumbnail
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI("apps", appName);
    URI.Path(end+1) = "thumbnail";

    request = obj.getRequestMessage('PATCH');
    request.Body = matlab.net.http.MessageBody;

    if ~endsWith(thumbnailFile, ".png", "IgnoreCase", true) && ~endsWith(thumbnailFile, ".jpg", "IgnoreCase", true) && ~endsWith(thumbnailFile, ".jpeg", "IgnoreCase", true)
        error("DATABRICKS:APPS:UPDATETHUMBNAIL:BADFILETYPE", "Expected a png or jpg/jpeg, file: %s", thumbnailFile);
    end

    fileInfo = dir(thumbnailFile);
    if fileInfo.bytes > 250 * 1024
        error("DATABRICKS:APPS:UPDATETHUMBNAIL:FILETOOLARGE", ...
            "Thumbnail file must be 250KB or smaller, file: %s (%d bytes)", ...
            thumbnailFile, fileInfo.bytes);
    end

    updateThumbnailRequest = databricks.datastructures.apps.UpdateThumbnailRequest();
    fid = fopen(thumbnailFile, "rb");
    if fid == -1
        error("DATABRICKS:APPS:UPDATETHUMBNAIL:READFAILED", "Failed to open file: %s", thumbnailFile);
    end
    cleanupObj = onCleanup(@() fclose(fid));
    bytes = fread(fid, Inf, "*uint8")';
    thumbnail = databricks.datastructures.apps.Thumbnail();
    thumbnail.thumbnail = string(matlab.net.base64('encode', bytes));
    updateThumbnailRequest.appThumbnail = thumbnail;
    request.Body.Payload = updateThumbnailRequest.getPayload();

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.Thumbnail().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.Thumbnail.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
