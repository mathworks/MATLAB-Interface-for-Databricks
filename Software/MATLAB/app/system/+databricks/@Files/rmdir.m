function [result, errorResponse] = rmdir(obj, directoryPath)
    % RMDIR Deletes an empty directory
    % To delete a non-empty directory, first delete all of its contents.
    % This can be done by listing the directory contents and deleting each file
    % and subdirectory recursively.
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.File;
    %   result = f.rmdir("/Volumes/main/default/myvolume/myDeleteMeDir")
    %   result =
    %     logical
    %      1
    %
    % See also: https://docs.databricks.com/api/workspace/files/deletedirectory
    
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