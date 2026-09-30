function result = updateVolume(obj, name, volumeInfo)
    % UPDATEVOLUME updates volume settings.
    %
    % Updates the specified volume under the specified parent catalog and
    % schema. The caller must be a metastore admin or an owner of the volume.
    % For the latter case, the caller must also be the owner or have the
    % USE_CATALOG privilege on the parent catalog and the USE_SCHEMA privilege
    % on the parent schema. Currently only the name, the owner or the comment
    % of the volume could be updated.
    %
    % Example:
    %
    %   result = uc.updateVolume(name, volumeInfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           The three-level (fully qualified) current name of the volume
    %           e.g.: "main.default.my_volume"
    %       Type:
    %           string
    %
    %   volumeInfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.VolumeInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %
    % Outputs:
    %   result
    %       Description:
    %           Updated volume settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.VolumeInfo
    %
    % See Also: databricks.datastructures.unitycatalog.VolumeInfo,
    %           updateShareObjects

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        volumeInfo databricks.datastructures.unitycatalog.VolumeInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'volumes');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [
        "name", ...
        "comment", ...
        "owner"
    ];

    request.Body(1).Payload = volumeInfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.VolumeInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end