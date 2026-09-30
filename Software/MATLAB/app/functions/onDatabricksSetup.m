function onDatabricksSetup(options)
    % ONDATABRICKSSETUP Top-level function to step through the interface's setup process
    % This function takes the role of setup.m in a desktop based scenario.
    % It is designed to be invoked at startup by the Web Proxy such that the
    % support package is automatically configured prior to end user access.
    %
    % This function automatically accepts the software license agreement for the
    % Databricks JDBC driver and the MATLAB runtime on the user's behalf.
    %
    % Optional arguments:
    %   settingsFile: Path to settings configuration file
    %   cfgFile: Path to configuration file
    %   interfaceDirectory: Interface directory path
    %   forceCfgAndSettingsUpdate: force updates to exiting settings or configuration files.
    %
    %   preExecScript : Path to script to execute before setup
    %   postExecScript: Path to script to execute after setup
    %
    %   authMethod: Authentication method
    %   profileName: Profile name for configuration
    %   deleteCachedTokens: Deletes cached authentication tokens (default: false)
    %   cachedTokenPaths: Path to cached authentication tokens
    %
    %   skipPathCheck: Skip path depth check, has no effect on Linux or macOS (default: true)
    %   skipUpdateCheck: Skip check for updated version
    %   verbose: Enables additional output (default: true)
    %   startupFolder: Folder to changed to once setup is complete
    %   runDiagnostics: Runs diagnostics after setup (default: false)
    %
    % The function may be invoked repeatedly with the same input arguments. However,
    % if in the mean time the user has changed settings or configuration, those
    % changes would be overwritten. Thus if the settings or configuration files
    % exist they will not be altered unless the forceCfgAndSettingsUpdate flag is
    % set to true. By default it is false.
    %
    % The idempotence of preExecScript & postExecScript is the responsibility of
    % the caller.

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        % General
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.forceCfgAndSettingsUpdate (1,1) logical = false

        % Hooks
        options.preExecScript string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.postExecScript string {mustBeTextScalar, mustBeNonzeroLengthText}

        % Auth
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.deleteCachedTokens (1,1) logical = false
        options.cachedTokenPaths string {mustBeNonzeroLengthText}

        % Misc
        options.skipPathCheck (1,1) logical = true
        options.skipUpdateCheck (1,1) logical = false
        options.verbose (1,1) logical = true
        options.startupFolder (1,1) string {mustBeFolder}
        options.runDiagnostics (1,1) logical = false
    end

    printBanner("MATLAB interface for Databricks - on platform setup", verbose=options.verbose);
    if options.verbose
        fprintf("\n");
    end

    if isfield(options, 'startupFolder')
        onFinish = onCleanup(@() cd(options.startupFolder));
    end

    if isfield(options, "preExecScript")
        if options.verbose
            fprintf("Running preExecScript: %s\n", options.preExecScript);
        end
        try
            run(options.preExecScript);
        catch ME
            fprintf(2, "Problems running preExecScript.\n%s\n", ME.message);
        end
        if options.verbose
            fprintf("preExecScript complete.\n");
        end
    end

    % Require a recent release for improved Web Desktop experience
    % Strict limit is R2022b for the wider package
    if isMATLABReleaseOlderThan("R2022b")
        fprintf(2, "This package requires MATLAB R2022b or later.\n");
        return;
    end

    %% Settings & cfg
    thisDir = cd(fileparts(mfilename("fullpath")));
    cleanUp = onCleanup(@() cd(thisDir));
    % Will not add paths if package is already on the path
    addDatabricksPaths(verbose=options.verbose);
    clear('cleanUp');
    % Package needed on path beyond this point

    if ~databricks.internal.isOnDatabricks
        fprintf(2, "Not running on Databricks, see: setup.m\n");
        return;
    end

    % Run user defined startup code
    startupShutdownConfig = getenv('MW_STARTUP_SHUTDOWN_CONFIG');
    if strlength(startupShutdownConfig) > 0
        ctx = matlab.utils.mwcontext.Context().fromJSON(fileread(startupShutdownConfig));
        ctx.startup();
    end

    % Set Databricks-Connect variable to ensure correct functioning of
    % interactive Spark sessions from within MATLAB.
    setenv('SPARK_CONNECT_MODE_ENABLED', '1');

    % Can error(), do after addDatabricksPaths to get namespace & startup's check for a JVM
    databricks.internal.checks.checkJavaUserHome();

    if options.skipPathCheck
        if ~matlab.databricks.setup.depthCheck() && options.verbose
            fprintf("Exiting setup.\n");
            return;
        end
    end

    % Handle DBFS mex file
    databricks.internal.checks.setBase64Pref(verbose=false);

    % Display setup doc location, open top-level doc at the end
    if options.verbose
        docPath = databricksRoot(-2, "Documentation", "html", "Setup.html");
        fprintf("\n");
        if isfile(docPath)
            fprintf("For setup documentation in HTML format see:\n");
            fprintf("  %s\n",  matlab.utils.URL2Link(docPath));
        else
            mdDoc = databricksRoot(-2, "Documentation", "Setup.md");
            fprintf("For setup documentation in Markdown format see:\n");
            fprintf("  %s\n", matlab.utils.editLink(mdDoc));
        end
    end

    % Check for key toolboxes
    databricks.internal.checks.checkCompiler(verbose=options.verbose);
    databricks.internal.checks.checkCompilerSDK(verbose=options.verbose);
    databricks.internal.checks.checkDatabaseToolbox();

    % Check for legacy Databricks Connect jars
    matlab.databricks.setup.internal.checkDBCJCP();

    % Remove any cached tokens
    if options.deleteCachedTokens
        args = matlab.utils.addArgs(options, "cachedTokenPaths");
        matlab.databricks.setup.deleteAuthTokens("verbose", false, args{:});
    end

    %% User Settings
    if isfield(options, "settingsFile")
        settingsFile = options.settingsFile;
    else
        readPath = databricks.internal.settings.Settings.getSettingsFileReadPath();
        if isempty(readPath) || strlength(readPath)==0
            settingsFile = databricks.internal.settings.Settings.getDefaultSettingsFilePath();
        else
            settingsFile = readPath;
        end
    end
    args = matlab.utils.addArgs(options, ["authMethod", "interfaceDirectory", "verbose"]);
    if isfile(settingsFile)
        if ~options.forceCfgAndSettingsUpdate
            if options.verbose
                fprintf("Skipping writing databricks-settings.json, file already exists.\n");
            end
        else
            settingsFile = configureOnPlatformSettings("settingsFile", settingsFile, args{:}); %#ok<NASGU>
        end
    else
        settingsFile = configureOnPlatformSettings("settingsFile", settingsFile, args{:}); %#ok<NASGU>
    end

    %% User configuration
    if isfield(options, "cfgFile")
        cfgFile = options.cfgFile;
    else
        cfgFile = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath();
    end
    if isfile(cfgFile)
        if ~options.forceCfgAndSettingsUpdate
            if options.verbose
                fprintf("Skipping writing .databrickscfg, file already exists.\n");
            end
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
            cfgFile = configureOnPlatformCfg("cfgFile", cfgFile, args{:}); %#ok<NASGU>
        end
    else
        args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
        cfgFile = configureOnPlatformCfg("cfgFile", cfgFile, args{:}); %#ok<NASGU>
    end

    %% New version check
    if ~options.skipUpdateCheck
        if options.verbose
            fprintf("\nChecking for updates.\n");
        end
        databricks.internal.utils.newVersionCheck(forceCheck=false, verbose=options.verbose);
    end

    %% JDBC, accepts the SLA
    matlab.databricks.setup.configureJDBC(acceptance=true, verbose=options.verbose);

    %% Databricks Connect
    % Support only one version of Python for now
    printBanner("Databricks Connect setup", verbose=options.verbose);
    pyExecutable = getPythonExecutable();
    pyVersion = getPythonVersion(executablePath=pyExecutable);
    if isempty(pyVersion)
        fprintf(2, "Invalid Python version, skipping Databricks Connect configuration.\n");
    else
        % Sort DBRs so the newest is made the default
        if strcmp(pyVersion, "3.12")
            DBRs = ["16.4", "17.3"];
        elseif strcmp(pyVersion, "3.11")
            DBRs = ["15.4"]; %#ok<NBRAK2>
        elseif strcmp(pyVersion, "3.10")
            DBRs = ["13.3", "14.3"];
        else
            fprintf(2, "Unexpected Python version, skipping Databricks Connect configuration: %s\n", pyVersion);
            DBRs = "";
        end
        if ~databricks.internal.isOnDatabricks
            for n = 1:numel(DBRs)
                venvDir = databricksRoot("Connect", DBRs(n), "venv");
                pyBin = fullfile(venvDir, "bin", "python");
                if isfile(pyBin)
                    if options.verbose
                        fprintf("Found existing Databricks Connect virtual environment: %s\n", venvDir);
                    end
                else
                    if options.verbose
                        fprintf("Configuring Databricks Connect for: %s.\n", DBRs(n));
                    end
                    matlab.databricks.setup.configureDBC(...
                        acceptance=true,...
                        dbcVersions=DBRs(n),...
                        pythonExecutable=pyExecutable,...
                        verbose=options.verbose);
                end
            end
            % Default the pyenv to the first DBR entry
            if numel(DBRs) > 0
                args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
                pe = matlab.databricks.connect.setPyenv("Version", DBRs(1), args{:}); %#ok<NASGU>
            end
        end
    end

    % Done
    if options.runDiagnostics
        if options.verbose
            fprintf("Setup complete, running diagnostics.\n\n");
        end
        matlab.databricks.databricksDiagnostics(verbose=options.verbose)
    end


    if isfield(options, "postExecScript")
        if options.verbose
            fprintf("Running postExecScript: %s\n", options.postExecScript);
        end
        try
            run(options.postExecScript);
        catch ME
            fprintf(2, "Problems running postExecScript.\n%s\n", ME.message);
        end
        if options.verbose
            fprintf("postExecScript complete.\n");
        end
    end
end


function pe = getPythonExecutable()
    pe = string.empty;
    if databricks.internal.isOnDatabricks
        envVar = string(getenv("VIRTUAL_ENV"));
        if isempty(envVar) || strlength(envVar) == 0
            envVar = string(getenv("DATABRICKS_ROOT_VIRTUALENV_ENV"));
            if isempty(envVar) || strlength(envVar) == 0
                fprintf(2, "VIRTUAL_ENV / DATABRICKS_ROOT_VIRTUALENV_ENV environment variables not set on Databricks.\n");
                return;
            end
        end
        pPath = fullfile(envVar, "bin", "python");
        if isfile(pPath)
            pe = pPath;
        else
            if isempty(pPath) || strlength(pPath) == 0
                fprintf(2, "Python executable not found on Databricks.\n");
            else
                fprintf(2, "Python executable not found on Databricks: %s\n", pPath);
            end
        end
    end
end


function pv = getPythonVersion(options)
    arguments
        options.executablePath string
    end

    pv = string.empty();
    if isfield(options, "executablePath")
        pe = options.executablePath;
    else
        pe = getPythonExecutable();
    end

    if isempty(pe)
        fprintf(2, "Could not find expected Python executable.\n");
        return;
    end
    [status, cmdOut] = system(sprintf('"%s" --version', pe));
    if status ~= 0
        fprintf(2, "Could not determine Python version: %s\n", cmdOut);
        return;
    end
    if startsWith(cmdOut, "Python 3.12")
        pv = "3.12";
    elseif startsWith(cmdOut, "Python 3.11")
        pv = "3.11";
    elseif startsWith(cmdOut, "Python 3.10")
        pv = "3.10";
    else
        fprintf(2, "Unexpected Python version: %s\n", cmdOut);
        return;
    end
end


function printBanner(str, options)
    arguments
        str string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.leadingNewline (1,1) logical = true
        options.verbose
    end

    % Don't print anything if not verbose
    if ~options.verbose
        return;
    end

    if options.leadingNewline
        fprintf("\n");
    end
    disp([char(str), newline,repmat('-',1,strlength(str))]);
end

function settingsFile = configureOnPlatformSettings(options)
    % CONFIGUREONPLATFORMSETTINGS Write databricks-settings.json file

    arguments
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    % Handle settings file on the assumption that it does not exist
    if ~isfield(options, "settingFile")
        readPath = databricks.internal.settings.Settings.getSettingsFileReadPath();
        if isempty(readPath) || strlength(readPath)==0
            options.settingsFile = databricks.internal.settings.Settings.getDefaultSettingsFilePath();
        else
            options.settingsFile = readPath;
        end
    end

    if options.verbose
        fprintf("\nConfiguring settings details\n\n");
    end

    args = {"verbose", false};
    args = matlab.utils.addArgs(options, "settingsFile", args);
    settingsFile = getAndProvisionSettingsFile(args{:});

    value = getRuntimeContextEnvVar("MW_API_URL", verbose=options.verbose);
    if strlength(value) == 0
        if options.verbose
            fprintf("MW_API_URL environment variable not set, unable to set vendor settings field.\n");
        end
    else
        if contains(value, "azure")
            databricks.internal.settings.Settings.writeDatabricksSettingsFields("vendor", "azure", settingsFile=settingsFile, verbose=false);
        else
            databricks.internal.settings.Settings.writeDatabricksSettingsFields("vendor", "aws", settingsFile=settingsFile, verbose=false);
        end
    end


    if isfield(options, "authMethod")
        % If it is being set explicitly assume the token if needed is also handled
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("authMethod", options.authMethod, settingsFile=settingsFile, verbose=false);
    else
        if strlength(getRuntimeContextEnvVar("MW_API_TOKEN_B64", verbose=options.verbose)) == 0
            if options.verbose
                fprintf(2, "Setting authMethod to PAT, however the expected token value MW_API_TOKEN_B64 to be stored in the .databrickscfg configuration file is not set.\n");
            end
        end
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("authMethod", "PAT", settingsFile=settingsFile, verbose=false);
    end

    value = getRuntimeContextEnvVar("MW_DBX_USERNAME", verbose=options.verbose);
    if strlength(value) == 0
        if options.verbose
            fprintf(2,"MW_DBX_USERNAME environment variable not set, unable to set notificationEmail and username settings fields.\n");
        end
    else
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("notificationEmail", value, settingsFile=settingsFile, verbose=false);
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("username", value, settingsFile=settingsFile, verbose=false);
    end

    if isfield(options, "interfaceDirectory")
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("interfaceDirectory", options.interfaceDirectory, settingsFile=settingsFile, verbose=false);
    else
        value = getRuntimeContextEnvVar("MW_INTERFACE_DIRECTORY_DEFAULT", verbose=options.verbose);
        if strlength(value) == 0
            value = "/Volumes/main/default/Error_Interface_Directory_Not_Set/MathWorks";
            if options.verbose
                fprintf(2,"MW_INTERFACE_DIRECTORY_DEFAULT environment variable not set, unable to set interfaceDirectory settings field.\n");
                fprintf(2,"Using placeholder value: %s\n", value);
            end
        end
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("interfaceDirectory", value, settingsFile=settingsFile, verbose=false);
    end
end


function cfgFile = configureOnPlatformCfg(options)
    % CONFIGUREONPLATFORMCFG Write .databrickscfg file

    arguments
        options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if options.verbose
        fprintf("\nConfiguring configuration details\n\n");
    end

    if isfield(options, "profileName")
        profileName = options.profileName;
    else
        % databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        % requires a settings file which may not exist yet
        % Default to "DEFAULT"
        profileName = "DEFAULT";
    end

    args = {"verbose", false};
    args = matlab.utils.addArgs(options, "cfgFile", args);
    cfgFile = getAndProvisionConfigurationFile(args{:});

    value = getRuntimeContextEnvVar("MW_HOST", verbose=options.verbose);
    if strlength(value) == 0
        if options.verbose
            fprintf(2,"MW_HOST environment variable not set, unable to set host configuration field.\n");
        end
    else
        databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "host", value, cfgFile=cfgFile, verbose=false);
    end

    value = getRuntimeContextEnvVar("MW_ORG_ID", verbose=options.verbose);
    if strlength(value) == 0
        if options.verbose
            fprintf(2,"MW_ORG_ID environment variable not set, unable to set org_id configuration field.\n");
        end
    else
        databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "org_id", value, cfgFile=cfgFile, verbose=false);
    end

    value = getRuntimeContextEnvVar("MW_CLUSTER_ID", verbose=options.verbose);
    if strlength(value) == 0
        if options.verbose
            fprintf(2,"MW_CLUSTER_ID environment variable not set, unable to set cluster_id configuration field.\n");
        end
    else
        updateClusterId(value);
    end

    value = getRuntimeContextEnvVar("MW_API_TOKEN_B64", verbose=options.verbose);
    % PAT or default should have a token field
    if (isfield(options, "authMethod") && options.authMethod == "PAT") || ~isfield(options,"authMethod")
        if strlength(value) > 0
            if options.verbose
                fprintf("Overwriting token, if set, with base64 decoded value from: MW_API_TOKEN_B64")
            end
            databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "token", char(matlab.net.base64decode(value)), cfgFile=cfgFile, verbose=false);
        end
    end
end


function value = getRuntimeContextEnvVar(name, options)
    arguments
        name string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    charValue = getenv(name);
    if isempty(charValue)
        value = "";
        if options.verbose
            fprintf(2, "Environment variable not set: %s\n", name);
        end
    else
        value = string(charValue);
    end
end


function settingsFile = getAndProvisionSettingsFile(options)
    arguments
        options.settingsFile string = databricks.internal.settings.Settings.getSettingsFileReadPath % can return ""
        options.verbose (1,1) logical = true
    end

    if ~isfield(options, "settingsFile")
        error("DATABRICKS:CONFIGURESETTINGSANDCFG", "Expected the options.settingsFile value to have a set or default value");
    end

    if isfile(options.settingsFile)
        if options.verbose
            fprintf("Found existing settings file: %s\n", options.settingsFile);
        end
        settingsFile = options.settingsFile;
    else
        templateSrc = matlab.internal.databricksRoot("config", "databricks-settings.json.template");
        writePath = databricks.internal.settings.Settings.getSettingsFileWritePath;
        if options.verbose
            fprintf("No existing settings file found, copying template to: %s\n", writePath);
        end
        [status, msg] = copyfile(templateSrc, writePath);
        if status == 0
            error("DATABRICKS:CONFIGURESETTINGSANDCFG", "Failed to copy template settings: %s to specified path: %s, Message: %s", templateSrc, writePath, msg);
        else
            settingsFile = writePath;
        end
    end
end


function cfgFile = getAndProvisionConfigurationFile(options)
    % getAndProvisionConfigurationFile If the configuration file exists returns its path
    % Otherwise copy the template file into place
    arguments
        options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath()
        options.verbose (1,1) logical = true
    end

    if ~isfield(options, "cfgFile")
        error("DATABRICKS:CONFIGURESETTINGSANDCFG", "Expected the options.cfgFile value to have a set or default value");
    end

    if isfile(options.cfgFile)
        if options.verbose
            fprintf("Found existing configuration file: %s\n", options.cfgFile);
        end
        cfgFile = options.cfgFile;
    else
        if options.verbose
            fprintf("No existing configuration file found, copying template to: %s\n", options.cfgFile);
        end
        templateSrc = databricksRoot("config", "databrickscfg.template");
        [status, msg] = copyfile(templateSrc, options.cfgFile);
        if status == 0
            error("DATABRICKS:CONFIGURESETTINGSANDCFG", "Failed to copy template configuration: %s to specified path: %s, Message: %s", templateSrc, options.cfgFile, msg);
        else
            cfgFile = options.cfgFile;
        end
    end
end
