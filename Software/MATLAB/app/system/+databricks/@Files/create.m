function [result, errorResponse] = create(obj, directoryPath)
    % CREATE Creates an empty directory
    % If necessary, also creates any parent directories of the new, empty directory
    % (like the shell command mkdir -p). If called on an existing directory,
    % returns a success response; this method is idempotent (it will succeed if
    % the directory already exists).
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % Example:
    %   f = databricks.Files;
    %   result = f.create("/Volumes/main/default/myvolume/myDir")
    %   result =
    %     logical
    %      1
    %
    % See also: https://docs.databricks.com/api/workspace/files/createdirectory

    % Copyright 2024-2026 The MathWorks, Inc.

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
    
    % Start a PUT request
    request = obj.getRequestMessage('PUT');

    % The spec does not call for a body and rejects content
    % request.Body(1).Payload = "";

    % Perform the actual call
    warning('off', 'MATLAB:http:BodyExpectedFor');
    resp = request.send(URI, obj.HTTPOptions);
    warning('on', 'MATLAB:http:BodyExpectedFor');

    if resp.StatusCode == matlab.net.http.StatusCode.NoContent %204
        result = true;
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        result = false;
        if isprop(resp, "Body") && any(isprop(resp.Body, "Data")) && (isStringScalar(resp.Body.Data) || ischar(resp.Body.Data)) && strlength(resp.Body.Data) > 0
            errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
        else
            % Unexpected error treat as 500 as there is no body response
            s = struct;
            s.error_code = "INTERNAL_SERVER_ERROR";
            s.message = "No response.Body.Data";
            errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(jsonencode(s));
        end 
    end
end