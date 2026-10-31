classdef Object < dynamicprops
    % OBJECT Databricks root object
    % Properties added to this object will be available on all databricks
    % classes.
    %
    % The Version property refers to the version of the Databricks REST API to
    % be used.
    %
    % For more information on provider chain based authentication details see:
    % https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
    %
    % See Documentation for further details: Documentation/Authentication.md

    % Copyright 2019-2026 The MathWorks, Inc.

    properties(Hidden)
        % Databricks Connect PAC or Oauth token
        Token = ''
        % Databricks Endpoint
        Host = ''
        % Version of the Databricks REST API to use by default
        Version = '2.0'
        % Databricks Org_id value (not always used on AWS)
        Org_id = ''
        % Name of the profile used to authenticate
        Profile = ''
        % Basic auth is deprecated and will be removed in a future release
        % Used by Basic authentication for account-level API calls
        AccountId = ''
        % Used by Basic authentication for account & workspace level API calls
        Username = ''
        % Used by Basic authentication for account & workspace level API calls
        Password = ''
        % Used by OauthM2M authentication
        ClientId = ''
        % Used by OauthM2M authentication
        ClientSecret = ''
        % AuthMethod to use
        AuthMethod matlab.internal.databricks.AuthMethod = matlab.internal.databricks.AuthMethod.empty
        % UserAgent used for telemetry
        UserAgent = ''
    end

    methods
        % Constructor
        function obj = Object(~, varargin)
            if isempty(obj.UserAgent) || strlength(obj.UserAgent) == 0
                obj.UserAgent = obj.getUserAgent();
            end

            % Once a day check for a new release
            databricks.internal.utils.newVersionCheckImpl(verbose=false);
        end
    end


    methods
        function uri = getURI(obj, api, method, varargin)
            % getURI Return a matlab.net.URI object
            %
            % Examples:
            %  % Return a matlab.net.URI for https://<host>/api/2.0/clusters/list
            %  u = obj.getURI('clusters', 'list')
            %
            %  % If the function needs parameters, they can be added as pairs
            %  % Return a matlab.net.URI for https://<host>/api/2.0/clusters/get?cluster_id=123
            %  u = obj.getURI('clusters', 'get', 'cluster_id', '123')

            if rem(length(varargin),2) ~= 0
                error('DATABRICKS:URI', 'Parameters must be provided in pairs of name/value.');
            end

            if obj.isPreview(api)
                endpoint = [char(obj.Host), '/api/', char(obj.Version), '/preview/', char(api), '/', char(method)];
            else
                endpoint = [char(obj.Host), '/api/', char(obj.Version), '/', char(api), '/', char(method)];
            end
            uri = matlab.net.URI(endpoint, varargin{:});
        end


        function tf = isPreview(~, api)
            if startsWith(char(api), 'scim')
                tf = true;
            else
                tf = false;
            end
        end


        function getAuth(obj, options)
            % getAuth Populates the authentication configuration values in the databricks.internal.Object class
            % Sets Host, Profile & Token
            arguments
                obj (1,1)
                % Backward compatibility, arguments
                % Does not support Basic auth mode or account-level REST API
                options.Host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.Token string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.Org_id string {mustBeTextScalar}
                % Profile based auth
                options.authMethod matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.enablePopulate (1,1) logical = true
                options.enableAuthenticate (1,1) logical = true
                options.verbose (1,1) logical = false
            end

            % Legacy support
            if isfield(options, 'Org_id') && isfield(options, 'Token') && isfield(options, 'Host')
                % If all of the legacy basic arguments are provided use them and skip the provider chain
                obj.Org_id = char(options.Org_id);
                obj.Token = char(options.Token);
                obj.Host = char(databricks.internal.Object.sanitizeHost(options.Host));
                % if options.verbose % Enable verbose in due course
                fprintf("Skipping provider chain based authentication, " + ...
                    "using specified Token, Host & Org_id.\n");
                % end
                return;
            end

            % Otherwise attempt to use the provider chain
            % Select an authMethod based on: function argument then settings file then Chain
            if isfield(options, 'authMethod')
                authMethod = options.authMethod;
            else
                authMethod = databricks.internal.settings.Settings.getSettingsField('authMethod');
                if isempty(authMethod)
                    authMethod = matlab.internal.databricks.AuthMethod.Chain;
                end
            end

            if isfield(options, 'cfgFile')
                cfgFile = options.cfgFile;
            else
                cfgFile = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath();
            end

            % Select a profileName based on: function argument then settings file then "DEFAULT"
            if isfield(options, 'profileName')
                profileName = options.profileName;
            else
                profileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile=cfgFile, verbose=options.verbose);
                if isempty(profileName) || strlength(profileName) == 0
                    error("DATABRICKS:getAuth", "Could not find a default configuration profile.");
                end
            end

            % Invoke the provider chain
            providerArgs = {"verbose", true};
            providerArgs = matlab.internal.utils.addArgs(options, ["enablePopulate", "enableAuthenticate", "profileName"], providerArgs);
            provider = databricks.internal.unifiedauthentication.ProviderImpl("RequestedAuthMethod", authMethod, providerArgs{:});

            % If the provider is populated populate the Object except for the token that requires auth
            if options.enablePopulate
                if provider.Populated
                    % Populate the Object properties
                    obj.Profile = char(provider.Profile.Name);
                    obj.AuthMethod = provider.AuthMethod;
                    obj.Host = char(provider.Host);

                    if options.verbose
                        fprintf("Authentication method: %s, profile: %s\n", string(obj.AuthMethod), obj.Profile);
                    end

                    switch obj.AuthMethod
                        case matlab.internal.databricks.AuthMethod.PAT
                            % Do nothing host is already set

                        case matlab.internal.databricks.AuthMethod.OauthM2M
                            %obj.Token = char(provider.Token);
                            obj.AccountId = char(provider.AccountId); % May be zero length string
                            obj.ClientId = char(provider.ClientId);
                            obj.ClientSecret = char(provider.ClientSecret);

                        case matlab.internal.databricks.AuthMethod.OauthU2M
                            %obj.Token = char(provider.Token);
                            obj.AccountId = char(provider.AccountId); % May be zero length string

                        case matlab.internal.databricks.AuthMethod.empty
                            error("DATABRICKS:getAuth", "Authentication mode not set.");

                        case matlab.internal.databricks.AuthMethod.chain
                            error("DATABRICKS:getAuth", "Chain may be a requested authentication mode but not an actually used mode, as it must invoke another mode.");

                        otherwise
                            error("DATABRICKS:getAuth", "Unexpected authentication mode.");
                    end
                else
                    error("DATABRICKS:getAuth", "Authentication provider is not populated cannot populate the class: %s.", class(obj));
                end
                if isempty(provider.Profile.Name) || strlength(provider.Profile.Name) == 0 % Should not happen
                    errProfileName = profileName;
                    error("DATABRICKS:getAuth", "Error authenticating using profile: %s, authentication method: %s", errProfileName, authMethod);
                end
            else
                if options.verbose
                    fprintf(2, "Authentication provider population disabled.\n");
                end
            end

            if options.enableAuthenticate
                if ~provider.Populated
                    error("DATABRICKS:getAuth", "The authentication provider is not populated and so a token value can not be configured.");
                end

                if ~provider.Authenticated
                    % Provider could not determine a working authMethod
                    % Chain could not be resolved so report the input
                    % argument authMethod
                    if isempty(provider.AuthMethod)
                        errAuthMethod = authMethod;
                    else
                        errAuthMethod = provider.AuthMethod;
                    end
                    if isempty(provider.Profile.Name) % Should not happen
                        errProfileName = profileName;
                    else
                        errProfileName = provider.Profile.Name;
                    end
                    error("DATABRICKS:getAuth", "Error authenticating using profile: %s, authentication method: %s", errProfileName, errAuthMethod);
                end

                % Reported in provider populate step
                % Populate the Object's Token
                % if options.verbose
                %     fprintf("Authentication method: %s, profile: %s\n", string(obj.AuthMethod), obj.Profile);
                % end

                switch obj.AuthMethod
                    case {matlab.internal.databricks.AuthMethod.PAT, matlab.internal.databricks.AuthMethod.OauthM2M, matlab.internal.databricks.AuthMethod.OauthU2M}
                        obj.Token = char(provider.Token);

                    case matlab.internal.databricks.AuthMethod.empty
                        error("DATABRICKS:getAuth", "Authentication mode not set.");

                    case matlab.internal.databricks.AuthMethod.chain
                        error("DATABRICKS:getAuth", "Chain may be a requested authentication mode but not an actually used mode, as it must invoke another mode.");

                    otherwise
                        error("DATABRICKS:getAuth", "Unexpected authentication mode.");
                end
            end
        end
    end


    methods (Access = protected)
        function addStructureAsDynProps(obj, S)
            propList = fieldnames(S);

            timeStampFields = {...
                'created_at', ...
                'created_at_timestamp', ...
                'updated_at', ...
                'start_time', ...
                'created_time', ...
                'end_time', ...
                'terminated_time', ...
                'last_state_loss_time', ...
                'last_activity_time', ...
                'last_restarted_time'...
                };

            for pCount = 1:numel(propList)
                propName = propList{pCount};

                % create the properties on the object
                val = S.(propName);

                if ismember(propName, timeStampFields)
                    val = databricks.internal.Object.epochToTimestamp(val);
                end

                % populate the information about the object
                setprop(obj, propName, val);
            end
        end

        function rmpropif(obj, propName)
            % rmpropif Remove a property if it exists
            if isprop(obj, propName)
                prop = findprop(obj, propName);
                delete(prop);
            end
        end

        function setprop(obj, propName, propValue)
            % setprop Set a property on an object
            % If the property doesn't already exist, it will be added
            if ~isprop(obj, propName)
                addprop(obj, propName);
            end
            obj.(propName) = propValue;
        end
    end


    methods(Static)
        function userAgent = getUserAgent(options)
            % getUserAgent Returns user agent based on a MATLAB Release value
            % Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
            % By default the current release is used.
            %
            % Example:
            %   userAgent = databricks.internal.Object.getUserAgent(release="R2025b");

            arguments
                options.release string  {mustBeTextScalar, mustBeNonzeroLengthText} = matlabRelease().Release
            end

            if endsWith(options.release, 'a', 'IgnoreCase', true)
                minor = "1";
            else
                minor = "2";
            end
            patch = "0";

            releaseChar = char(options.release);
            major = string(releaseChar(4:5));

            userAgent = "MathWorks_MATLAB/" + major + "." + minor + "." + patch;
        end
    end


    methods(Static, Hidden)
        function result = sanitizeHost(host, options)
            % sanitizeHost Cleans up host values
            % Leading and trailing white space is removed.
            % If the host is of length zero this is returned, with an
            % optional warning.
            % If the host has a trailing / it is removed.
            % If the host does not start with https:// (case insensitive) a
            % warning is produced.
            arguments
                host string
                options.verbose (1,1) logical = false
            end

            if isempty(host)
                if options.verbose
                    warning('DATABRICKS:sanitizeHost', 'Host value is not set.');
                end
                result = "";
                return;
            end

            if ~isscalar(host)
                if options.verbose
                    warning('DATABRICKS:sanitizeHost', 'Host value must be scalar.');
                end
                result = "";
                return;
            end

            host = strtrim(host);
            if strlength(host) == 0
                if options.verbose
                    warning('DATABRICKS:sanitizeHost', 'Host value is not set.');
                end
                result = "";
            else
                if ~startsWith(host, 'https://', 'IgnoreCase', true)
                    warning('DATABRICKS:sanitizeHost', 'Expected host value to start with: https://');
                end
                if endsWith(host, '/')
                    result = strip(host, 'right', '/');
                else
                    result = host;
                end
            end
        end %class


        function ts = epochToTimestamp(epoch)
            ts = datetime(epoch, ...
                'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
        end
    end
end
