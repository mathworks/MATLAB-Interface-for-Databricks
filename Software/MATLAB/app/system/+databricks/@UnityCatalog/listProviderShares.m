function result = listProviderShares(obj, name)
    % LISTPROVIDERSHARES lists delta sharing shares for a given provider.
    %
    % Example:
    %
    %   result = uc.listProviderShares(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           Provider name
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           list of shares
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderShareList
    %
    % See Also: databricks.datastructures.unitycatalog.ProviderShareList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'providers');
    URI.Path(end+1) = name;
    URI.Path(end+1) = "shares";
    
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ProviderShareList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end