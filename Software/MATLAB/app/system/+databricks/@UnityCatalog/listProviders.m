function result = listProviders(obj)
    % LISTPROVIDERS lists delta sharing providers.
    %
    % Example:
    %
    %   result = uc.listProviders();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of providers
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.ProviderInfoList   

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'providers');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ProviderInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end