function result = listVolumes(obj, catalog_name, schema_name, optionals)
    % LISTVOLUMES lists volumes for the current metastore under the parent catalog and schema.
    %
    % Example:
    %
    %   result = uc.listVolumes('main', 'default');
    %
    % Required Inputs:
    %   'catalog_name'
    %       Description:
    %           The identifier of the catalog
    %       Type:
    %           string
    %   'schema_name'
    %       Description:
    %           The identifier of the schema
    %       Type:
    %           string
    %
    % Optional Inputs Provided as Name-Value Pairs:
    %   'page_token'
    %       Description:
    %          Opaque token returned by a previous request. It must be
    %          included in the request to retrieve the next page of results
    %          (pagination).
    %       Type:
    %           string
    %   'max_results'
    %       Description:
    %           Limit on number of results to return
    %       Type:
    %           int32
    %   'include_browse'
    %       Description:
    %           Whether to include volumes in the response for which the principal
    %           can only access selective metadata for
    %       Type:
    %           logical
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of volumes
    %       Type:
    %           databricks.datastructures.unitycatalog.ListVolumesResp
    %
    % See Also: databricks.datastructures.unitycatalog.ListVolumesResp

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        catalog_name string {mustBeTextScalar}
        schema_name string {mustBeTextScalar}
        optionals.max_results (1,1) int32
        optionals.page_token string {mustBeTextScalar}
        optionals.include_browse (1,1) logical
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'volumes');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    URI.Query(end+1) = matlab.net.QueryParameter("catalog_name",catalog_name);
    URI.Query(end+1) = matlab.net.QueryParameter("schema_name",schema_name);
    if isfield(optionals,"max_results")
        URI.Query(end+1) = matlab.net.QueryParameter("max_results",optionals.max_results);
    end
    if isfield(optionals,"page_token")
        URI.Query(end+1) = matlab.net.QueryParameter("page_token",optionals.page_token);
    end
    if isfield(optionals,"include_browse")
        URI.Query(end+1) = matlab.net.QueryParameter("include_browse",optionals.include_browse);
    end

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ListVolumesResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end