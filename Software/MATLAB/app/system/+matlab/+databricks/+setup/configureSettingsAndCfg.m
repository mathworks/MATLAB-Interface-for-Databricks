function [tf, settingsFile, cfgFile] = configureSettingsAndCfg(options)
    % CONFIGURESETTINGSANDCFG Write databricks-settings.json and .databrickscfg files
    %
    % Example:
    %   [tf, settingsFile, cfgFile] = matlab.databricks.setup.configureSettingsAndCfg();

    %  (c) 2024 MathWorks, Inc.

    arguments
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    tf = false;

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
        fprintf("\nConfiguring settings and configuration details\n\n");
    end

    
    args = {"verbose", false};
    args = matlab.utils.addArgs(options, "settingsFile", args);
    settingsFile = getAndProvisionSettingsFile(args{:});
    
    args = {"verbose", false};
    args = matlab.utils.addArgs(options, "cfgFile", args);
    cfgFile = getAndProvisionConfigurationFile(args{:});
    
    if isfield(options, "profileName")
        profileName = options.profileName;
    else
        profileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile=cfgFile);
    end

    cfgAndSettings = struct; % Track the entered values
    
    [cfgAndSettings.host, cfgAndSettings.org_id] = getHostAndOrgId(cfgFile, profileName);
    if isempty(cfgAndSettings.host) || strlength(cfgAndSettings.host) == 0
        fprintf(2, "Cannot proceed without setting the host value.\n");
        return;
    end
    
    %% Get authMethod
    preamble = sprintf("\nEnter authentication method, other methods can be configured manually following installation.\n");
    prompt = "Choose one of: OauthU2M, PAT, or OauthM2M";
    cfgAndSettings.authMethod = updateSettingsField(settingsFile, "authMethod", prompt, preamble=preamble, verbose=options.verbose);

    %% Get Token
    switch cfgAndSettings.authMethod
        case matlab.databricks.AuthMethod.PAT % Just PAT for PAT mode
            preamble = sprintf("\nTo get a Personal Access Token go to the Databricks workspace, in the top right select username\n");
            preamble = preamble + sprintf('then "User Settings", then "Developer", then "Access tokens & Manage"\n');
            prompt = "Enter Personal Access Token (PAT)";
            cfgAndSettings.token = updateCfgField(cfgFile, "token", prompt, profileName, sensitive=true, verbose=options.verbose, preamble=preamble);
            
        case matlab.databricks.AuthMethod.OauthM2M % Get account_id, client_id & client_secret for OauthM2M
            prompt = "Enter client id for OauthM2M authentication";
            cfgAndSettings.client_id = updateCfgField(cfgFile, "client_id", prompt, profileName, verbose=options.verbose, preamble=newline);
            prompt = "Enter client secret for OauthM2M authentication";
            cfgAndSettings.client_secret = updateCfgField(cfgFile, "client_secret", prompt, profileName, sensitive=true, verbose=options.verbose, preamble=newline);
            
        case matlab.databricks.AuthMethod.OauthU2M  % Get account_id for Basic, OauthM2M & OauthU2M
            
        case {matlab.databricks.AuthMethod.DotDatabricksConnect, matlab.databricks.AuthMethod.Basic, matlab.databricks.AuthMethod.Chain}
            fprintf(2, "Cannot proceed, the %s authentication method is not supported.\n", string(cfgAndSettings.authMethod));
            return
        
        otherwise
            fprintf(2, "Cannot proceed, no authentication method configured.\n");
            return
    end

    %% Check credentials and get username and email
    fprintf("\n");
    fprintf("Testing credentials and getting Databricks username and notification email address.\n");
    [authTestTf, currentUserUsername, currentUserEmail] = getCurrentUserDetails(profileName=profileName, authMethod=cfgAndSettings.authMethod, verbose=false);
    if ~authTestTf
        fprintf(2, "Credentials check failed, recheck, proceeding to get remaining settings & configuration values.\n");
    end
    
    %% Get username
    if isempty(currentUserUsername) || strlength(currentUserUsername) == 0
        prompt = "Enter Databricks username (typically your email address)";
        cfgAndSettings.username = updateSettingsField(settingsFile, "username", prompt, verbose=options.verbose, preamble=newline);
    else
        if databricks.internal.settings.Settings.writeDatabricksSettingsFields("username", currentUserUsername, settingsFile=settingsFile, verbose=false)
            cfgAndSettings.username = currentUserUsername;
        else
            warning("DATABRICKS:CONFIGURESETTINGSANDCFG", "Error writing: %s, to: %s", "username", settingsFile);
        end
    end

    %% Get notificationEmail
    if isempty(currentUserEmail) || strlength(currentUserEmail) == 0
        prompt = "Enter email address for Databricks notifications";
        cfgAndSettings.notificationEmail = updateSettingsField(settingsFile, "notificationEmail", prompt, default=cfgAndSettings.username, verbose=options.verbose, preamble=newline);
    else
        if databricks.internal.settings.Settings.writeDatabricksSettingsFields("notificationEmail", currentUserEmail, settingsFile=settingsFile, verbose=false)
            cfgAndSettings.notificationEmail = currentUserEmail;
        else
            warning("DATABRICKS:CONFIGURESETTINGSANDCFG", "Error writing: %s, to: %s", "notificationEmail", settingsFile);
        end
    end

    %% Get OrgId if not already returned
    if isempty(cfgAndSettings.org_id) || strlength(cfgAndSettings.org_id) == 0
        cfgAndSettings.org_id = getOrgIdNotInURL(cfgFile, profileName, tryAPI=authTestTf, authMethod=cfgAndSettings.authMethod, verbose=options.verbose);
    else
        databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "org_id", cfgAndSettings.org_id, cfgFile=cfgFile, verbose=false);
    end
    if isempty(cfgAndSettings.org_id) || strlength(cfgAndSettings.org_id) == 0
        fprintf(2, "Cannot proceed without setting the org_id value.\n");
        return;
    end

    %% Get vendor
    args = {"tryHostArgument", false, "tryVendorSettings", false, "settingsFile", settingsFile};    % No host argument so skip
    args = matlab.utils.addArgs(options, ["verbose", "profileName"], args);
    if authTestTf
        vendorEnum = matlab.databricks.vendor.getVendor("authMethod", cfgAndSettings.authMethod, args{:});
    else
        % Auth failed so skip the REST API query
        vendorEnum = matlab.databricks.vendor.getVendor("tryRESTAPI", false, args{:});
    end
    if isempty(vendorEnum)
        fprintf(2, "Could not determine cloud vendor.\n");
    else
        if databricks.internal.settings.Settings.writeDatabricksSettingsFields("vendor", string(vendorEnum), settingsFile=settingsFile, verbose=false)
            cfgAndSettings.vendor = lower(string(vendorEnum));
        else
            warning("DATABRICKS:CONFIGURESETTINGSANDCFG", "Error writing: %s, to: %s", "vendor", settingsFile);
        end
    end

    %% Get defaultDatabricksRuntime
    existingValue = databricks.internal.settings.Settings.getSettingsField("defaultDatabricksRuntime", settingsFile=settingsFile);
    if isempty(existingValue) || strlength(existingValue) == 0
        defaultDBRTValue = string(databricks.internal.settings.Settings.getSettingsField("defaultDatabricksRuntime", settingsFile=matlab.internal.databricksRoot("config", "databricks-settings.json.template")));
    else
        defaultDBRTValue = string(existingValue);
    end
    if databricks.internal.settings.Settings.writeDatabricksSettingsFields("defaultDatabricksRuntime", defaultDBRTValue, settingsFile=settingsFile, verbose=false)
        cfgAndSettings.defaultDatabricksRuntime = defaultDBRTValue;
    else
        warning("DATABRICKS:CONFIGURESETTINGSANDCFG", "Error writing: %s, to: %s", "defaultDatabricksRuntime", settingsFile);
    end

    %% Get interfaceDirectory
    prompt = "Enter the interface's /Volumes directory";
    cfgAndSettings.interfaceDirectory = updateSettingsField(settingsFile, "interfaceDirectory", prompt, verbose=options.verbose, preamble=newline); %#ok<STRNU>
    newValue = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory", settingsFile=settingsFile);
    if endsWith(newValue, "/")
        noSlashValue = strip(newValue, "right", "/");
        databricks.internal.settings.Settings.writeDatabricksSettingsFields("interfaceDirectory", noSlashValue, settingsFile=settingsFile, verbose=false);
    end

    fprintf("\nRerun setup if using a different MATLAB release in the future.\n");
    tf = true;
end


function result = updateCfgField(cfgFile, fieldName, prompt, profileName, options)
    arguments
        cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
        prompt string {mustBeNonzeroLengthText}
        profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.preamble string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.default
        options.sensitive (1,1) logical = false
        options.verbose (1,1) logical = false
    end

    if isfield(options, 'default')
        defaultValue = options.default;
    else
        defaultValue = databricks.internal.configurationprofile.ConfigFile.getProfileField(fieldName, profileName=profileName, cfgFile=cfgFile);
    end

    if isfield(options, 'preamble')
        preamble = options.preamble;
    else
        preamble = "";
    end
    if options.sensitive
        str = sprintf("\n            *** CAUTION *** \n");
        str = str + sprintf("This sensitive value will be displayed & recorded in MATLAB's Command History, unless removed\n");
        preamble = str + preamble;
        displayDefault = redact(defaultValue);
    else
        displayDefault = defaultValue;
    end
    if strlength(preamble) > 0
        fprintf("%s", options.preamble);
    end

    if isempty(defaultValue)
        value = strtrim(input(prompt + ": ", 's'));
    else
        if ((isStringScalar(defaultValue) || ischar(defaultValue)) && strlength(defaultValue) > 0) || isenum(defaultValue)
            if strlength(defaultValue) > 40 % A PAT is normally max 38 chars
                displayDefault = displayDefault.extractBefore(40);
            end
            value = string(strtrim(input(prompt + ", [" + string(displayDefault) + "]: ", 's')));
        else
            value = string(strtrim(input(prompt + ": ", 's')));
        end
        if strlength(value) == 0
            value = defaultValue;
        end
    end

    % cfg ini format file don't support empty values
    if isempty(value) || strlength(value) == 0
        if options.verbose
            fprintf(2, "Not writing empty or zero length configuration value to profile: %s, field: %s\n", profileName, fieldName);
        end
    else
        if ~databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, fieldName, value, cfgFile=cfgFile, verbose=false)
            warning("DATABRICKS:updateCfgField", "Error writing: %s, to: %s", fieldName, cfgFile);
        end
    end
    result = value;
end


function org_id = getOrgIdNotInURL(cfgFile, profileName, options)
    arguments
        cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.tryAPI (1,1) logical = true
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.verbose (1,1) logical = false
    end

    if options.tryAPI
        args = matlab.utils.addArgs(options, ["verbose", "authMethod"], {"profileName", profileName});
        wsc = databricks.internal.WorkspaceConf(args{:});
        org_id = wsc.getOrgId();
    end
    
    if ~options.tryAPI || (isempty(org_id) || strlength(org_id) == 0)
        prompt = "Enter Databricks Workspace id/org_id";
        org_id = updateCfgField(cfgFile, "org_id", prompt, profileName, verbose=options.verbose, preamble=newline);
    else
        databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "org_id", org_id, cfgFile=cfgFile, verbose=false);
    end
end


function [host, org_id] = getHostAndOrgId(cfgFile, profileName)
    arguments
        cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    host = "";
    org_id = "";

    defaultValue = databricks.internal.configurationprofile.ConfigFile.getProfileField("host", profileName=profileName, cfgFile=cfgFile);
    prompt = "Enter Databricks Workspace URL";
    if ~isempty(defaultValue) && strlength(defaultValue) > 0
        value = string(strtrim(input(prompt + ", [" + string(defaultValue) + "]: ", 's')));
        if strlength(value) == 0
            value = defaultValue;
        end
    else
        value = strtrim(input(prompt + ": ", 's'));
    end
    
    % cfg ini format file don't support empty values
    if isempty(value) || strlength(value) == 0
        fprintf(2, "Cannot empty or zero length configuration value to profile: %s, field: %s\n", profileName, "host");
        return
    end

    % May get org_id in the URL without asking extra question
    uri = matlab.net.URI(value);
    host = string(uri.Scheme) + "://" + string(uri.Host);
    databricks.internal.configurationprofile.ConfigFile.writeProfileField(profileName, "host", host, cfgFile=cfgFile, verbose=false);
    for n = 1:numel(uri.Query)
        if strcmp(uri.Query(n).Name, "o")
            org_id = string(uri.Query(n).Value);
            break;
        end
    end
end


function result = updateSettingsField(settingsFile, fieldName, prompt, options)
    arguments
        settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
        prompt string {mustBeNonzeroLengthText}
        options.preamble string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.default
        options.sensitive (1,1) logical = false
        options.verbose (1,1) logical = false
    end

    if isfield(options, 'default')
        defaultValue = options.default;
    else
        defaultValue = databricks.internal.settings.Settings.getSettingsField(fieldName, settingsFile=settingsFile);
    end
    
    if isfield(options, 'preamble')
        preamble = options.preamble;
    else
        preamble = "";
    end
    if options.sensitive
        str = sprintf("\n            *** CAUTION *** \n");
        str = str + sprintf("This sensitive value will be displayed & recorded in MATLAB's Command History, unless removed\n");
        preamble = str + preamble;
        displayDefault = redact(defaultValue);
    else
        displayDefault = defaultValue;
    end
    if strlength(preamble) > 0
        fprintf("%s", options.preamble);
    end

    if isempty(defaultValue)
        value = strtrim(input(prompt + ": ", 's'));
    else
        if ((isStringScalar(defaultValue) || ischar(defaultValue)) && strlength(defaultValue) > 0) || isenum(defaultValue)
            value = string(strtrim(input(prompt + ", [" + string(displayDefault) + "]: ", 's')));
        else
            value = string(strtrim(input(prompt + ": ", 's')));
        end
        if strlength(value) == 0
            value = defaultValue;
        end
    end

    if ~databricks.internal.settings.Settings.writeDatabricksSettingsFields(fieldName, value, settingsFile=settingsFile, verbose=false)
        warning("DATABRICKS:updateSettingsField", "Error writing: %s, to: %s", fieldName, settingsFile);
    end
    result = value;
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


function redactedValue = redact(value)
    % REDACT Limit the amount of a value that is visible
    % If longer than 10 characters show the first and last 2 characters
    % Otherwise show none of it.
    % Hidden characters are replaced with *.
    % A string is returned.

    arguments
        value string
    end

    if isempty(value) || strlength(value) == 0
        redactedValue = value;
    else
        cVal = char(value);
        if strlength(cVal) > 10
            redactedValue = repmat('*', 1, strlength(cVal));
            redactedValue(1:2) = cVal(1:2);
            redactedValue(end-1:end) = cVal(end-1:end);
        else
            redactedValue = repmat('*', 1, strlength(cVal));
        end
        redactedValue = string(redactedValue);
    end
end

function [authTf, username, email] = getCurrentUserDetails(options)
    % getCurrentUserDetails Retrieve user details
    % Designed to be the first API call in setup and thus validates credentials.
    % Returns a true/false, a username and email if successful.
    % Typically the username and email are the same.
    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true 
    end

    username = string.empty;
    email = string.empty;
    try
        if options.verbose
            fprintf("Testing the credentials by using the Databricks REST.\n");
        end
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        u = databricks.CurrentUser(args{:});
        [userInfo, errorResponse] = u.getCurrentUserInfo();
        if isempty(errorResponse)
            if options.verbose
                fprintf("Databricks REST API credentials test succeeded.\n");
            end
            authTf = true;
            if isprop(userInfo, "userName") && ~isempty(userInfo.userName) && strlength(userInfo.userName) > 0
                username = string(userInfo.userName);
            end
            if isprop(userInfo, "emails") && ~isempty(userInfo.emails)
                for n = 1:length(userInfo.emails)
                    if isprop(userInfo.emails(n), "primary") && userInfo.emails(n).primary
                        email = string(userInfo.emails(n).value);
                    end
                end
            end
        else
            fprintf(2, "Databricks REST API credentials test failed, recheck credentials.\nError:\n");
            disp(errorResponse);
            authTf = false;
        end
    catch ME
        fprintf(2, "Databricks REST API credentials test failed, recheck credentials.\nMessage: %s\n", ME.message);
        authTf = false;
    end
end
