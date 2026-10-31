function [result, errorResponse] = me(obj)
    % ME Get details about the current method caller's identity
    % On success a  databricks.datastructures.scim.MeResponse is returned with an
    % empty databricks.datastructures.files.ErrorResponse.
    % Otherwise an empty databricks.datastructures.scim.MeResponse is returned with
    % a populated databricks.datastructures.files.ErrorResponse.
    %
    % Example:
    %   s = databricks.SCIM;
    %   result = s.me
    %   result = MeResponse with properties:
    %        schemas: [2×1 string]
    %             id: "1234567890123456"
    %       userName: "joeuser@example.com"
    %         emails: [1×1 databricks.datastructures.scim.emails]
    %           name: [1×1 databricks.datastructures.scim.name]
    %    displayName: "Joe User"
    %         groups: [1×1 databricks.datastructures.scim.groups]
    %          roles: [0×0 databricks.datastructures.scim.roles]
    %   entitlements: [1×2 databricks.datastructures.scim.entitlements]
    %     externalId: "d1234ae5-ebec-1234-12eb-1234f56e7a89"
    %         active: 1
    %
    % See also: https://docs.databricks.com/api/workspace/currentuser/me
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.SCIM
    end

    % Get URI
    URI = obj.getURI('scim/v2', 'Me');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.scim.MeResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.scim.ErrorResponse.empty;
    else
        result = databricks.datastructures.scim.MeResponse.empty;
        errorResponse = databricks.datastructures.scim.ErrorResponse().fromJSON(resp.Body.Data);
    end
end