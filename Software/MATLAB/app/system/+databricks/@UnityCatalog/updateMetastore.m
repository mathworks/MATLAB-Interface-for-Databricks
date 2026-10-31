function result = updateMetastore(obj, id, metastoreinfo)
    % UPDATEMETASTORE updates metastore settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateMetastore(id, metastoreinfo);
    %
    % Required Inputs:
    %   name  
    %       Description:
    %           (current) name of metastore
    %       Type:
    %           string
    %   metastoreinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           storage_root_credential_id
    %           owner
    %           delta_sharing_scope
    %           delta_sharing_recipient_token_lifetime_in_seconds
    %           delta_sharing_organization_name
    %           privilege_model_version
    %
    % Outputs:
    %   result
    %       Description:
    %           updated metastore settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        id string {mustBeTextScalar}
        metastoreinfo databricks.datastructures.unitycatalog.MetastoreInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastores');
    URI.Path(end+1) = id;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [];

    optionalProperties = [
        "name", ...
        "storage_root_credential_id", ...
        "owner", ...
        "delta_sharing_scope", ...
        "delta_sharing_recipient_token_lifetime_in_seconds", ...
        "delta_sharing_organization_name", ...
        "privilege_model_version"];

    request.Body(1).Payload = metastoreinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.MetastoreInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
    end
end