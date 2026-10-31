function result = updateRecipient(obj, name, recipientinfo)
    % UPDATERECIPIENT updates delta sharing recipient settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateRecipient(name, recipientinfo);
    %
    % Required Inputs:
    %   name  
    %       Description:
    %           (current) name of recipient
    %       Type:
    %           string
    %   recipientinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %           ip_access_list
    %
    % Outputs:
    %   result
    %       Description:
    %           updated recipient settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfo
    %
    % See Also: databricks.datastructures.unitycatalog.RecipientInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        recipientinfo databricks.datastructures.unitycatalog.RecipientInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [
        "name",...
        "comment",...
        "owner",...
        "ip_access_list"
    ];

    request.Body(1).Payload = recipientinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.RecipientInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end