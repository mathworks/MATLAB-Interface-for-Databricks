function result = list(obj, directoryPath, options)
    % LIST List files, pages through files to return a complete list
    % An optional pageSize int64 argument can be provided that sets the page size
    % used the default value is 1000.
    % On success a databricks.datastructures.files.ListResponse is returned
    % otherwise a databricks.datastructures.files.ErrorResponse is returned.
    % To return a page at a time use databricks.Files.listPaginated()
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   result = f.list('/Volumes/main/default/myvolume/myDir')
    %     ListResponse with properties:
    %       contents: [1×5 databricks.datastructures.files.DirectoryEntry]
    %
    % This method is not recommended for directories with very large file counts
    % as runtime may be excessive, other approaches should be considered.
    %
    % See also: https://docs.databricks.com/api/workspace/files/listdirectorycontents
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        directoryPath string {mustBeTextScalar, mustBeNonzeroLengthText}
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
    
    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        paginatedResult = databricks.datastructures.files.ListResponsePaginated().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
        %result.throw();
        return;
    end

    contentsAll = paginatedResult.contents;
    while strlength(paginatedResult.nextPageToken) > 0
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", paginatedResult.nextPageToken);
        request = obj.getRequestMessage('GET');
        resp = request.send(URI, obj.HTTPOptions);
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            paginatedResult = databricks.datastructures.files.ListResponsePaginated().fromJSON(resp.Body.Data);
        else
            result = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
            %result.throw();
            return;
        end
        contentsAll = [contentsAll, paginatedResult.contents]; %#ok<AGROW>
    end
    
    % Overwrite the last contents with the concatenated array from previous calls
    result = databricks.datastructures.files.ListResponse();
    result.contents = contentsAll;
end
