function result = listStorageCredentials(obj)
    % LISTSTORAGECREDENTIALS lists storage credentials.
    %
    % Example:
    %
    %   result = uc.listStorageCredentials();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of storage credentials
    %       Type:
    %           databricks.datastructures.unitycatalog.StorageCredentialInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.StorageCredentialInfoList      

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'storage-credentials');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.StorageCredentialInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end