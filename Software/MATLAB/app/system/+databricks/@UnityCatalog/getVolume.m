function result = getVolume(obj, name)
    % GETVOLUME gets volume information.
    %
    % Example:
    %
    %   result = uc.getVolume(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           The three-level (fully qualified) name of the volume
    %           e.g.: "main.default.my_volume"
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the volume
    %       Type:
    %           databricks.datastructures.unitycatalog.VolumeInfo
    %
    % Returns an empty databricks.datastructures.unitycatalog.VolumeInfo
    % if the specified volume cannot be found. In other cases an error is
    % thrown.
    %
    % See Also: databricks.datastructures.unitycatalog.VolumeInfo
    
    % Copyright 2024-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'volumes');
    URI.Path(end+1) = name;
      
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.VolumeInfo().fromJSON(resp.Body.Data);
    else
        if resp.StatusCode == matlab.net.http.StatusCode.NotFound && contains(resp.Body.Data, '"error_code":"RESOURCE_DOES_NOT_EXIST"')
            result = databricks.datastructures.unitycatalog.VolumeInfo.empty;
        else
            result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
            result.throw();
        end
    end
end