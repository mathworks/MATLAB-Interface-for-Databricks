function result = listFiles(obj, url, optionals)
    % LISTFILES list files in an external URL.
    %
    % Example:
    %
    %   result = uc.listFiles(url);
    %   result = uc.listFiles(url,'max_results',10);
    %
    % Required Inputs:
    %   url  
    %       Description:
    %           URL of the external location. Note: not the name of an
    %           external location in Unity Catalog but the actual URL of
    %           where the data exists externally. If a corresponding
    %           external location exists in the catalog, its credentials
    %           are used. Alternatively, refer to other storage credentials
    %           in the catalog through credential_name Name-Value pair.
    %       Type:
    %           string
    %
    % Optional Inputs Provided as Name-Value Pairs:
    %   'credential_name'
    %       Description:
    %          Name of Storage Credential to use for accessing the URL.
    %       Type:
    %           string
    %   'max_results'
    %       Description:
    %           Limit on number of results to return
    %       Type:
    %           int32
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of files
    %       Type:
    %           databricks.datastructures.unitycatalog.ListFilesResp
    %
    % Throws an error if the specified URL cannot be accessed.
    %
    % See Also: databricks.datastructures.unitycatalog.ListFilesResp

    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        url string {mustBeTextScalar}
        optionals.credential_name string
        optionals.max_results int32
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'files');
    URI.Query(end+1) = matlab.net.QueryParameter("url",url);
    if isfield(optionals,"credential_name")
        URI.Query(end+1) = matlab.net.QueryParameter("credential_name",optionals.credential_name);
    end
    if isfield(optionals,"max_results")
        URI.Query(end+1) = matlab.net.QueryParameter("max_results",optionals.max_results);
    end
    
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ListFilesResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end