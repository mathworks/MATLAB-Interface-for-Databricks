function result = fileMetadata(obj, filePath)
    % FILEMETADATA Get the metadata of a file
    % On success a databricks.datastructures.files.FileMetadata object is
    % returned. On expected error a
    % databricks.datastructures.files.ErrorResponse is returned.
    % The contentLength property is the file size in bytes.
    %
    % The required filePath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   md = f.fileMetadata("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    %   md =
    %       FileMetadata with properties:
    %           contentType: "application/octet-stream"
    %         contentLength: 13
    %          lastModified: 08-Jan-2024 10:27:07
    %
    % See also: https://docs.databricks.com/api/workspace/files/getmetadata
    
    % The response HTTP headers contain the metadata. There is no response body.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        filePath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('fs', 'files');

    pathFields = split(filePath, "/");
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
        result = databricks.datastructures.files.FileMetadata;
        hA = false;
        hB = false;
        hC = false;
        for n = 1:numel(resp.Header)
            switch class(resp.Header(n))
                case 'matlab.net.http.field.ContentTypeField'
                    result.contentType = string(resp.Header(n).Value);
                    hA = true;
                case 'matlab.net.http.field.ContentLengthField'
                    result.contentLength = sscanf(resp.Header(n).Value, "%lu");
                    hB = true;
                case 'matlab.net.http.field.HTTPDateField'
                    if strcmp("last-modified", resp.Header(n).Name)
                        dtFields = split(string(resp.Header(n).Value), ' ');
                        dtOnly = join(dtFields(2:end-1), " ");
                        result.lastModified = datetime(dtOnly,'InputFormat',"dd MMM yyyy HH:mm:ss", 'TimeZone', dtFields(end));
                        hC = true;
                    end
            end
            if hA && hB && hC
                break;
            end
        end
        if isempty(result.contentLength)
            warning("DATABRICKS:fileMetadata", "File contentLength field not set");
        end
        if isempty(result.contentType) || strlength(result.contentType) == 0
            warning("DATABRICKS:fileMetadata", "File contentType field not set");
        end
        if isempty(result.lastModified)
            warning("DATABRICKS:fileMetadata", "File lastModified field not set");
        end
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