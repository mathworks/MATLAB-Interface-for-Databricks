function result = getMyInfo(obj, for_account_level)
    % GETMYINFO retrieves current user information as it relates to Unity
    % Catalog. Which is really just one piece of information: whether the
    % user is a metastore administrator or not.
    %
    % Example:
    %
    %   result = uc.getMyInfo();
    %
    % Outputs:
    %   result  
    %       Description:
    %           object with is_metastore_admin property which indicates
    %           whether user is metastore administrator or not
    %       Type:
    %           databricks.datastructures.unitycatalog.GetMyInfoResp
    %
    % Throws an error if the specified metastore cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.GetMyInfoResp
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        for_account_level logical = false
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'user-info');
    URI.Path(end+1) = 'me';

    % Start a GET request
    request = obj.getRequestMessage('GET');

    if for_account_level
        URI.Query(end+1) = matlab.net.QueryParameter("for_account_level",for_account_level);
    end

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.GetMyInfoResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end