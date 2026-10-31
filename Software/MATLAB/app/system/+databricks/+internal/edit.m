function filename = edit(target)
    % edit Edit databricks settings and configuration files based on synonyms
    % Synonyms must be provided as a string array.
    % By default both the default .databrickscfg and databricks-settings.json
    % files are opened.
    %
    % Examples:
    %   % Open the default .databrickscfg file
    %   databricks.internal.edit("cfg")
    %
    %   % Open the default .databricks-settings.json file
    %   databricks.internal.edit("settings")
    %
    %   % Open both the default .databrickscfg and databricks-settings.json files
    %   databricks.internal.edit
    %
    % An string array of file paths is returned, an empty value indicates
    % an error.
    %
    % Deployed mode is not supported.
    %
    % The following arguments are accepted:
    %   "configuration", "cfg", "databrickscfg", ".databrickscfg", "config"
    %   "settings", "databricks-settings", "databricks-settings.json"
    %   "java", "javaclasspath.txt", "classpath", "javaclasspath"

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        target string {mustBeNonzeroLengthText} = ["cfg", "settings"]
    end

    filename = string.empty;

    if isdeployed
        fprintf(2, "Edit is not supported in deployed mode, cannot open: %s\n", join(target, " "));
        return;
    end

    if isempty(target)
        fprintf(2, "No settings or configuration value set.\n");
        return;
    end

    for n = 1:numel(target)
        switch lower(target(n))
            case {"configuration", "cfg", "databrickscfg", ".databrickscfg", "config"}
                filename(n) = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath;

            case {"settings", "databricks-settings", "databricks-settings.json"}
                filename(n) = databricks.internal.settings.Settings.getSettingsFileWritePath;

            case {"java", "javaclasspath.txt", "classpath", "javaclasspath"}
                if isfile(fullfile(pwd, "javaclasspath.txt"))
                    filename(n) = fullfile(pwd, "javaclasspath.txt");
                else
                    filename(n) = fullfile(prefdir, "javaclasspath.txt");
                end

            otherwise
                fprintf(2, "No matching value for: %s\n", target(n));
                filename(n) = string.empty;
        end
        if isempty(filename(n))
            fprintf(2, "Empty path returned for: %s\n", target(n));
        elseif strlength(filename) == 0
            filename(n) = string.empty;
            fprintf(2, "Zero length path returned for: %s\n", target(n));
        else
            edit(filename(n));
        end
    end