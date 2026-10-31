function result = listSchemas(obj,catalog_name)
    % LISTSCHEMAS lists schemas in a given catalog.
    %
    % Example:
    %
    %   result = uc.listSchemas(catalog_name);
    %
    % Required Inputs:
    %   catalog_name  
    %       Description:
    %           Catalog name
    %       Type:
    %           string
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of schemas
    %       Type:
    %           databricks.datastructures.unitycatalog.SchemaInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.SchemaInfoList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        catalog_name string = string.empty
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'schemas');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    if ~isempty(catalog_name)
        URI.Query(end+1) = matlab.net.QueryParameter("catalog_name",catalog_name);
    end

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.SchemaInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end