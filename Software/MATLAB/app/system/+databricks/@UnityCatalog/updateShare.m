function result = updateShare(obj, name, shareinfo)
    % UPDATESHARE updates delta sharing share settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Objects cannot be updated with this method, use updateShareObjects
    % for this instead.
    %
    % Example:
    %
    %   result = uc.updateShare(name, shareinfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of share
    %       Type:
    %           string
    %   shareinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %
    % Outputs:
    %   result
    %       Description:
    %           updated share settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfo
    %
    % See Also: databricks.datastructures.unitycatalog.ShareInfo,
    %           updateShareObjects

    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        shareinfo databricks.datastructures.unitycatalog.ShareInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [
        "name", ...
        "comment", ...
        "objects", ...
        "owner"
    ];

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