function result = updateExternalLocation(obj, name, externallocationinfo)
    % UPDATEEXTERNALLOCATION updates external location settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateExternalLocation(name, externallocationinfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of external location
    %       Type:
    %           string
    %   externallocationinfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.ExternalLocationInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %           url
    %           credential_name
    %           read_only
    %           force
    %           skip_validation
    %
    % Outputs:
    %   result
    %       Description:
    %           updated external location settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.ExternalLocationInfo
    %
    % See Also: databricks.datastructures.unitycatalog.ExternalLocationInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        externallocationinfo databricks.datastructures.unitycatalog.ExternalLocationInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog','external-locations');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [];

    optionalProperties = [
        "name", ...
        "comment", ...
        "owner", ...
        "url", ...
        "credential_name", ...
        "read_only", ...
        "force", ...
        "skip_validation"
    ];

    request.Body(1).Payload = externallocationinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ExternalLocationInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end