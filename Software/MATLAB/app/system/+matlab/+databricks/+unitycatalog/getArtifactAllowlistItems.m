function result = getArtifactAllowlistItems(artifactType, options)
    % getArtifactAllowlistItems Get list of artifacts from the allowlist
    %
    % % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Only artifacts of one specific type will be returned. The
    % artifactType argument is of type
    % databricks.datastructures.unitycatalog.ArtifactType, e.g.
    % databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT
    %
    %   result = matlab.databricks.unitycatalog.getArtifactAllowlistItems(...
    %     databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT);
    %   
    % A shorter form of the same is
    %
    %   result = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        artifactType (1,1) databricks.datastructures.unitycatalog.ArtifactType
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    uc = databricks.UnityCatalog(args{:});
    result = uc.getArtifactAllowlists(artifactType);

end
