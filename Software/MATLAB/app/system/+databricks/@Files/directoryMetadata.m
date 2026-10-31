function result = directoryMetadata(obj, directoryPath)
    % DIRECTORYMETADATA Gets the metadata of a directory
    % On success a databricks.datastructures.files.DirectoryMetadata object
    % is returned. On expected error a
    % databricks.datastructures.files.ErrorResponse is returned.
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   md = f.directoryMetadata("/Volumes/main/default/myvolume/myDir")
    %   md =
    %       DirectoryMetadata with properties:
    %         exists: 1
    %
    % See also: https://docs.databricks.com/api/workspace/files/getdirectorymetadata
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        directoryPath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('fs', 'directories');

    pathFields = split(directoryPath, "/");
    for n = 1:numel(pathFields)
        if strlength(pathFields(n)) > 0
            URI.Path(end+1) = pathFields(n);
        end
    end

    % Start a HEAD request
    request = obj.getRequestMessage('HEAD');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.files.DirectoryMetadata;
        result.exists = true;
    elseif resp.StatusCode == matlab.net.http.StatusCode.NotFound % 404
        result = databricks.datastructures.files.ErrorResponse();
        result.errorCode = "NOT_FOUND";
        result.message = "Operation was performed on a resource that does not exist.";
    elseif resp.StatusCode == matlab.net.http.StatusCode.BadRequest % 400
        result = databricks.datastructures.files.ErrorResponse();
        result.errorCode = "BAD_REQUEST";
        result.message = "Request is invalid.";
    elseif resp.StatusCode == matlab.net.http.StatusCode.Unauthorized % 401
        result = databricks.datastructures.files.ErrorResponse();
        result.errorCode = "UNAUTHORIZED";
        result.message = "The request does not have valid authentication credentials for the operation.";
    elseif resp.StatusCode == matlab.net.http.StatusCode.Forbidden % 403
        result = databricks.datastructures.files.ErrorResponse();
        result.errorCode = "PERMISSION_DENIED";
        result.message = "Caller does not have permission to execute the specified operation.";
    elseif resp.StatusCode == matlab.net.http.StatusCode.InternalServerError % 500
        result = databricks.datastructures.files.ErrorResponse();
        result.errorCode = "INTERNAL_SERVER_ERROR";
        result.message = "Internal error.";
    else
        error("DATABRICKS:fileMetadata", "Unexpected error: %s, %s", resp.StatusCode, resp.StatusLine);
    end
end