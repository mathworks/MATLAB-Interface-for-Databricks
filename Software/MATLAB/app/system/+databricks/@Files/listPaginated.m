function result = listPaginated(obj, directoryPath, options)
    % listPaginated List a single 'page' of files potential returning a nextPageToken
    % An optional pageSize int64 argument can be provided that sets the page size
    % used the default value is 1000.
    %
    % An optional pageToken scalar text argument can be provided.
    % The token being the nextPageToken in the response of the previous request
    % to list the contents of this directory. Provide this token to retrieve the
    % next page of directory entries. When providing a pagetoken, all other
    % parameters provided to the request must match the previous request.
    % To list all of the entries in a directory, it is necessary to continue
    % requesting pages of entries until the response contains no nextPageToken.
    % The number of entries returned must not be used to determine
    % when the listing is complete.
    % To return all pages at one time also see: databricks.Files.list()
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    % 
    % On success a databricks.datastructures.files.ListResponse is returned
    % otherwise a databricks.datastructures.files.ErrorResponse is returned.
    %
    % Example:
    %   f = databricks.Files;
    %   result = f.list('/Volumes/main/default/myvolume/myDir')
    %     ListResponse with properties:
    %       contents: [1×5 databricks.datastructures.files.DirectoryEntry]
    %
    % See also: https://docs.databricks.com/api/workspace/files/listdirectorycontents
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        directoryPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int64 = 1000
    end

    % Get URI
    URI = obj.getURI('fs', 'directories');

    dirFields = split(directoryPath, "/");
    for n = 1:numel(dirFields)
        if strlength(dirFields(n)) > 0
            URI.Path(end+1) = dirFields(n);
        end
    end

    URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);

    if isfield(options, 'pageToken')
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", options.pageToken);
    end
    
    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.files.ListResponsePaginated().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
        %result.throw();
    end
end
