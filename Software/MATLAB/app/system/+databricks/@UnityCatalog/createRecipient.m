function result = createRecipient(obj, recipientinfo)
    % CREATERECIPIENT creates a new delta sharing recipient.
    %
    % Example:
    %
    %   result = uc.createRecipient(recipientinfo);    
    %
    % Required Inputs:
    %   recipientinfo  
    %       Description: 
    %           settings/configuration for the new recipient
    %       Type: 
    %           databricks.datastructures.unitycatalog.RecipientInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           authentication_type
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           data_recipient_global_metastore_id
    %           ip_access_list
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created recipient
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfo      
    %
    % See Also: databricks.datastructures.unitycatalog.RecipientInfo     
    
    % Copyright 2022 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        recipientinfo databricks.datastructures.unitycatalog.RecipientInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name",...
        "authentication_type"
    ];

    optionalProperties = [
        "comment",...
        "data_recipient_global_metastore_id",...
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