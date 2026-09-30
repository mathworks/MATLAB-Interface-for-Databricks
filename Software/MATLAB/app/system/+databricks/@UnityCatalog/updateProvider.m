function result = updateProvider(obj, name, providerinfo)
    % UPDATEPROVIDER updates delta sharing provider settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateProvider(name, providerinfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of provider
    %       Type:
    %           string
    %   providerinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %           recipient_profile_str
    %
    % Outputs:
    %   result
    %       Description:
    %           updated provider settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderInfo
    %
    % See Also: databricks.datastructures.unitycatalog.ProviderInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        providerinfo databricks.datastructures.unitycatalog.ProviderInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'providers');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [
        "name",...
        "comment",...
        "owner",...
        "recipient_profile_str"
    ];

    request.Body(1).Payload = providerinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ProviderInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end