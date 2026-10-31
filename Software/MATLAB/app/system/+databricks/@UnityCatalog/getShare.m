function result = getShare(obj, name)
    % GETSHARE gets delta sharing share information.
    %
    % Example:
    %
    %   result = uc.getShare(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the share
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the share
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfo
    %
    % Throws an error if the specified share cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.ShareInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');
    URI.Path(end+1) = name;
    
    URI.Query(end+1) = matlab.net.QueryParameter("include_shared_data",'true');
    
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ShareInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end