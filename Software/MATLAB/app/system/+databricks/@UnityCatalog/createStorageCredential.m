function result = createStorageCredential(obj, storagecredentialinfo)
    % CREATESTORAGECREDENTIAL creates a new storage credential.
    %
    % Example:
    %
    %   result = uc.createStorageCredential(storagecredentialinfo);
    %
    % Required Inputs:
    %   storagecredentialinfo  
    %       Description: 
    %           settings/configuration for the new storage credential
    %       Type: 
    %           databricks.datastructures.unitycatalog.StorageCredentialInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           aws_iam_role OR azure_service_principal OR gcp_service_account_key
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           skip_validation
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created storage credential
    %       Type:
    %           databricks.datastructures.unitycatalog.StorageCredentialInfo
    %
    % See Also: databricks.datastructures.unitycatalog.StorageCredentialInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        storagecredentialinfo databricks.datastructures.unitycatalog.StorageCredentialInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog','storage-credentials');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name"
    ]; %#ok<NBRAK2> 

    if isempty(storagecredentialinfo.aws_iam_role) && ...
        isempty(storagecredentialinfo.azure_service_principal) && ...
        isempty(storagecredentialinfo.gcp_service_account_key)
        error('databricks:unitycatalog:missingfield','Either aws_iam_role, azure_service_principal or gcp_service_account_key must be set.');
    end
    optionalProperties = [
        "comment", ...
        "skip_validation", ...
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