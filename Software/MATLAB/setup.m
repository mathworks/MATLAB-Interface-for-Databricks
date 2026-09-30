function setup(options)
    % SETUP Top-level function to step through the interface's setup process
    % This function takes the role of install.m in previous releases.
    % The function does not support non interactive use.
    %
    % If specifying a preferred authMethod this should also be chosen when
    % populating the configuration file.
    %
    % A number of optional arguments are supported.
    %
    % Admin mode functionality is no longer supported in setup, the equivalent
    % functionality is supported via the MATLAB on Databricks Reference Architecture
    % See: https://github.com/mathworks-ref-arch/matlab-on-databricks

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        % Top-level options
        options.adminMode (1,1) logical
        options.updateUserSettings (1,1) logical
        options.configureRuntimes (1,1) logical
        options.generatePolicies (1,1) logical
        options.configureJDBC (1,1) logical = true
        options.configureDBC (1,1) logical
        options.archiveSettings (1,1) logical = false

        % General
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.releases string {mustBeNonzeroLengthText}

        % Databricks Connect
        options.alternativeRepo string {mustBeTextScalar, mustBeNonzeroLengthText}

        % Auth
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod

        % Policies
        options.filterNonUC (1,1) logical = true
        options.filterNonLTS (1,1) logical = true
        options.filterML (1,1) logical = false
        options.filterGPU (1,1) logical = false
        options.policySetupGuide string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.logPath string = "dbfs:/cluster-logs"

        % Runtimes
        options.overwriteInitscript (1,1) logical
        options.overwriteJavabuilder (1,1) logical
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.acceptRuntimeLicense (1,1) logical
        options.cachedTokenPaths string {mustBeNonzeroLengthText}

        % Misc
        options.skipPathCheck (1,1) logical = false % Only applies on Windows
        options.skipUpdateCheck (1,1) logical = false
        options.skipPlatformCheck (1,1) logical = false
        options.verbose (1,1) logical = true
    end

    printBanner("MATLAB interface for Databricks setup");
    fprintf("\n");

    if isMATLABReleaseOlderThan("R2022b")
        fprintf(2, "This package requires MATLAB R2022b or later\n.");
        return; % will likely hit a hard error at a later point
    end

    batchModeError(); % Error, this should not fail silently

    %% Settings & cfg
    thisDir = cd(fullfile(fileparts(mfilename('fullpath')), "app", "functions"));
    cleanUp = onCleanup(@() cd(thisDir));
    addDatabricksPaths(verbose=options.verbose);
    clear('cleanUp');

    % If on Databricks use onDatabricksSetup instead
    if ~options.skipPlatformCheck
        if databricks.internal.isOnDatabricks()
            fprintf("setup is not used when MATLAB is run *on* Databricks.\n");
            fprintf("When the environment is fully configured, onDatabricksSetup is executed\n");
            fprintf("automatically at startup and performs the setup like steps.\n");
            fprintf("\n");
            fprintf("If setup is required use the skipPlatformCheck=true argument.");
            return;
        end
    end

    % Can error(), do after startup to get namespace & startup's check for a JVM
    databricks.internal.checks.checkJavaUserHome();

    if ~isfield(options, "initscript")
        % Can set this default in args block because databricksRoot is not
        % on the MATLAB path pre startup
        options.initscript = databricksRoot("script", "runtime_install.sh");
    end

    % Windows path handle check
    if ispc
        if ~options.skipPathCheck
            if ~matlab.utils.internal.testLongPath(verbose=false)
                if ~matlab.databricks.setup.depthCheck()
                    fprintf("Exiting setup.\n");
                    return;
                end
            end
        end
    end

    % Handle DBFS mex file
    databricks.internal.checks.setBase64Pref(verbose=false);

    if options.archiveSettings
        fprintf("Archiving settings files prior to setup.\n");
        matlab.databricks.setup.archiveSettingsFiles();
    end

    if ~options.skipUpdateCheck
        fprintf("\nChecking for updates.\n");
        databricks.internal.utils.newVersionCheck(forceCheck=true, verbose=options.verbose);
    end

    % Display setup doc location, open top-level doc at the end
    docPath = databricksRoot(-2, "Documentation", "html", "Setup.html");
    fprintf("\n");
    if isfile(docPath)
        fprintf("For setup documentation in HTML format see:\n");
        fprintf("  %s\n", docPath);
    else
        mdDoc = databricksRoot(-2, "Documentation", "Setup.md");
        fprintf("For setup documentation in Markdown format see:\n");
        fprintf("  %s\n", mdDoc);
    end

    % Check for key toolboxes
    databricks.internal.checks.checkCompiler();
    databricks.internal.checks.checkCompilerSDK();
    databricks.internal.checks.checkDatabaseToolbox();

    % Check for legacy Databricks Connect jars
    matlab.databricks.setup.internal.checkDBCJCP();

    fprintf("\n[Tip: Use the mouse to select, copy and paste any displayed links. ]\n");
    fprintf(  "[                     Press any key to continue.                   ]\n\n");
    pause

    %% Admin mode
    if isfield(options, "adminMode")
        fprintf(2, "Admin mode functionality is no longer supported in setup, the equivalent\n");
        fprintf(2, "functionality is supported via the MATLAB on Databricks Reference Architecture.\n");
        fprintf(2, "See: %s\n", matlab.utils.URL2Link("https://github.com/mathworks-ref-arch/matlab-on-databricks"));
        fprintf(2, "Support for the adminMode argument will be removed in a future release.\n");
        return;
    else
        fprintf("Server side setup steps previously available via the admin mode are no longer supported in setup.\n")
        fprintf("Equivalent functionality is supported via the MATLAB on Databricks Reference Architecture\n");
        fprintf("See: %s\n", matlab.utils.URL2Link("https://github.com/mathworks-ref-arch/matlab-on-databricks"));
        adminMode =false;
    end

    %% User Settings
    if isfield(options, "updateUserSettings")
        doSettingsAndCfg = options.updateUserSettings;
    else
        prompt = "Configure user settings and configuration details";
        doSettingsAndCfg = matlab.utils.ynQuestion(prompt, "Y", preamble=" ");
    end
    if doSettingsAndCfg
        % Delete any existing cached tokens as cleanup but also to force a full auth flow
        args = matlab.utils.addArgs(options, "cachedTokenPaths");
        matlab.databricks.setup.deleteAuthTokens("verbose", false, args{:});

        args = matlab.utils.addArgs(options, ["cfgFile", "settingsFile", "profileName", "verbose"]);
        [settingsFile, cfgFile] = matlab.databricks.setup.configureSettingsAndCfg(args{:}); %#ok<ASGLU>
    end

    %% JDBC
    % if isfield(options, "configureJDBC")
    %     JDBCReady = matlab.databricks.setup.configureJDBC(); %#ok<NASGU>
    % end
    
    %% Databricks Connect
    if isfield(options, "configureDBC")
        doDBC = options.configureDBC;
    else
        preamble = sprintf("\nDatabricks Connect can be used to make interactive Spark API calls from MATLAB.\n");
        preamble = preamble + sprintf("This requires Python 3.10, 3.11 or 3.12 and pip to be installed.");
        prompt = sprintf("\nConfigure Databricks Connect");
        doDBC = matlab.utils.ynQuestion(prompt, "Y", preamble=preamble);
    end
    if doDBC
        if databricks.internal.isOnDatabricks()
            pp = string(getenv("DATABRICKS_ROOT_VIRTUALENV_ENV"));
            if isempty(pp) || strlength(pp) == 0
                fprintf(2, "DATABRICKS_ROOT_VIRTUALENV_ENV environment variable not set on Databricks.");
                return;
            end
            pp = fullfile(pp, "bin", "python"); % Databricks Python paths don't use python3 but it is still created in the venv
            args = matlab.utils.addArgs(options, "alternativeRepo");
            matlab.databricks.setup.configureDBC("pythonExecutable", pp, args{:});
        else
            args = matlab.utils.addArgs(options, "alternativeRepo");
            matlab.databricks.setup.configureDBC(args{:});
        end
    end

    %% Accept T&Cs
    args = matlab.utils.addArgs(options, ["verbose", "acceptRuntimeLicense", "initscript"]);
    acceptRuntimeLicenseTf = matlab.databricks.setup.acceptRuntimeTCs(args{:});

    %% Runtimes
    releases = string.empty;
    if adminMode
        if acceptRuntimeLicenseTf
            if isfield(options, "configureRuntimes")
                doConfigureRuntimes = options.configureRuntimes;
            else
                args = matlab.utils.addArgs(options, "settingsFile");
                volPath = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory", args{:});
                prompt = sprintf("Configure MATLAB runtimes to use: [%s]", volPath);
                doConfigureRuntimes = matlab.utils.ynQuestion(prompt, "Y", preamble=" ");
            end
            if doConfigureRuntimes
                if isfield(options, "releases")
                    releases = options.releases;
                else
                    releases = matlab.databricks.setup.askForReleaseList;
                end
                args = {"acceptRuntimeLicense", acceptRuntimeLicenseTf, "releases", releases};
                args = matlab.utils.addArgs(options, ["interfaceDirectory", "verbose", "profileName",...
                    "authMethod", "overwriteInitscript", "overwriteJavabuilder", "initscript"], args);
                matlab.databricks.setup.configureRuntimes(args{:});
            end
        else
            fprintf("MATLAB runtime configuration cannot proceed without accepting the MATLAB runtime license.\n");
        end
    end

    %% Polices
    if adminMode
        if isfield(options, "generatePolicies")
            doPolicies = options.generatePolicies;
        else
            preamble = sprintf("\nPolicies can be used to add preconfigured MATLAB entries to the Databricks Compute interface.");
            prompt = "Generate policy details";
            doPolicies = matlab.utils.ynQuestion(prompt, "Y", preamble=preamble);
        end
        if doPolicies
            if isempty(releases)
                if isfield(options, "releases")
                    releases = options.releases;
                else
                    % TODO dynamically get runtime from files in /Volumes
                    releases = matlab.databricks.setup.askForReleaseList;
                end
            end
            args = {"releases", releases};
            args = matlab.utils.addArgs(options, ["interfaceDirectory", "filterNonUC", "filterNonLTS", "filterML",...
                "filterGPU", "policySetupGuide", "authMethod", "profileName", "verbose"], args);
            matlab.databricks.setup.createClusterPolicies(args{:});
        end
    end

    %% Done
    setupComplete();
end


function setupComplete()
    fprintf("\n");
    docPath = databricksRoot(-2, "Documentation", "html", "index.html");
    if isfile(docPath)
        fprintf("For documentation in HTML format see:\n");
        fprintf("  %s\n", matlab.utils.URL2Link(docPath));
        web(docPath);
    else
        mdDoc = databricksRoot(-2, "Documentation", "README.md");
        fprintf("For documentation in Markdown format see:\n");
        fprintf("  %s\n", matlab.utils.editLink(mdDoc));
        if ~isMATLABReleaseOlderThan("R2025a")
            edit(mdDoc);
        end
    end
    fprintf("Setup complete.\n");
end


function printBanner(str, options)
    arguments
        str string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.leadingNewline (1,1) logical = true
    end

    if options.leadingNewline
        fprintf("\n");
    end
    disp([char(str), newline,repmat('-',1,strlength(str))]);
end


function batchModeError()
    if batchStartupOptionUsed
        % Error because this should not fail silently
        error('DATABRICKS:SETUP', 'Setup does not support running MATLAB in batch mode.');
    end
end
