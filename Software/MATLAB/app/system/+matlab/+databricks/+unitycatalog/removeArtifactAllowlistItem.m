function setResult = removeArtifactAllowlistItem(artifactType, artifact, matchType, options)
    % removeArtifactAllowlistItem Remove an artifact from the allowlist
    %
    % Remove an artifact from the Allowlist. This function will first retrieve
    % the existing list. If this element isn't on the list, no changes
    % will be made. If it is on the list, it will be removed.
    %
    % artifactPath = "abfss://mycontainer@mystorage.dfs.core.windows.net/runtime_install_r2023b.sh"
    % matlab.databricks.unitycatalog.removeArtifactAllowlistItem("INIT_SCRIPT", artifactPath, "PREFIX_MATCH")
    % 
    % At the time of writing, "PREFIX_MATCH" is the only matchType, so this
    % can be omitted, i.e.
    %
    % matlab.databricks.unitycatalog.removeArtifactAllowlistItem("INIT_SCRIPT", artifactPath)
    % 

    % Copyright 2024 The MathWorks, Inc.

    arguments 
        artifactType (1,1) databricks.datastructures.unitycatalog.ArtifactType
        artifact (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
        matchType (1,1) string = "PREFIX_MATCH"
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    curList = matlab.databricks.unitycatalog.getArtifactAllowlistItems(artifactType, args{:});
    curMatchers = curList.artifact_matchers;
    
    [existingArtifact, existingIdx] = ...
        matlab.databricks.unitycatalog.findArtifactInAllowlist(curMatchers, artifact, matchType);

    if isempty(existingArtifact)
        % This artifact isn't in the list. No need to change anything
        setResult = [];
        return;
    end

    uc = databricks.UnityCatalog(args{:});

    alr = databricks.datastructures.unitycatalog.AllowlistRequest;
    curMatchers(existingIdx) = [];
    alr.artifact_matchers = curMatchers;

    setResult = uc.setArtifactAllowlist(artifactType, alr);
end
