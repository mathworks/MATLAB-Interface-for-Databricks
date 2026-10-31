function result = getCatalog(obj, name)
    % GETCATALOG gets catalog information.
    %
    % Example:
    %
    %   result = uc.getCatalog(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the catalog
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the catalog
    %       Type:
    %           databricks.datastructures.unitycatalog.CatalogInfo
    %
    % Throws an error if the specified catalog cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.CatalogInfo

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'catalogs');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.CatalogInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end