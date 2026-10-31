function result = getMyGroups(obj)
    % GETMYGROUPS gets group membership information of the user.
    %
    % Example:
    %
    %   result = uc.getMyGroups();
    %
    % Outputs:
    %   result
    %       Description:
    %           object with group_names which contains the group names
    %       Type:
    %           databricks.datastructures.unitycatalog.GetMyGroupsResp
    %
    % Throws an error if the specified metastore cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.GetMyGroupsResp
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'user-info');
    URI.Path(end+1) = 'my-groups';

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.GetMyGroupsResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end