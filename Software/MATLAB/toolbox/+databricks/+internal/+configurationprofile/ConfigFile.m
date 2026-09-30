classdef ConfigFile
    % ConfigFile Parser and manager for the .databrickscfg configuration file.
    %
    % The .databrickscfg file is the standard Databricks configuration file
    % used across all Databricks tools (CLI, Python SDK, Go SDK, JDBC/ODBC).
    % It stores one or more named connection profiles containing credentials
    % and workspace URLs (host, token, client_id, etc.). Its default location
    % is ~/.databrickscfg, overridable via the DATABRICKS_CONFIG_FILE env var.
    %
    % ConfigFile parses the INI-style ~/.databrickscfg file into Profile objects,
    % retrieves profiles by name with automatic environment variable overrides
    % (e.g., DATABRICKS_HOST overrides the host field), and resolves the
    % default profile using this priority:
    %   1. DATABRICKS_CONFIG_PROFILE env var
    %   2. profileName from databricks-settings.json
    %   3. Profile named "DEFAULT"
    %   4. First profile in the file
    %
    % Also supports writing/merging profiles back to the file (with backup)
    % and deployed mode (compiled MATLAB apps) with alternate file lookup.
    %
    % Keys are case sensitive.
    %
    % Examples:
    %
    %     % Create a ConfigFile object c from a file, if the argument is a valid
    %     % file it will be read otherwise the argument is assumed to be the
    %     % content
    %     c = databricks.internal.configurationprofile.ConfigFile('myFilePath.txt');
    %
    %     % Return a credentials profile as a struct
    %     profile = c.getProfile('profileName');

    % Copyright 2024-2026 The MathWorks, Inc.

    properties (Hidden)
        SrcData = string.empty;
    end

    properties
        Profiles databricks.internal.configurationprofile.Profile
    end

    methods
        % Constructor
        function obj = ConfigFile(cfgFile)
            % ConfigFile Returns a databricks.internal.configurationprofile.ConfigFile
            % The Profiles property is a struct containing profiles present in the configuration file.
            % The default configuration file name is <home directory>/.databrickscfg
            % If the environment variable DATABRICKS_CONFIG_FILE is set this value overrides the default
            % value or function argument.

            arguments
                cfgFile string {mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath();
            end

            if isMATLABReleaseOlderThan('R2022b')
                error("DATABRICKS:ConfigFile","MATLAB R2022b or later is required");
            end

            if isfile(cfgFile)
                obj.SrcData = fileread(cfgFile);
            else
                error("DATABRICKS:ConfigFile","Configuration file not found: %s\nTo create a configuration file run: %s", cfgFile, matlab.internal.databricksRoot("setup"));
            end

            obj.Profiles = databricks.internal.configurationprofile.ConfigFile.getAllProfiles(obj.SrcData);
        end


        function profile = getProfile(obj, profileName, options)
            % getProfile Returns a profile of a given name or the default profile name
            % If no matching profile exists an empty profile is returned.
            %
            % If profile is found and the optional enableEnvVarOverrides flag is true (default)
            % then the following fields are overridden by the follow environment variables if
            % set:
            %   account_id      DATABRICKS_ACCOUNT_ID
            %   client_id       DATABRICKS_CLIENT_ID
            %   client_secret   DATABRICKS_CLIENT_SECRET
            %   host            DATABRICKS_HOST
            %   token           DATABRICKS_TOKEN
            %   username        DATABRICKS_USERNAME
            %   password        DATABRICKS_PASSWORD
            %   cluster_id      DATABRICKS_CLUSTER_ID
            %
            % Profile names are case sensitive.

            arguments
                obj (1,1) databricks.internal.configurationprofile.ConfigFile
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = obj.getInstanceDefaultProfileName
                options.enableEnvVarOverrides (1,1) logical = true
                options.verbose (1,1) logical = false
            end

            allProfileNames = obj.listProfiles;
            matchResult = matches(allProfileNames, profileName);
            if any(matchResult)
                firstIdx = find(matchResult, 1, 'first');
                if isempty(firstIdx) || firstIdx == 0
                    profile = databricks.internal.configurationprofile.Profile.empty;
                else
                    profile = obj.Profiles(firstIdx);
                end
            else
                profile = databricks.internal.configurationprofile.Profile.empty;
            end

            if ~isempty(profile)
                if options.enableEnvVarOverrides
                    profile = setValueFromEnvironment(profile, "account_id", "DATABRICKS_ACCOUNT_ID", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "client_id", "DATABRICKS_CLIENT_ID", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "client_secret", "DATABRICKS_CLIENT_SECRET", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "host", "DATABRICKS_HOST", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "token", "DATABRICKS_TOKEN", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "username", "DATABRICKS_USERNAME", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "password", "DATABRICKS_PASSWORD", verbose=options.verbose);
                    profile = setValueFromEnvironment(profile, "cluster_id", "DATABRICKS_CLUSTER_ID", verbose=options.verbose);
                end
            end

            if options.verbose && isempty(profile)
                fprintf(2, "Profile not found: %s\n", profileName);
            end
        end

      
        function profileList = listProfiles(obj)
            % listProfiles Returns a string array of profile names
            % If no profiles are found and empty string array is returned.
            % Profile names are case sensitive.

            arguments
                obj (1,1) databricks.internal.configurationprofile.ConfigFile
            end

            profileList = string.empty; % Should not arise
            if ~isempty(obj) && isprop(obj, "Profiles") && ~isempty(obj.Profiles)
                profileList = [(obj.Profiles(:).Name)];
            end
        end


        function tf = isProfile(obj, profileName)
            % isProfile Returns true if a named profile is found otherwise false
            % Profile names are case sensitive.

            arguments
                obj (1,1) databricks.internal.configurationprofile.ConfigFile
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isempty(obj)
                tf = false; % Should not arise
            else
                profileList = obj.listProfiles();
                % Profile names should be unique so there should be at most 1
                % true so any is okay to use
                tf = any(matches(profileList, profileName));
            end
        end


        function profile = getDefaultProfile(obj)
            % getDefaultProfile Returns the default profile
            % A `.databrickscfg` file supports multiple profiles, which profile to use is selected based on the following priority:
            %   1. Many functions support an argument or optional argument typically called `profileName`.
            %   2. The value of the `DATABRICKS_CONFIG_PROFILE` if set.
            %   3. The `profileName` field in the [`databricks-settings.json`](Setup.md) file.
            %   4. The profile named `DEFAULT` if present.
            %   5. The first profile in the file if present.
            %
            % Otherwise an empty databricks.internal.configurationprofile.Profile
            % is returned.
            % Profile names are case sensitive.

            arguments
                obj (1,1) databricks.internal.configurationprofile.ConfigFile
            end

            % Respects DATABRICKS_CONFIG_PROFILE & DATABRICKS_SETTINGS_FILE env vars
            profileName = getInstanceDefaultProfileName(obj);
            profile = obj.getProfile(profileName);
        end


        function profileName = getInstanceDefaultProfileName(obj)
            % getInstanceDefaultProfileName Returns the name of the default profile for the given object
            %
            % A `.databrickscfg` file supports multiple profiles, which profile to use is selected based on the following priority:
            %   1. Many functions support an argument or optional argument typically called `profileName`.
            %   2. The value of the `DATABRICKS_CONFIG_PROFILE` if set.
            %   3. The `profileName` field in the [`databricks-settings.json`](Setup.md) file.
            %   4. The profile named `DEFAULT` if present.
            %   5. The first profile in the file if present.
            %
            % Otherwise an empty databricks.internal.configurationprofile.Profile
            % is returned.
            % Profile names are case sensitive.
            %
            % If one has a profile object for the default profile e.g.: profile = getDefaultProfile(obj)
            % its .Name can be used as an alternative.
            %
            % The static alternative is: databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            % It calls this method in turn.

            arguments
                obj (1,1) databricks.internal.configurationprofile.ConfigFile
            end

            % Respects DATABRICKS_CONFIG_PROFILE & DATABRICKS_SETTINGS_FILE env vars
            settingsProfileName = databricks.internal.settings.Settings.getSettingsField('profileName');
            if ischar(settingsProfileName)
                settingsProfileName = string(settingsProfileName);
            elseif isstring(settingsProfileName)
                % Do nothing
            else
                error("DATABRICKS:ConfigFile","Invalid profileName type, expected char or string, found: %s", class(settingsProfileName));
            end
            if isempty(settingsProfileName) || strlength(settingsProfileName) == 0
                profileList = obj.listProfiles;
                if any(matches(profileList, "DEFAULT"))
                    profileName = "DEFAULT";
                elseif numel(profileList) > 0
                    profileName = profileList(1);
                else
                    profileName = string.empty;
                end
            else
                profileName = settingsProfileName;
            end
        end
    end % methods


    methods (Static)
        function profileName = getDefaultProfileName(options)
            % getDefaultProfileName Returns the name of the default profile
            % The DATABRICKS_CONFIG_PROFILE environment variable is respected.
            % The DATABRICKS_CONFIG_FILE environment variable is respected.
            % The DATABRICKS_SETTINGS_FILE environment variable is respected.
            % If a settings file value is set it is returned.
            % If only one profile is found its name is returned.
            % If a profile named DEFAULT is found it is returned.
            % If a default cannot be determined an empty string is returned.
            % If one has a profile object for the default profile e.g.: profile = getDefaultProfile(obj)
            % its .Name can be used as an alternative.
            %
            % Example:
            %   defaultProfileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile=cfgFile, verbose=true)

            arguments
                options.cfgFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
                options.verbose (1,1) logical = true
            end

            cf = databricks.internal.configurationprofile.ConfigFile(options.cfgFile);
            profileName = cf.getInstanceDefaultProfileName();
        end


        function value = getProfileField(fieldName, options)
            arguments
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cfgFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
                options.verbose (1,1) logical = true
            end

            if isfield(options, 'profileName')
                profileName = options.profileName;
            else
                profileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile = options.cfgFile);
            end

            envValue = databricks.internal.configurationprofile.ConfigFile.getEnvVarValue(fieldName, verbose=options.verbose);
            if isempty(envValue)
                c = databricks.internal.configurationprofile.ConfigFile(options.cfgFile);
                profile = c.getProfile(profileName);
                if isempty(profile)
                    value = string.empty;
                else
                    if isKey(profile, fieldName)
                        value = profile.getValue(fieldName);
                    else
                        value = string.empty;
                    end
                end
            else
                value = envValue;
            end
        end


        function tf = deleteProfileField(fieldName, options)
            % deleteProfileField Deletes a field from a profile in the configuration file
            %
            % Example:
            %   tf = databricks.internal.configurationprofile.ConfigFile.deleteProfileField("cluster_id");
            arguments
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cfgFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
                options.verbose (1,1) logical = true
            end

            if isfield(options, 'profileName')
                profileName = options.profileName;
            else
                profileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile = options.cfgFile);
            end

            envValue = databricks.internal.configurationprofile.ConfigFile.getEnvVarValue(fieldName, verbose=options.verbose);
            if ~isempty(envValue) && options.verbose
                fprintf(2, "The environment override variable for the field: %s is set to: %s\n", fieldName, envValue);
                fprintf(2, "Thus only deleting the field form the configuration profile may not be sufficient.\n");
            end

            c = databricks.internal.configurationprofile.ConfigFile(options.cfgFile);
            if ~c.isProfile(profileName)
                tf = false;
                fprintf(2, "Profile not found: %s\n", profileName);
                return;
            end
            profile = c.getProfile(profileName);
            if profile.isKey(fieldName)
                profile.remove(fieldName);
                [writeTf, outputFile] = databricks.internal.configurationprofile.ConfigFile.writeProfiles(profile, outputFile=options.cfgFile, verbose=options.verbose, noBackup=true);
                if ~writeTf
                    error("DATABRICKS:ConfigFile:deleteProfileField:write", "Error writing updated profile: %s to: %s", profileName, outputFile);
                end
            end
            tf = true;
        end


        function result = cfgFileWithMaskedTokens(cfgFile)
            % cfgFileWithMaskedTokens Returns configuration file with the tokens fields masked
            % Tokens are replaced with  asterisks.
            % A String is returned.
            % Leading and trailing white space is removed.

            arguments
                cfgFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
            end

            result = "";

            if ~isfile(cfgFile)
                error("DATABRICKS:ConfigFile","Configuration file not found: %s", cfgFile);
            end

            lines = split(strtrim(fileread(cfgFile)), newline);

            pat = whitespacePattern(0,100) + "token" + whitespacePattern(0,100) + "=" + whitespacePattern(0,100) + wildcardPattern(1,inf);
            for n = 1:numel(lines)
                if matches(lines{n}, pat)
                    fields = split(lines{n}, '=');
                    if numel(fields) == 2
                        tokenWithIndent = string(fields{1});
                        maskedToken = string(repmat('*', 1, numel(strtrim(fields{2}))));
                        result = result + tokenWithIndent + "=" + " " + maskedToken + newline;
                    else
                        result = result + "token = ********************";
                        fprintf("Unexpected token value on line %d of:%s\n", n, cfgFile);
                    end
                else
                    result = result + string(lines{n}) + newline;
                end
            end
        end


        function cfgFilePath = getCfgFilePath()
            % getCfgFilePath
            % If the DATABRICKS_CONFIG_FILE environment variable is set it is used.
            % Otherwise a default of <home directory>/.databrickscfg is used.
            % A character vector is returned.
            % This method does not validate if the file exists or not.
            %
            % Example:
            %   filepath = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
            %
            % In deployed mode, first the environment variable DATABRICKS_CONFIG_FILE is
            % checked. Then the path is checked using which for .databrickscfg.
            % Then the path is checked using which for deployed.databrickscfg.
            % Then the path ctfroot()/deployed.databrickscfg is used, this file may
            % or may not exist.
            % Files with a leading "." can be problematic in some deployed cases.

            cfgFileEnvVar = getenv('DATABRICKS_CONFIG_FILE');
            if isempty(cfgFileEnvVar)
                if ~isdeployed
                    cfgFilePath = char(fullfile(matlab.internal.utils.getHomeDirectory(), '.databrickscfg'));
                else
                    cfgFilePath = char(which('.databrickscfg'));
                    if isempty(cfgFilePath)
                        cfgFilePath = char(which('deployed.databrickscfg'));
                        if isempty(cfgFilePath)
                            cfgFilePath = char(fullfile(ctfroot,'deployed.databrickscfg'));
                        end
                    end
                end
            else
                cfgFilePath = char(cfgFileEnvVar);
            end
        end


        function [tf, cfgFile] = isDatabricksCfgFile
            % isDatabricksCfg Returns true if a .databrickscfg format file is present
            % The DATABRICKS_CONFIG_FILE environment variable is applied.
            %
            % Example:
            %   [tf, filepath] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile

            cfgFile = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath();
            if isempty(cfgFile)
                tf = false;
            elseif ~isfile(cfgFile)
                tf = false;
            else
                tf = true;
            end
        end


        function result = merge(source, destination)
            % merge Merges the source and destination array profiles
            % If a profile of the same name exists in both profiles the
            % source profile is used.
            % If the destination is empty the source is returned.
            % If the source is empty the destination is returned.
            arguments
                source databricks.internal.configurationprofile.Profile
                destination databricks.internal.configurationprofile.Profile
            end

            if isempty(destination)
                result = source;
                return;
            end

            if isempty(source)
                result = destination;
                return;
            end

            % Assume all of the destination profile appear in the result
            result = destination;
            for n = 1:numel(source)
                % For each destination profile if it appears in the source
                % replace the result profile at the same index with the source profile
                % otherwise append the source profile to the end
                matched = false;
                for m = 1:numel(destination)
                    if strcmp(source(n).Name, destination(m).Name)
                        result(m) = source(n);
                        matched = true;
                        break
                    end
                end
                if ~matched
                    result(end+1) = source(n); %#ok<AGROW>
                end
            end
        end


        function tf = writeProfileField(profileName, fieldName, value, options)
            % writeProfileField Writes a field to a profile in the .databrickscfg format
            % A backup file <outputFile>.bak is created by default.
            % The default output filename is <home directory>/.databrickscfg
            % By default existing profiles are not replaced unless a profile of the
            % same name exists in the input, in which case the profiles are merged
            % with the incoming field values taking precedence.
            arguments
                profileName {mustBeNonzeroLengthText, mustBeTextScalar}
                fieldName {mustBeNonzeroLengthText, mustBeTextScalar}
                value
                options.cfgFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
                options.verbose (1,1) logical = true;
            end

            if isempty(value) || ((ischar(value) || isstring(value)) && strlength(value) == 0)
               tf = false;
               if options.verbose
                   fprintf(2, "Cannot write an empty or zero length profile configuration value for profile: %s, field: %s\n", profileName, fieldName);
               end
               return;
            else
               try
                   stringValue = string(value);
               catch
                   tf = false;
                   if options.verbose
                       fprintf(2, "Could not convert profile configuration value of type: %s to a string for profile: %s, field: %s\n", class(value), profileName, fieldName);
                   end
                   return;
               end
            end
                
            c = databricks.internal.configurationprofile.ConfigFile(options.cfgFile);
            profile = c.getProfile(profileName);
            if isempty(profile)
                profile = databricks.internal.configurationprofile.Profile(name=profileName);
            end
            setValue(profile, fieldName, stringValue);
            [tf, ~] = databricks.internal.configurationprofile.ConfigFile.writeProfiles(profile, outputFile=options.cfgFile, verbose=options.verbose);
        end


        function [tf, outputFile] = writeProfiles(profiles, options)
            % writeProfile Writes one or more profiles to a .databrickscfg format file
            % A backup file <outputFile>.bak is created by default.
            % The default output filename is <home directory>/.databrickscfg
            % By default existing profiles values are not replaced unless a profile value of the
            % same name exists in the input. If replace is true all existing profiles
            % are overwritten.
            %
            % Example:
            %   myName = "MYPROFILE";
            %   myKeys = ["key1", "key2"];
            %   myValues = ["value1", "value2"];
            %   p = databricks.internal.configurationprofile.Profile(name=myName, keys=myKeys, values=myValues);
            %   [tf,outputFile] = databricks.internal.configurationprofile.ConfigFile.writeProfiles(p)

            arguments
                profiles databricks.internal.configurationprofile.Profile
                options.outputFile string {mustBeNonzeroLengthText, mustBeTextScalar} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath()
                options.noBackup (1,1) logical = false;
                options.replace (1,1) logical = false
                options.verbose (1,1) logical = true
            end

            % Assume failure
            tf = false;
            outputFile = "";

            if isfile(options.outputFile)
                cfgFile = databricks.internal.configurationprofile.ConfigFile(options.outputFile);
                if isempty(cfgFile.Profiles)
                    fprintf("No existing profiles found in: %s\n", options.outputFile);
                end
                existingProfiles = cfgFile.Profiles;
            else
                existingProfiles = databricks.internal.configurationprofile.Profile.empty;
            end

            if options.verbose && options.replace
                fprintf("Replacing profile: %s\n", profileName);
            end

            % If replace is true the existing profiles are not used otherwise
            % they are used but if a profile also exists in the input profiles
            % that is used and overwrites the existing value
            if options.replace
                outputProfiles = profiles;
            else
                outputProfiles = databricks.internal.configurationprofile.ConfigFile.merge(profiles, existingProfiles);
            end

            outStr = "";
            for n = 1:numel(outputProfiles)
                outStr = outStr + outputProfiles(n).toString + newline;
            end
            outStr = strtrim(outStr);

            if options.verbose
                fprintf("Writing configuration to: %s\n", options.outputFile);
            end
            backupFile = options.outputFile + ".bak";
            if ~options.noBackup
                status = copyfile(options.outputFile, backupFile);
                if status == 0
                    fprintf(2, "Unable to make a backup copy of: %s to: %s\n", options.outputFile, backupFile);
                end
            end
            [fid, errmsg] = fopen(options.outputFile, 'w');
            if fid == -1
                fprintf(2, "Unable to open file: %s, for writing.\nMessage: %s\n", options.outputFile, errmsg);
            else
                fprintf(fid, "%s", outStr);
                fclose(fid);
                tf = true;
                outputFile = options.outputFile;
            end
        end
    end


    methods (Access=private, Static)
        function value = getEnvVarValue(key, options)
            arguments
                key string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            switch key
                case "account_id"
                    var = getenv("DATABRICKS_ACCOUNT_ID");

                case "client_id"
                    var = getenv("DATABRICKS_CLIENT_ID");

                case "client_secret"
                    var = getenv("DATABRICKS_CLIENT_SECRET");

                case "host"
                    var = getenv("DATABRICKS_HOST");

                case "token"
                    var = getenv("DATABRICKS_TOKEN");

                case "username"
                    var = getenv("DATABRICKS_USERNAME");

                case "password"
                    var = getenv("DATABRICKS_PASSWORD");

                case "cluster_id"
                    var = getenv("DATABRICKS_CLUSTER_ID");
                
                case "org_id"
                    % DATABRICKS_ORG_ID was supported previously but is not
                    % documented as part the the unified authentication
                    % scheme, for now return empty
                    var = char.empty;

                case "auth_type"
                    var = getenv("DATABRICKS_AUTH_TYPE");

                case "serverless_compute_id"
                    var = getenv("DATABRICKS_SERVERLESS_COMPUTE_ID");

                otherwise
                    if options.verbose
                        fprintf(2, "Unexpected key value in getEnvVarValue: %s\n", key);
                    end
                    var = char.empty;
            end
            if isempty(var)
                value = string.empty;
            else
                value = string(var);
            end
        end


        function profiles = getAllProfiles(srcData)
            % getAllProfiles Populates the Profiles property
            % Content is based on all the profiles in the file
            % If no profiles are found a empty databricks.internal.configurationprofile.Profile
            % with no fields and name DEFAULT is returned

            profiles = databricks.internal.configurationprofile.Profile;

            % profile of >100 characters is likely an error
            identifierPat = asManyOfPattern(alphanumericsPattern(1) | "_" | "-" | "+" | " ", 1);
            pat = "[" + whitespacePattern(0,100) + identifierPat + whitespacePattern(0,100) + "]";
            emptyPat = "[" + whitespacePattern(0,inf) + "]";
            inputText =  strtrim(char(srcData));
            headers = extract(inputText, pat);
            for n = 1:numel(headers)
                if matches(headers{n}, emptyPat)
                    error("DATABRICKS:ConfigFile:getAllProfiles:emptyheader","Empty profile names are not supported.");
                end                
            end
            if ~iscellstr(headers)
                error("DATABRICKS:ConfigFile:getAllProfiles","Expected profile headers to be a cell array of character vectors.");
            end
            headers = strtrim(headers);
            if numel(headers) ~= numel(unique(headers))
                error("DATABRICKS:ConfigFile:getAllProfiles","Duplicate profile name(s) detected, profile names are required to be unique.");
            end

            sections = split(inputText, pat);
            if ~iscellstr(sections) %#ok<ISCLSTR>
                error("DATABRICKS:ConfigFile:getAllProfiles","Expected profiles to be a cell array of character vectors.");
            end
            sections = strtrim(sections);
            if numel(sections) > 0
                if isempty(sections{1})
                    sections(1) = [];
                end
            end

            if numel(headers) ~= numel(sections)
                error("DATABRICKS:ConfigFile:getAllProfiles","Found: %d profile headers and: %d profiles.", numel(headers), numel(sections));
            end

            for n = 1:numel(headers)
                if ~isempty(sections{n})
                    text = string(headers{n}) + newline + string(sections{n});
                else
                    text = string(headers{n}) + newline;
                end
                profiles(n) = databricks.internal.configurationprofile.Profile(text=text);
            end
        end
    end
end % class