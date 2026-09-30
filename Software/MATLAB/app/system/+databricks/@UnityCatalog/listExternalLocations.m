function result = listExternalLocations(obj)
    % LISTEXTERNALLOCATIONS gets list of external locations.
    %
    % Example:
    %
    %   result = uc.listExternalLocations();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of external locations
    %       Type:
    %           databricks.datastructures.unitycatalog.ExternalLocationInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.ExternalLocationInfoList  

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'external-locations');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ExternalLocationInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end