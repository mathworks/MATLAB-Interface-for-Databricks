function result = getPkgSettings(options)
    % GETPKGSETTINGS Returns settings relating to the package's internal operation
    % This is generally not updated by end users.
    % The operation and of this feature and the corresponding settings file is
    % subject to change without notice.
    %
    % Example:
    %   defaultDatabricksRuntime = matlab.databricks.internal.pkgsettings.getPkgSettings(field="defaultDatabricksRuntime")
    %
    %   allSettings = matlab.databricks.internal.pkgsettings.getPkgSettings
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.field string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Ships with the package should always be here
    settingsFile = databricksRoot("config", "package-settings.json");
    if ~isfile(settingsFile)
        error("Package settings file not found: %s", settingsFile);
    end

    % Assume jsondecode can handle the content
    try
        s = jsondecode(fileread(settingsFile));
    catch ME
        error("Failed to read package settings file: %s\nMessage: %s", settingsFile, ME.message)
    end

    if isfield(s, "supportedDatabricksRuntimes")
         for n = 1:numel(s.supportedDatabricksRuntimes)
            s.supportedDatabricksRuntimes(n).version = string(s.supportedDatabricksRuntimes(n).version);
            s.supportedDatabricksRuntimes(n).pythonVersion = string(s.supportedDatabricksRuntimes(n).pythonVersion);
         end
    else
        fprintf(2, "supportedDatabricksRuntimes field not found in: %s\n", settingsFile);
    end

    if isfield(s, "supportedMATLABReleases")
        for n = 1:numel(s.supportedMATLABReleases)
            s.supportedMATLABReleases(n).release = string(s.supportedMATLABReleases(n).release);
            s.supportedMATLABReleases(n).runtimeURL = string(s.supportedMATLABReleases(n).runtimeURL);
        end
    else
        fprintf(2, "supportedMATLABReleases field not found in: %s\n", settingsFile);
    end

    if isfield(s, "defaultDatabricksRuntime")
        s.defaultDatabricksRuntime = string(s.defaultDatabricksRuntime);
    else
        fprintf(2, "defaultDatabricksRuntime field not found in: %s\n", settingsFile);
    end

    if isfield(s, "jdbcDriverInfo")
        if isfield(s.jdbcDriverInfo, "downloadUrl")
            s.jdbcDriverInfo.downloadUrl = string(s.jdbcDriverInfo.downloadUrl);
        end
        if isfield(s.jdbcDriverInfo, "docUrl")
            s.jdbcDriverInfo.docUrl = string(s.jdbcDriverInfo.docUrl);
        end
        if isfield(s.jdbcDriverInfo, "version")
            s.jdbcDriverInfo.version = string(s.jdbcDriverInfo.version);
        end
        if isfield(s.jdbcDriverInfo, "artifactId")
            s.jdbcDriverInfo.artifactId = string(s.jdbcDriverInfo.artifactId);
        end
        if isfield(s.jdbcDriverInfo, "zip42")
            s.jdbcDriverInfo.zip42 = string(s.jdbcDriverInfo.zip42);
        end
    end

    if isfield(options, "field")
        if isfield(s, options.field)
            result = s.(options.field);
        else
            error("Package settings file does not contain a field: %s", options.field);
        end
    else
        result = s;
    end
end