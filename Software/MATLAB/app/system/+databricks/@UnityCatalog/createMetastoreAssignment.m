function result = createMetastoreAssignment(obj, workspace_id, metastoreassignment)
    % CREATEMETASTOREASSIGNMENT creates meta store assignments which
    % assigns meta stores to workspaces.
    %
    % Example:
    %
    %   result = uc.createMetastoreAssignment(workspace_id, metastoreassignment);
    %
    % Required Inputs:
    %   workspace_id
    %       Description:
    %           ID of the workspace to create assignment for
    %       Type:
    %           int64
    %   metastoreassignment
    %       Description:
    %           settings/configuration for the assignment
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreAssignment
    %       Required Properties in the data structure which must be set:
    %           metastore_id
    %           default_catalog_name
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the created metastore assignment
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreAssignment
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreAssignment
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        workspace_id int64
        metastoreassignment databricks.datastructures.unitycatalog.MetastoreAssignment
    end

    % Get URI
    URI = obj.getURI('unity-catalog','workspaces');
    URI.Path(end+1) = workspace_id;
    URI.Path(end+1) = 'metastore';

    % Start a POST request
    request = obj.getRequestMessage('PUT');

    % Set the body
    requiredProperties = [
        "metastore_id", ...
        "default_catalog_name"
    ];

    optionalProperties = [];

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