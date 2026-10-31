function result = updateCatalog(obj, name, cataloginfo)
    % UPDATECATALOG updates catalog settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateCatalog(name, cataloginfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of catalog
    %       Type:
    %           string
    %   cataloginfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           ucproperties
    %           owner
    %
    % Outputs:
    %   result
    %       Description:
    %           updated catalog settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfo
    %
    % See Also: databricks.datastructures.unitycatalog.CatalogInfo   
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        cataloginfo databricks.datastructures.unitycatalog.CatalogInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'catalogs');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [];

    optionalProperties = [
        "name", ...
        "comment", ...
        "ucproperties", ...
        "owner"
    ];

    request.Body(1).Payload = cataloginfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.CatalogInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end