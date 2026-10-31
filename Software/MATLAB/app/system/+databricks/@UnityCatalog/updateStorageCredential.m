function result = updateStorageCredential(obj, name, storagecredentialinfo)
    % UPDATESTORAGECREDENTIAL updates store credential settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateStorageCredential(name, storagecredentialinfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of storage credential
    %       Type:
    %           string
    %   storagecredentialinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.StorageCredentialInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           skip_validation
    %           owner
    %           aws_iam_role
    %           azure_service_principal
    %           gcp_service_account_key
    %
    % Outputs:
    %   result
    %       Description:
    %           updated storage credential settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.StorageCredentialInfo
    %
    % See Also: databricks.datastructures.unitycatalog.StorageCredentialInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        storagecredentialinfo databricks.datastructures.unitycatalog.StorageCredentialInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog','storage-credentials');
    URI.Path(end+1) = name;
    
    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [];

    optionalProperties = [
        "name", ...
        "comment", ...
        "skip_validation", ...
        "owner", ...
        "aws_iam_role", ...
        "azure_service_principal", ...
        "gcp_service_account_key"
    ];

    request.Body(1).Payload = storagecredentialinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.StorageCredentialInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end