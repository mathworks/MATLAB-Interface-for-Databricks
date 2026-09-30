function result = updateMetastoreAssignment(obj, workspace_id, metastoreassignment)
    % UPDATEMETASTOREASSIGNMENT updates metastore assignment on a given workspace
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateMetastoreAssignment(workspace_id, metastoreassignment);
    %
    % Required Inputs:
    %   workspace_id
    %       workspace_id:
    %           id of the workspace
    %       Type:
    %           int64
    %   metastoreassignment
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreAssignment
    %       Optional Properties in the data structure which can be updated:
    %           metastore_id
    %           default_catalog_name
    %
    % Outputs:
    %   result
    %       Description:
    %           updated metastore settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreAssignment
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreAssignment
    
    % Copyright 2022 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        workspace_id int64
        metastoreassignment databricks.datastructures.unitycatalog.MetastoreAssignment
    end

    % Get URI
    URI = obj.getURI('unity-catalog','workspaces');
    URI.Path{end+1} = num2str(workspace_id);
    URI.Path{end+1} = 'metastore';

    % Start a POST request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [
    ];

    optionalProperties = [
        "metastore_id", ...
        "default_catalog_name"
    ];

    request.Body(1).Payload = metastoreassignment.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.metastoreassignment().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw()
    end
end