function result = updateShareObjects(obj, name, shareinfo)
    % UPDATESHAREOBJECTS updates objects on a given delta sharing share.
    %
    % The changes are specified through a ObjectsDiff object which has an
    % updates property. updates is an array of ObjectsChange objects. In
    % each ObjectsChange object you specify the action, ADD or REMOVE to
    % add or remove an object respectively and provide a data_object which
    % describes the actual object to share. UPDATESHARE does not fully
    % overwrite/replace existing objects, it really adds and removes the
    % specified objects to/from a share.
    %
    % Example:
    %
    %   result = uc.updateShareObjects(name, shareinfo);
    %
    % Required Inputs:
    %   name  
    %       Description:
    %           name of the share
    %       Type:
    %           string
    %   shareinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.ObjectsDiff
    %   
    % Outputs:
    %   result  
    %       Description:
    %           updated permissions
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfo
    %
    % See Also: databricks.datastructures.unitycatalog.ObjectsDiff,
    %           databricks.datastructures.unitycatalog.ShareInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        shareinfo databricks.datastructures.unitycatalog.ObjectsDiff
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [ ];

    request.Body(1).Payload = shareinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ShareInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end