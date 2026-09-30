function result = createProvider(obj, providerinfo)
    % CREATEPROVIDER creates a delta sharing provider.
    %
    % Example:
    %
    %   result = uc.createProvider(providerinfo);
    %
    % Required Inputs:
    %   providerinfo  
    %       Description: 
    %           settings/configuration for the new provider
    %       Type: 
    %           databricks.datastructures.unitycatalog.ProviderInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           authentication_type
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           recipient_profile_str
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created provider
    %       Type:
    %           databricks.datastructures.unitycatalog.ProviderInfo
    %
    % See Also: databricks.datastructures.unitycatalog.ProviderInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        providerinfo databricks.datastructures.unitycatalog.ProviderInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'providers');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name",...
        "authentication_type"
    ];

    optionalProperties = [
        "comment",...
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