function releases = configureRuntimes(options)
    % CONFIGURERUNTIMES Provision MATLAB runtimes and associated files on Databricks

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.releases string {mustBeNonzeroLengthText}

        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod

        options.overwriteInitscript (1,1) logical
        options.overwriteJavabuilder (1,1) logical
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText} = databricksRoot("script", "runtime_install.sh")
        options.acceptRuntimeLicense (1,1) logical = false
        options.verbose (1,1) logical = true
    end

    if ~options.acceptRuntimeLicense
        fprintf(2, "MATLAB runtime configuration cannot proceed without accepting the MATLAB runtime license.\n");
        return;
    end

    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error("interfaceDirectory settings field not set");
        end
    end

    if isfield(options, "releases")
        releases = options.releases;
    else
        releases = matlab.databricks.setup.askForReleaseList();
    end

    % Do after setSettingsAndCfg to have auth credentials
    args = {"releases", releases};
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"], args);
    matlab.databricks.setup.provisionMATLABRuntimes("interfaceDirectory", interfaceDirectory, args{:})

    % Do after provision runtime so directory is created
    % do after acceptance of runtime license so local init script is updated
    if isfield(options, "overwriteInitscript")
        args = {"overwrite", true};
    else
        args = {};
    end
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose", "initscript"], args);
    initTf = matlab.databricks.setup.uploadInitscript("interfaceDirectory", interfaceDirectory, args{:}); %#ok<NASGU>

    % Do after provision runtime so directory is created
    if isfield(options, "overwriteJavabuilder")
        args = {"overwrite", true};
    else
        args = {};
    end
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"], args);
    javabuilderTf = matlab.databricks.setup.provisionJavabuilderJars("interfaceDirectory", interfaceDirectory, args{:}); %#ok<NASGU>

    % Skip allowlist configuration as this only applies to Shared cluster that we're not supporting.

    % % Configure Javabuilder and the init script on the allowlist
    % args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"], args);
    % matlab.databricks.setup.internal.configureAllowlist("interfaceDirectory", interfaceDirectory, args{:});
end


