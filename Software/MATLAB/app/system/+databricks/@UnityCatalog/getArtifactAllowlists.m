function result = getArtifactAllowlists(obj, artifact_type)
    % getArtifactAllowlists Get the artifact allowlist of a certain artifact type
    % The caller must be a metastore admin or have the MANAGE ALLOWLIST privilege
    % on the metastore.
    %
    % Example:
    %
    %   uc = databricks.UnityCatalog;
    %   artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT;
    %   result = uc.getArtifactAllowlists(artifact_type);
    %
    % Outputs:
    %   result  
    %       Description:
    %           object which lists artifact allowlist of a certain artifact type
    %       Type:
    %           databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
    %
    % Throws an error if the specified metastore cannot be found.
    %
    % If no artifacts are present a databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
    % is returned with the metastore_id field populated and the other
    % fields having default values, e.g:
    %
    %   x = matlab.databricks.unitycatalog.getArtifactAllowListItems('LIBRARY_MAVEN')
    %   x = GetArtifactAllowListsResp with properties:
    %         artifact_matchers: [0×0 databricks.datastructures.unitycatalog.ArtifactMatchers]
    %         metastore_id: "3ce438d4-321c-49ec-9ac1-626acb9c0be3"
    %         created_by: ""
    %         created_at: [0×0 datetime]
    %
    % See Also: databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
    
    % Copyright 2023-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        artifact_type (1,1) databricks.datastructures.unitycatalog.ArtifactType
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'artifact-allowlists');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    URI.Path(end+1) = string(artifact_type);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        tmpDecode = jsondecode(resp.Body.Data);
        if ~isfield(tmpDecode, 'metastore_id')
            error("DATABRICKS:getArtifactAllowlists", "Expected metastore_id field not found");
        end
        if isfield(tmpDecode, 'created_by') && isfield(tmpDecode, 'created_at') && isfield(tmpDecode, 'artifact_matchers')
            result = databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp().fromJSON(resp.Body.Data);
        else
            result = databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp;
            result.metastore_id = string(tmpDecode.metastore_id);
        end
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end