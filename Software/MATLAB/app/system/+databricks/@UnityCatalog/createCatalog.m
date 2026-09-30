function result = createCatalog(obj, cataloginfo)
    % CREATECATALOG creates a new catalog.
    %
    % Example:
    %
    %   result = uc.createCatalog(cataloginfo);
    %
    % Required Inputs:
    %   cataloginfo  
    %       Description:
    %           settings/configuration for the new catalog
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           ucproperties
    %           provider_name
    %           share_name
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created catalog
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfo
    %
    % See Also: databricks.datastructures.unitycatalog.CatalogInfo

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        cataloginfo databricks.datastructures.unitycatalog.CatalogInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'catalogs');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name"
    ]; %#ok<NBRAK2> 

    optionalProperties = [
        "comment", ...
        "ucproperties", ...
        "provider_name", ...
        "share_name"
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