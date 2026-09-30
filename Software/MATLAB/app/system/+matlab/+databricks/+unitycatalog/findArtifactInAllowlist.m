function [foundArtifact, idx] = findArtifactInAllowlist(allowlist, artifact, matchType)
    % findArtifactInAllowlist Find an artifact in the allowlist
    %
    % This function will see if an artifact is a member of a certain
    % allowlist. It's a utility function used by
    % matlab.databricks.unitycatalog.addArtifactAllowlistItem and
    % matlab.databricks.unitycatalog.removeArtifactAllowlistItem.
    %
    % PREFIX_MATCH is currently the only supported matchType.
    %
    % Example:
    %   artifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT")
    %   result = matlab.databricks.unitycatalog.findArtifactInAllowlist(artifacts.artifact_matchers, "/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh", "PREFIX_MATCH")
    %
    % See also: https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html

    % Copyright 2024 The MathWorks, Inc.

    arguments
        allowlist databricks.datastructures.unitycatalog.ArtifactMatchers
        artifact string {mustBeTextScalar, mustBeNonzeroLengthText}
        matchType string {mustBeTextScalar, mustBeNonzeroLengthText} = "PREFIX_MATCH"
    end

    if ~strcmp(matchType, "PREFIX_MATCH")
        error("DATABRICKS:findArtifactInAllowlist", "PREFIX_MATCH is the only supported matchType");
    end

    foundArtifact = databricks.datastructures.unitycatalog.ArtifactMatchers.empty;
    idx = [];

    for k=1:numel(allowlist)
        if startsWith(artifact, allowlist(k).artifact) && strcmp(matchType, allowlist(k).match_type)
            foundArtifact = allowlist(k);
            idx = k;
            break;
        end
    end
end
