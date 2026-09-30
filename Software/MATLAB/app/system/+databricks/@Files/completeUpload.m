function [result, errorResponse] = completeUpload(obj, destination)
    % completeUpload Caution - Undocumented Databricks feature
    % The method is not supported may be removed without further notice 

    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj databricks.Files
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % POST /api/2.0/fs/files/<escaped-path>?action=complete-upload&upload_type=multipart&session_token=<token> Content-Type: application/json Body: {"parts": [{"part_number": 1, "etag": "..."}, {"part_number": 2, "etag": "..."}, ...]}

    URI = obj.getURI('fs', 'files');
    escapedPath = databricks.Files.escapePath(destination);
    parts = split(escapedPath, "/");
    for n = 1:numel(parts)
        if strlength(parts(n)) > 0
            URI.Path(end+1) = parts(n);
        end
    end
    URI.Query(end+1) = matlab.net.QueryParameter("action", "complete-upload");
    URI.Query(end+1) = matlab.net.QueryParameter("upload_type", "multipart");
    URI.Query(end+1) = matlab.net.QueryParameter("session_token", sessionToken);
    
    request = obj.getRequestMessage('PUT');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = jsondecode(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = struct.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
