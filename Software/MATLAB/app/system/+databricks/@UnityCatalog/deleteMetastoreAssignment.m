function result = deleteMetastoreAssignment(obj, workspace_id, metastoreassignment)
    % DELETEMETASTOREASSIGNMENT deletes a metastore assignment.
    %
    % Example:
    %
    %   result = uc.deleteMetastoreAssignment(workspace_id, metastoreassignment);
    %
    % Required Inputs:
    %   workspace_id
    %       Description:
    %           ID of the workspace to delete assignment from
    %       Type:
    %           int64    
    %   metastoreassignment  
    %       Description: 
    %           Data structure with 'metastore_id' property set to specify
    %           which assignment to delete
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreAssignment
    %
    % Outputs:
    %   result
    %       Description:
    %           true is successful, never returns false (throws error if 
    %           unsuccessful)
    %       Type:
    %           logical
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
    URI.Path{end+1} = num2str(workspace_id);
    URI.Path{end+1} = 'metastore';

    % Start a POST request
    request = obj.getRequestMessage('DELETE');

    % Set the body
    requiredProperties = [
        "metastore_id"
    ]; %#ok<NBRAK2> 

    optionalProperties = [
    ];

    request.Body(1).Payload = metastoreassignment.getPayload(requiredProperties,optionalProperties);

    % MATLAB nor RFC7231 expect a body for DELETE, but this Unity Catalog
    % method requires one, temporarily hide MATLAB warning about this
    oldWarn = warning('off','MATLAB:http:BodyUnexpectedFor');
    resetWarning = onCleanup(@()warning(oldWarn));

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw()
    end
end