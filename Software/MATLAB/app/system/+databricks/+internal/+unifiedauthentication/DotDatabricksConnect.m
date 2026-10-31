classdef DotDatabricksConnect < databricks.Object
    % DotDatabricksConnect Container class for .databricks-connect file related functionality

    % Copyright 2024 MathWorks, Inc.

    properties
    end

    methods
        function obj = DotDatabricksConnect(~, varargin)
            % Constructor
            fprintf(2, ".databricks-connect based authentication is no longer supported.\n");
            fprintf(2, "It cannot be used and this class will be fully removed in future without notice.\n");
        end


        function setProperty(config, propName, propValue)
            
            % Check if this is a property and if not add it
            p = findprop(config, propName);
            if isempty(p)
                addprop(config, propName);
            end
            config.(propName) = propValue;
        end


        function inputProperty(config, propName, prompt, options)
            % inputProperty Ask for property value, set default otherwise

            arguments
                config (1,1) databricks.internal.unifiedauthentication.DotDatabricksConnect
                propName string {mustBeTextScalar, mustBeNonzeroLengthText}
                prompt string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.default string {mustBeTextScalar} % Can be ""
                options.placeHolder string {mustBeTextScalar} = "No existing or default value"
                options.displayDefaultValue (1,1) logical = true
            end

            % Prompts for user input so error if mistakenly deployed to avoid an unintended hang waiting for input
            matlab.databricks.internal.deployedInputError();

            % Check if this is a property and if not add it
            p = findprop(config, propName);
            if isempty(p)
                addprop(config, propName);
            end

            if isfield(options, "default")
                default = options.default;
            elseif ~isempty(config.(propName))
                default = config.(propName);
            else
                default = options.placeHolder;
            end
            
            if options.displayDefaultValue
                displayDefault = default;
            else
                displayDefault = "REDACTED";
            end

            promptStr = sprintf("%s [%s]: ", prompt, displayDefault);
            promptStr = replace(promptStr, "\", "\\");

            configVal = strtrim(input(promptStr, 's'));
            if isempty(configVal)
                config.(propName) = default;
            else
                config.(propName) = configVal;
            end
        end


        function initialize(obj, options)
            % INITIALIZE Method to initialize the configuration
            % Find the .databricks-connect if one exists
            arguments
                obj
                options.dbcFile string = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
                options.verbose (1,1) logical = true
            end

            % Check if we have a databricks-connect file
            if exist(options.dbcFile, 'file')
                configData = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct(dbcFile=options.dbcFile, verbose=options.verbose);
                % Configure the object's properties given the configData
                fNames = fieldnames(configData);
                for fCount = 1:numel(fNames)
                    if ~isprop(obj,fNames{fCount})
                        addprop(obj,fNames{fCount});
                    end
                    obj.(fNames{fCount}) = configData.(fNames{fCount});
                end
            end
        end %function
    end


    methods(Static)
        function dbcFile = getDBCFilePath()
            dbcFile = char(fullfile(matlab.utils.getHomeDirectory(), '.databricks-connect'));
        end


        function [tf, dbcFile] = isDotDatabricksConnect
            % isDotDatabricksConnect Returns true if a .databricks-connect format file is present
            %
            % Example:
            %   [tf, filepath] = databricks.internal.unifiedauthentication.DotDatabricksConnect.isDotDatabricksConnect

            dbcFile = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath();
            tf = isfile(dbcFile);
        end


        function tf = writeDBCCfgFile(cfg, options)
            % writeDBCCfgFile Write a Databricks Connect configuration file in JSON format
            arguments
                cfg (1,1) struct 
                options.dbcFile string = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
                options.verbose (1,1) logical = true
            end

            [dbcFid, errmsg] = fopen(options.dbcFile,'w');
            if dbcFid == -1
                error('Error: Could not write to: %s\nMessage: %s', options.dbcFile, errmsg);
            end
            closeAfter = onCleanup(@() fclose(dbcFid));
            fprintf(dbcFid, '%s', jsonencode(cfg, PrettyPrint=true));
            if options.verbose
                fprintf('Save configuration file: %s\n', options.dbcFile);
            end
            tf = true;
        end


        function tf = writeDBCCfgFields(options)
            % writeDBCCfgFields Write a Databricks Connect configuration file in JSON format
            arguments
                options.dbcFile string = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
                options.verbose (1,1) logical = true
                % File fields:
                options.cluster_id string {mustBeTextScalar}
                options.org_id string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.token string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            initialCfg = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct;
            newCfg = initialCfg;

            if isfield(options, 'cluster_id')
                newCfg.cluster_id = options.cluster_id;
            end
            if isfield(options, 'org_id')
                newCfg.org_id = options.org_id;
            end
            if isfield(options, 'port')
                newCfg.port = options.port;
            end
            if isfield(options, 'host')
                newCfg.host = options.host;
            end
            if isfield(options, 'token')
                newCfg.token = options.token;
            end

            tf = databricks.internal.unifiedauthentication.DotDatabricksConnect.writeDBCCfgFile(newCfg, verbose=options.verbose);
        end


        function value = getDBCCfgField(fieldName, options)
            arguments
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.dbcFile string = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
                options.enableEnvVarOverrides (1,1) logical = true
                options.verbose (1,1) logical = true
            end

            dbcCfg = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct(dbcFile=options.dbcFile, enableEnvVarOverrides=options.enableEnvVarOverrides, verbose=options.verbose);
            if isfield(dbcCfg, fieldName)
                if ischar(dbcCfg.(fieldName)) || isStringScalar(dbcCfg.(fieldName))
                    value = string(dbcCfg.(fieldName));
                else
                    error("DATABRICKS:getDBCCfgField", "%s field is not scalar text: %s", options.getDBCFilePath, fieldName);
                end
            else
                if options.verbose
                    fprintf("Field not found: %s\n", fieldName);
                end
                value = string.empty;
            end
        end


        function dbcCfg = getDBCCfgStruct(options)
            arguments
                options.dbcFile string = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
                options.enableEnvVarOverrides (1,1) logical = true
                options.verbose (1,1) logical = true
            end

            if isfile(options.dbcFile)
                try
                    cfg = jsondecode(fileread(options.dbcFile));
                catch ME
                    fprintf("Failed to read Databricks Connect JSON configuration file: %s\nMessage: %s\n", options.dbcFile, ME.message);
                    error("DATABRICKS:NODOTDATABRICKSCONNECTFILE", "Failed to read Databricks Connect JSON configuration file\n");
                end
            else
                cfg = struct;
            end

            if options.enableEnvVarOverrides
                dbcCfg = databricks.internal.unifiedauthentication.DotDatabricksConnect.setCfgFieldFromEnvironment(cfg, 'cluster_id', 'DATABRICKS_CLUSTER_ID', verbose=options.verbose);
            end
        end


        function cfg = setCfgFieldFromEnvironment(cfg, fieldName, variableName, options)
            % setCfgFieldFromEnvironment Override a configuration field with an environment variable if set
            % If the environment variable is not set the input struct is returned unchanged
            % Fields are returned as scalar strings.
            
            arguments
                cfg (1,1) struct
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                variableName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
        
            envVarValue = getenv(variableName);
            if ~isempty(envVarValue)
                if isfield(cfg, fieldName)
                    if ~strcmp(cfg.(fieldName), envVarValue)
                        if options.verbose
                            fprintf("Overriding configuration field: %s, with %s environment variable value: %s\n",...
                                fieldName, variableName, envVarValue);
                        end
                        cfg.(fieldName) = string(envVarValue);
                    end
                else
                    if options.verbose
                        fprintf("Setting field: %s based on environment variable: %s, value %s\n", fieldName, variableName, envVarValue);
                    end
                    cfg.(fieldName) = string(envVarValue);
                end
            end
        end
    end
end