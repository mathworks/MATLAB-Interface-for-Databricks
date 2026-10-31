function result = getProvider(obj, name)
    % GETPROVIDER gets delta sharing provider information.
    %
    % Example:
    %
    %   result = uc.getProvider(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the provider
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the provider
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderInfo
    %
    % Throws an error if the specified provider cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.ProviderInfo

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'providers');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ProviderInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end