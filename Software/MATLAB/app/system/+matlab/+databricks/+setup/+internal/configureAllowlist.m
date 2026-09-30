function configureAllowlist(options)
    % CONFIGUREALLOWLIST Configures the allowlist for javabuilder and the init script
    % Assume interactive use.

    % (c) MathWorks Inc 2024

    arguments
        options.clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.accessMode (1,1) databricks.datastructures.DataSecurityMode
        
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.javabuilderEntry string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        
        % Auth
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        
        % Misc
        options.verbose (1,1) logical = true
    end

    fprintf("\nConfiguring allowlist entries in Databricks requires administrative privileges.\n");

    %% interfaceDirectory
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        args = matlab.utils.addArgs(options, "settingsFile");
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory", args{:});
        interfaceDirectory = string(strip(interfaceDirectory, "right", "/"));
    end
    
    %% initscript
    if isfield(options, "initscript")
        initscript = options.initscript;
    else
        initscript = interfaceDirectory + "/runtimes/runtime_install.sh";
    end

    % Configure Javabuilder and the init script on the allowlist
    % Call after matlab.databricks.setup.configureRuntimes
    preamble = sprintf("\nAllowlist entries are required for the init script and the javabuilder.jar\n");
    preamble = preamble + sprintf("component of the MATLAB runtime when using Shared Access Mode clusters.\n");
    preamble = preamble + sprintf("For Shared Access Mode details see: %s\n", matlab.utils.internal.editOrURLLink("Isolation")); 
    prompt = sprintf("Configure allowlists");
    if ~matlab.utils.ynQuestion(prompt, "Y", preamble=preamble)
        matlab.databricks.setup.internal.initScriptMetastoreMsg(path=initscript);
        fprintf("\n");
        matlab.databricks.setup.internal.javabuilderMetastoreMsg(path=interfaceDirectory + "/MathWorks/runtimes/javabuilder");
        fprintf("\nSee also: %s\n", matlab.utils.URL2Link("https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html"));
        return;
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if checkForExitingInitScriptEntry(initscript, args{:})
        fprintf("Found an existing allowlist entry for: %s\n", initscript);
        fprintf("Skipping.\n");
    else
        prompt = sprintf("Add the init script to the allowlist");
        if matlab.utils.ynQuestion(prompt, "Y", preamble=" ")
            result = matlab.databricks.unitycatalog.addArtifactAllowlistItem("INIT_SCRIPT", initscript); %#ok<NASGU>
            fprintf("allowlist updated.\n");
        else
            matlab.databricks.setup.internal.initScriptMetastoreMsg(path=initscript);
            fprintf("See also: %s\n", matlab.utils.URL2Link("https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html"));
        end
    end

    %% Javabuilder
    if isfield(options, "initscript")
        javabuilderEntry = options.javabuilderEntry;
    else
        javabuilderEntry = interfaceDirectory + "/runtimes/javabuilder";
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if checkForExitingJarEntry(javabuilderEntry, args{:})
        fprintf("Found an existing allowlist entry for: %s\n", javabuilderEntry);
        fprintf("Skipping.\n");
    else
        prompt = sprintf("Add the javabuilder (MATLAB runtime component) details to the allowlist");
        if matlab.utils.ynQuestion(prompt, "Y", preamble=" ")
            result = matlab.databricks.unitycatalog.addArtifactAllowlistItem("LIBRARY_JAR", javabuilderEntry); %#ok<NASGU>
            fprintf("allowlist updated.\n");
        else
            matlab.databricks.setup.internal.javabuilderMetastoreMsg(path=interfaceDirectory + "/MathWorks/runtimes/javabuilder");
            fprintf("See also: %s\n", matlab.utils.URL2Link("https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html"));
        end
    end
end


function tf = checkForExitingInitScriptEntry(path, options)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    artifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT", args{:});
    allowlistEntry = matlab.databricks.unitycatalog.findArtifactInAllowlist(artifacts.artifact_matchers, path, "PREFIX_MATCH");
    if isempty(allowlistEntry)
        tf = false;
    else
        tf = true;
    end
end


function tf = checkForExitingJarEntry(path, options)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    artifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems("LIBRARY_JAR", args{:});
    allowlistEntry = matlab.databricks.unitycatalog.findArtifactInAllowlist(artifacts.artifact_matchers, path, "PREFIX_MATCH");
    if isempty(allowlistEntry)
        tf = false;
    else
        tf = true;
    end
end