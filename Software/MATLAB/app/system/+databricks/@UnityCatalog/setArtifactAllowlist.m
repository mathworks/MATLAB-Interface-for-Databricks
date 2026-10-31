function result = setArtifactAllowlist(obj, artifact_type, allowlistRequest)
    % setArtifactAllowlist Set the artifact allowlist of a certain artifact type
    % The whole artifact allowlist is replaced with the new allowlist.
    % The caller must be a metastore admin or have the MANAGE ALLOWLIST
    % privilege on the metastore.
    %
    % Example:
    %
    %   uc = databricks.UnityCatalog;
    %   matcher = databricks.datastructures.unitycatalog.ArtifactMatchers;
    %   matcher.artifact = "/Volumes/main/default/myvolume/myDir/runtime_install.sh";
    %   matcher.match_type = "PREFIX_MATCH";
    %   alr = databricks.datastructures.unitycatalog.AllowlistRequest;
    %   alr.artifact_matchers = matcher
    %   artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT;
    %   setResult = uc.setArtifactAllowlist(artifact_type, alr)
    %
    % Required Inputs:
    %   artifact_type
    %       Description:
    %           The artifact type of the allowlist
    %       Type:
    %           databricks.datastructures.unitycatalog.ArtifactType
    %   allowlistRequest
    %       Description:
    %           A list of allowed artifact match patterns
    %       Type:
    %           databricks.datastructures.unitycatalog.AllowlistRequest
    %       Required Properties in the data structure which must be set:
    %           artifact_matchers
    %
    % Outputs:
    %   result  
    %       Description:
    %           List of the matching type of configured allow lists
    %       Type:
    %           databricks.datastructures.unitycatalog.SetArtifactAllowlistResp
    %
    % See Also: databricks.datastructures.unitycatalog.SetArtifactAllowlistResp

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        artifact_type (1,1) databricks.datastructures.unitycatalog.ArtifactType
        allowlistRequest (1,1) databricks.datastructures.unitycatalog.AllowlistRequest
    end

    % Get URI
    URI = obj.getURI('unity-catalog','artifact-allowlists');
    URI.Path(end+1) = string(artifact_type);

    % Start a PUT request
    request = obj.getRequestMessage('PUT');

    % Set the body
    requiredProperties = [
        "artifact_matchers",...
    ]; %#ok<*NBRAK2>

    optionalProperties = [];

    request.Body(1).Payload = allowlistRequest.getPayload(requiredProperties, optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.SetArtifactAllowlistResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw()
    end
end