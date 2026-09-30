classdef Settings
    % Settings Container class for Settings related functionality
    % Settings are stored in the databricks-settings.json file
    % For more details see: Documentation/Setup.md, Documentation/Authentication.md

    % To be further refactored in a future release
    
    % Copyright 2024-2026 MathWorks, Inc.

    properties
    end

    methods
        function obj = Settings()
        end
    end

    methods(Static)
        function settingsFilePath = getSettingsFileReadPath()
            % getSettingsFilePath Returns the path to the the Databricks settings file
            % First the environment variable DATABRICKS_SETTINGS_FILE is checked,
            % then the default location (prefdir) and then the MATLAB path as defined
            % by the exist() command.
            % The value is returned as a character vector.
            % If the file is not found an empty character vector is returned.
            % To get the path to write settings to use: getSettingsFileWritePath
            %
            % Example
            %   path = databricks.internal.settings.Settings.getSettingsFileReadPath()

            settingsFileEnvVar = getenv('DATABRICKS_SETTINGS_FILE');
            if isempty(settingsFileEnvVar)
                defaultPath = databricks.internal.settings.Settings.getDefaultSettingsFilePath();
                if isfile(defaultPath)
                    settingsFilePath = char(defaultPath);
                else
                    if exist('databricks-settings.json', 'file') == 2
                        settingsFilePath = which('databricks-settings.json');
                    else
                        settingsFilePath = '';
                    end
                end
            else
                if isfile(settingsFileEnvVar)
                    settingsFilePath = char(settingsFileEnvVar);
                else
                    settingsFilePath = '';
                end
            end
        end


        function defaultSettingsFilePath = getDefaultSettingsFilePath()
            % defaultSettingsFilePath Returns the default path for the Databricks settings file
            % The current name for the file is databricks-settings.json
            % The current default directory is given by the prefdir command.
            % The value is returned as a character vector.
            % To get the path to write settings to use: getSettingsFileWritePath

            if ~isdeployed
                defaultSettingsFilePath = char(fullfile(prefdir, 'databricks-settings.json'));
            else
                % Assumes the JSON file is baked into the ctf and on the path
                defaultSettingsFilePath = char(which('databricks-settings.json'));
            end
        end


        function settingsFileWritePath = getSettingsFileWritePath()
            % getSettingsFileWritePath Returns the default path to write Databricks settings file to
            % The current default name for the file is databricks-settings.json and
            % the current default directory is given by the prefdir command
            % unless the DATABRICKS_SETTINGS_FILE is defined.
            % The value is returned as a character vector.

            settingsFileEnvVar = getenv('DATABRICKS_SETTINGS_FILE');
            if isempty(settingsFileEnvVar)
                settingsFileWritePath = char(databricks.internal.settings.Settings.getDefaultSettingsFilePath());
            else
                settingsFileWritePath = char(settingsFileEnvVar);
            end
        end


        function tf = writeSettingsStruct(settings, options)
            % writeSettingsStruct Writes a struct of settings to a databricks-settings.json file
            % If the file exists and the overwrite flag is not set false is
            % returned.
            % If the file cannot be written otherwise an error is thrown.
            % This function will overwrite all existing settings values.
            % The default file path is given by databricks.internal.settings.Settings.getSettingsFileWritePath.
            %
            % Example:
            %   s = struct;
            %   s.username='someuser@example.com';
            %   s.notificationEmail='notificationAddress@example.com';
            %   tf = databricks.internal.settings.Settings.writeSettingsStruct(s, overwrite=true);

            arguments
                settings (1,1) struct
                options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.settings.Settings.getSettingsFileWritePath
                options.overwrite = false
                options.verbose (1,1) logical = true
            end
        
            if options.verbose
                fprintf("Saving settings to: %s\n", options.settingsFile);
            end
        
            if isfile(options.settingsFile) && ~options.overwrite
                fprintf("Not saving, settings file found and overwrite not enabled: %s\n", options.settingsFile);
                tf = false;
                return;
            end

            [settingsFid, errmsg] = fopen(options.settingsFile,'w');
            if settingsFid == -1
                error('DATABRICKS:writeSettingsStruct', 'Could not write to file: %s\nMessage: %s', options.settingsFile, errmsg);
            else
                closeAfter = onCleanup(@() fclose(settingsFid));
                fprintf(settingsFid, "%s", jsonencode(settings, PrettyPrint=true));
                tf = true;
            end
        end


        function tf = writeDatabricksSettingsFields(options)
            % writeDatabricksSettingsFields Writes a databricks-settings.json file
            % Default output location is given by databricks.internal.settings.Settings.getSettingsFileReadPath
            % As is first reads existing values
            % Existing values not overridden by optional arguments are retained.
            % Overwrite of an existing file by default can be disabled.
            % By default environment variable overrides are applied this can be
            % disabled using enableEnvVarOverrides
            %
            % The follow fields can be set using optional arguments:
            %   autotermination_minutes
            %   vendor
            %   username
            %   notificationEmail
            %   authMethod
            %   profileName
            %   interfaceDirectory
            %   defaultDatabricksRuntime
            %
            % True is returned if the operation completes otherwise false.
                
            arguments
                options.overwrite (1,1) logical = true
                options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.settings.Settings.getSettingsFileReadPath
                options.enableEnvVarOverrides (1,1) logical = true
                options.verbose (1,1) logical = true

                % Fields - Not handling node types for now
                options.autotermination_minutes (1,1) {mustBeNonnegative}
                options.vendor (1,1) matlab.internal.databricks.vendor.Vendor
                options.username string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.notificationEmail string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.authMethod (1,1) matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.defaultDatabricksRuntime string {mustBeTextScalar, mustBeNonzeroLengthText}
                % Last time the package checked for a new version of itself in as as ISO8601 string UTC
                options.newVersionCheckTime string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
        
            if isfile(options.settingsFile) && options.overwrite == false
                fprintf(2, "Databricks settings file found, overwrite not enabled, not updating: %s\n", options.settingsFile);
                tf = false;
                return;
            end

            % Get the existing values
            settingsStruct = databricks.internal.settings.Settings.getSettingsStruct(settingsFile=options.settingsFile, enableEnvVarOverrides=options.enableEnvVarOverrides, verbose=options.verbose);
            % Assume no valid updates have been provided
            fieldSet = false;
            
            % For the following fields overwrite the read in value if set
            if isfield(options, 'autotermination_minutes')
                settingsStruct.autotermination_minutes = options.autotermination_minutes;
                fieldSet = true;
            end
            if isfield(options, 'vendor')
                settingsStruct.vendor = lower(string(options.vendor));
                fieldSet = true;
            end
            if isfield(options, 'username')
                settingsStruct.username = options.username;
                fieldSet = true;
            end
            if isfield(options, 'notificationEmail')
                settingsStruct.notificationEmail = options.notificationEmail;
                fieldSet = true;
            end
            if isfield(options, 'authMethod')
                settingsStruct.authMethod = string(options.authMethod);
                fieldSet = true;
            end
            if isfield(options, 'profileName')
                settingsStruct.profileName = options.profileName;
                fieldSet = true;
            end
            if isfield(options, 'interfaceDirectory')
                settingsStruct.interfaceDirectory = options.interfaceDirectory;
                fieldSet = true;
            end
            if isfield(options, 'defaultDatabricksRuntime')
                settingsStruct.defaultDatabricksRuntime = options.defaultDatabricksRuntime;
                fieldSet = true;
            end
            if isfield(options, 'newVersionCheckTime')
                settingsStruct.newVersionCheckTime = options.newVersionCheckTime;
                fieldSet = true;
            end
                    
            % Check that at least one field got an update
            if ~fieldSet
                fprintf(2, "No valid settings field set, not updating: %s\n", options.settingsFile);
                tf = false;
                return;
            end

            if options.verbose
                fprintf("Writing settings file: %s\n", options.settingsFile);
            end
            tf = databricks.internal.settings.Settings.writeSettingsStruct(settingsStruct, settingsFile=options.settingsFile, overwrite=options.overwrite, verbose=options.verbose);
        end


        function editUserSettings(options)
            arguments
                options.settingsFile string = databricks.internal.settings.Settings.getSettingsFileReadPath()
            end

            if isempty(options.settingsFile) || ~isscalar(options.settingsFile) || strlength(options.settingsFile) == 0
                filePath = databricks.internal.settings.Settings.getSettingsFileWritePath;
                fprintf('Existing settings file not found, using: %s', filePath);
            else
                filePath = options.settingsFile;
            end

            if batchStartupOptionUsed
                error('DATABRICKS:EDITUSERSETTINGS', 'MATLAB started in batch mode, unable to edit settings file interactively: %s', filePath);
            else
                if isdeployed
                    error('DATABRICKS:EDITUSERSETTINGS', 'Cannot not open settings file: %s for editing in deployed mode', filePath);
                else
                    edit(filePath);
                end
            end
        end


        function settings = getSettingsStruct(options)
            % getSettings Retrieve user settings from settings file
            % The logical enableEnvVarOverrides (true by default) enables the overrides:
            %   DATABRICKS_VENDOR overrides vendor
            %   DATABRICKS_CONFIG_PROFILE overrides profileName
            %
            % The default settings file path is given by databricks.internal.settings.Settings.getSettingsFileReadPath
            % A struct is returned.
            %
            % Example:
            %   settings = databricks.internal.settings.Settings.getSettingsStruct()
            
            arguments
                options.settingsFile string = databricks.internal.settings.Settings.getSettingsFileReadPath
                options.enableEnvVarOverrides (1,1) logical = true
                options.verbose (1,1) logical = false
            end

            if isfile(options.settingsFile)
                try
                    settings = jsondecode(fileread(options.settingsFile));
                catch ME
                    fprintf("Failed to read JSON settings file: %s\nMessage: %s\n", options.settingsFile, ME.message);
                    fprintf("Opening the file in the MATLAB editor\n");
                    % editUserSettings handles batch and deployed mode cases
                    databricks.internal.settings.Settings.editUserSettings(settingsFile=options.settingsFile);
                    error("DATABRICKS:getSettingsStruct", "Failed to read JSON settings file\n");
                end
            else
                templateSettingsFile = matlab.internal.databricksRoot("config", "databricks-settings.json.template");
                fprintf(2, "JSON settings file not found: %s\n", options.settingsFile);
                if isfile(templateSettingsFile)
                    newSettingsFile = databricks.internal.settings.Settings.getSettingsFileWritePath;
                    fprintf(2, "Copying template settings file to: %s and opening in the MATLAB editor for customization\n", newSettingsFile);
                    copyfile(templateSettingsFile, newSettingsFile);
                    databricks.internal.settings.Settings.editUserSettings(settingsFile=newSettingsFile);
                else
                    fprintf(2, "JSON settings template file not found: %s\n", templateSettingsFile);
                end
                error("DATABRICKS:getSettingsStruct", "JSON settings file not found\n");
            end
           
            % Assuming the a file is found and read override values with defined env var values
            % This may be used in testing and certain other edge cases
            if options.enableEnvVarOverrides
                settings = databricks.internal.settings.Settings.setSettingsFieldFromEnvironment(settings, 'vendor', 'DATABRICKS_VENDOR', verbose=options.verbose);
                settings = databricks.internal.settings.Settings.setSettingsFieldFromEnvironment(settings, 'profileName', 'DATABRICKS_CONFIG_PROFILE', verbose=options.verbose);
            end
            
            if isfield(settings, 'authMethod')
                try
                    settings.authMethod = matlab.internal.databricks.AuthMethod(settings.authMethod);
                catch
                    fprintf("Could not convert settings file value: %s, to a matlab.internal.databricks.AuthMethod enumeration.\n", settings.authMethod);
                    settings.authMethod = matlab.internal.databricks.AuthMethod.empty;
                end
            end
        end


        function value = getSettingsField(fieldName, options)
            % getSettingsField Returns a field from user settings if it exists
            % If it does not exist an empty string is returned.
            % Otherwise the settings field is returned.
            % Environment overrides variable will be applied by default.
            % The optional enableEnvVarOverrides flag can be set to false to disable this.
            % An authMethod field is returned as a matlab.internal.databricks.AuthMethod
            %
            % Example:
            %   vendor = databricks.internal.settings.Settings.getSettingsField("vendor");
            %
            % If a settings struct is provided it is used rather than reading a file and or
            % environment variables.
            
            arguments
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.settingsFile string = databricks.internal.settings.Settings.getSettingsFileReadPath
                options.enableEnvVarOverrides (1,1) logical = true
                options.settings (1,1) struct
            end

            if isfield(options, "settings")
                settings = options.settings;
            else
                settings = databricks.internal.settings.Settings.getSettingsStruct(settingsFile=options.settingsFile, enableEnvVarOverrides=options.enableEnvVarOverrides);
            end

            if isfield(settings, fieldName)
                value = settings.(fieldName);
            else
                value = string.empty;
            end
        end

        
        function settings = setSettingsFieldFromEnvironment(settings, fieldName, variableName, options)
            % setSettingsFieldFromEnvironment Override a settings field with an environment variable if set
            % If the environment variable is not set the input struct is returned unchanged
            % Fields are returned as scalar strings.
            
            arguments
                settings (1,1) struct
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                variableName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
        
            envVarValue = getenv(variableName);
            if ~isempty(envVarValue)
                if isfield(settings, fieldName)
                    if ~strcmp(settings.(fieldName), envVarValue)
                        if options.verbose
                            fprintf("Overriding settings field: %s, with %s environment variable value: %s\n",...
                                fieldName, variableName, envVarValue);
                        end
                        settings.(fieldName) = string(envVarValue);
                    end
                else
                    if options.verbose
                        fprintf("Setting field: %s based on environment variable: %s, value %s\n", fieldName, variableName, envVarValue);
                    end
                    settings.(fieldName) = string(envVarValue);
                end
            end
        end
    end
end