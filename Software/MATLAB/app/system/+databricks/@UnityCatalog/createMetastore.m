function result = createMetastore(obj, metastoreinfo)
    % CREATEMETASTORE creates a new metastore
    %
    % Example:
    %
    %   result = uc.createMetastore(metastoreinfo);    
    %
    % Required Inputs:
    %   metastoreinfo  
    %       Description: 
    %           settings/configuration for the new metastore
    %       Type: 
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           storage_root
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created metastore
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreInfo

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        metastoreinfo databricks.datastructures.unitycatalog.MetastoreInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastores');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name", ...
        "storage_root"
    ];

    optionalProperties = [];

    request.Body(1).Payload = metastoreinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.MetastoreInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end
