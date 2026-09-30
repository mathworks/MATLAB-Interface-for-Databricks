function [result, errorResponse] = getCurrentUserInfo(obj)
    % GETCURRENTUSERINFO Get details about the current method caller's identity
    % This function uses a Databricks public preview API and is subject to change.
    %
    % Example:
    %   u = databricks.CurrentUser;
    %   [userInfo, errorResponse] = u.getCurrentUserInfo();
    %   userInfo.userName
    %    ans = 
    %    "joeuser@example.com"
    %
    % See also: https://docs.databricks.com/api/workspace/currentuser/me

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.CurrentUser
    end

    % Get URI
    URI = obj.getURI('preview', 'scim');
    URI.Path(end+1) = "v2";
    URI.Path(end+1) = "Me";
        
    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.currentuser.UserInfo().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.currentuser.ErrorResponse.empty;
    else
        result = databricks.datastructures.currentuser.UserInfo.empty;
        errorResponse = databricks.datastructures.currentuser.ErrorResponse().fromJSON(resp.Body.Data);
    end
end