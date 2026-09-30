function result = listTables(obj,catalog_name,schema_name)
    % LISTTABLES lists tables in a given catalog and schema.
    %
    % Example:
    %
    %   result = uc.listTables(catalog_name,schema_name);
    %
    % Required Inputs:
    %   catalog_name  
    %       Description:
    %           Catalog name
    %       Type:
    %           string
    %   schema_name  
    %       Description:
    %           Schema name
    %       Type:
    %           string
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of tables
    %       Type:
    %           databricks.datastructures.unitycatalog.TableInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.TableInfoList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        catalog_name string {mustBeTextScalar}
        schema_name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'tables');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    URI.Query(end+1) = matlab.net.QueryParameter("catalog_name",catalog_name);
    URI.Query(end+1) = matlab.net.QueryParameter("schema_name",schema_name);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.TableInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end