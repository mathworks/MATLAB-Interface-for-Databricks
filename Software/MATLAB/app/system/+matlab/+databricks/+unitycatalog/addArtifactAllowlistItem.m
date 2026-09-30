function setResult = addArtifactAllowlistItem(artifactType, artifact, matchType, options)
    % addArtifactAllowlistItem Add an artifact to the allowlist
    %
    % Add an artifact to the Allowlist. This function will first retrieve
    % the existing list. If this element is already on the list, no changes
    % will be made. If it's not on the list, it will be added.
    %
    % artifactPath = "abfss://mycontainer@mystorage.dfs.core.windows.net/runtime_install_r2023b.sh"
    % matlab.databricks.unitycatalog.addArtifactAllowlistItem("INIT_SCRIPT", artifactPath, "PREFIX_MATCH")
    % 
    % At the time of writing, "PREFIX_MATCH" is the only matchType, so this
    % can be omitted, i.e.
    %
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % matlab.databricks.unitycatalog.addArtifactAllowlistItem("INIT_SCRIPT", artifactPath)
    % 

    % Copyright 2024 The MathWorks, Inc.

    arguments 
        artifactType (1,1) databricks.datastructures.unitycatalog.ArtifactType
        artifact string {mustBeTextScalar, mustBeNonzeroLengthText}
        matchType (1,1) string = "PREFIX_MATCH"
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    curList = matlab.databricks.unitycatalog.getArtifactAllowlistItems(artifactType, args{:});
    curMatchers = curList.artifact_matchers;
    
    existingArtifact = ...
        matlab.databricks.unitycatalog.findArtifactInAllowlist(curMatchers, artifact, matchType);

    if ~isempty(existingArtifact)
        % This artifact is already in the list. No need to change anything
        setResult = [];
        return;
    end

    uc = databricks.UnityCatalog(args{:});
    matcher = databricks.datastructures.unitycatalog.ArtifactMatchers;
    matcher.artifact = artifact;
    matcher.match_type = matchType;

    alr = databricks.datastructures.unitycatalog.AllowlistRequest;
    alr.artifact_matchers = [curMatchers, matcher];

    setResult = uc.setArtifactAllowlist(artifactType, alr);
end
