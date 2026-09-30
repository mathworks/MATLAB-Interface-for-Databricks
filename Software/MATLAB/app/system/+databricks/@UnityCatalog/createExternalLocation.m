function result = createExternalLocation(obj, externallocationinfo)
    % CREATEEXTERNALLOCATION creates a new external location.
    %
    % Example:
    %
    %   result = uc.createExternalLocation(externallocationinfo);
    %
    % Required Inputs:
    %   externallocationinfo  
    %       Description: 
    %           settings/configuration for the new external location
    %       Type: 
    %           databricks.datastructures.unitycatalog.ExternalLocationInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           url
    %           credential_name
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           read_only
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created external location
    %       Type:
    %           databricks.datastructures.unitycatalog.ExternalLocationInfo    
    %
    % See Also: databricks.datastructures.unitycatalog.ExternalLocationInfo    
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        externallocationinfo databricks.datastructures.unitycatalog.ExternalLocationInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog','external-locations');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name", ...
        "url", ...
        "credential_name"
    ];

    optionalProperties = [
        "comment", ...
        "read_only"
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
