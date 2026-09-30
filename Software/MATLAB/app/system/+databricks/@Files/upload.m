function [result, errorResponse] = upload(obj, source, destination, options)
    % UPLOAD Uploads a file to /Volumes
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % The optional named `overwrite` argument indicates if the destination file should be overwritten
    % if it exists. The default is `true`.
    %
    % Example:
    %   f = databricks.Files;
    %    result = f.upload("hello-world.txt", "/Volumes/main/default/myvolume/myDir/hello-world.txt")
    %    result =
    %      logical
    %       1
    %
    % File of 5 GiB or larger are uploaded on a 'best effort' basis using an API
    % that is not publicly supported by Databricks.
    %
    % See also: https://docs.databricks.com/api/workspace/files/upload
    
    % Copyright 2024 The MathWorks, Inc.
    
    % The file contents should be sent as the request body as raw bytes
    % (an octet stream); do not encode or otherwise modify the bytes before
    % sending. The contents of the resulting file will be exactly the bytes
    % sent in the request body.
    
    arguments (Input)
        obj databricks.Files
        source string {mustBeFile}
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
    end
    arguments (Output)
        result (1,1) logical
        errorResponse
    end

    if ~isfile(source)
        error("DATABRICKS:Files:upload", "File not found: %s", source);
    end

    stats = dir(source);
    if stats.bytes >= 5*2^30
        fprintf("File: %s is 5GiB or larger.", source);
        fprintf("As a result it is being uploaded on a 'best effort' basis using an API\n");
        fprintf("that is not publicly supported by Databricks.\n");
        [result, errorResponse] = bigUpload(obj, source, destination, overwrite=options.overwrite);
        return;
    end

    [fileID, errmsg] = fopen(source,'r');
    if fileID == -1
         error("DATABRICKS:Files:upload", "Could not open file: %s\nMessage: %s", source, errmsg);
    end
    data = fread(fileID,'*uint8');
    closeAfter = onCleanup(@() fclose(fileID));

    % Get URI
    URI = obj.getURI('fs', 'files');
    
    pathFields = split(destination, "/");
    for n = 1:numel(pathFields)
        if strlength(pathFields(n)) > 0
            URI.Path(end+1) = pathFields(n);
        end
    end

    URI.Query(end+1) =  matlab.net.QueryParameter("overwrite", string(options.overwrite)); 
 
    % Start a PUT request
    request = obj.getRequestMessage('PUT');

    request.Body(1).Payload = data;

    % Perform the actual call
    if numel(data) == 0
        warning('off', 'MATLAB:http:BodyExpectedFor');
    end
    [resp] = request.send(URI, obj.HTTPOptions);
    if numel(data) == 0
        warning('on', 'MATLAB:http:BodyExpectedFor');
    end

    if resp.StatusCode == matlab.net.http.StatusCode.NoContent
        result = true;
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
    end
end