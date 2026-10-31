function [result, errorResponse] = rm(obj, filePath)
    % RM Deletes a file
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   result = f.rm("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    %   result =
    %     logical
    %      1
    %
    % See also: https://docs.databricks.com/api/workspace/files/delete

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
    
    % Start a DELETE request
    request = obj.getRequestMessage('DELETE');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.NoContent
        result = true;
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
        % errorResponse.throw;
    end
end