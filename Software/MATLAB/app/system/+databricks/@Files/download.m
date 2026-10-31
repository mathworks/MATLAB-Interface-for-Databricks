function [result, errorResponse, localPath] = download(obj, source, options)
    % DOWNLOAD Downloads a file of up to 5 GiB
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % The optional logical overwrite flag can be used to prevent
    % overwriting a destination file, the default is true i.e. do overwrite
    % the destination.
    %
    % If an optional destination path named argument is provided it is used as the path
    % to download to otherwise the name of the file to be downloaded and the current
    % directory are used.
    %
    % The required source argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   result = f.download("/Volumes/main/default/myvolume/myDir/hello-world.txt", destination="hw-downloaded.txt")
    %   result =
    %     logical
    %      1
    %
    % See also: https://docs.databricks.com/api/workspace/files/download
    
    % TODO handoff to websave with auth as a option

    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        source string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
    end

    % Get URI
    URI = obj.getURI('fs', 'files');

    pathFields = split(source, "/");
    for n = 1:numel(pathFields)
        if strlength(pathFields(n)) > 0
            URI.Path(end+1) = pathFields(n);
        end
    end

    if isfield(options, 'destination')
        destination = options.destination;
    else
        fileFields = split(source, '/');
        destination = fullfile(pwd, fileFields(end));
    end

    if isfile(destination) && ~options.overwrite
        error("DATABRICKS:Files:download", "Existing File found: %s, overwrite not enabled", destination);
    end

    if isfolder(destination) && ~options.overwrite
        error("DATABRICKS:FILES:DIREXISTS", "Existing directory found: %s, overwrite not enabled", destination);
    end

    [fileID, errmsg] = fopen(destination,'W');
    if fileID == -1
        error("DATABRICKS:Files:download", "Could not open file: %s\nMessage: %s", destination, errmsg);
    end
    closeAfter = onCleanup(@() fclose(fileID));

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        fwrite(fileID, resp.Body.Data);
        localPath = destination;
        result = true;
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        localPath = string.empty;
        result = false;
        errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
    end
end