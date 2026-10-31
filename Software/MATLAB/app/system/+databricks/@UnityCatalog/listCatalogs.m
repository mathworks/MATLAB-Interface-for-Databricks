function result = listCatalogs(obj)
    % LISTCATALOGS gets list of catalogs.
    %
    % Example:
    %
    %   result = uc.listCatalogs();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of catalogs
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.CatalogInfoList

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'catalogs');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.CatalogInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end