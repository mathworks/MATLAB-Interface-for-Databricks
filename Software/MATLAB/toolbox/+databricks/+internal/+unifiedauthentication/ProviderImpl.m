classdef ProviderImpl < handle
    % ProviderImpl A class to handle configuration profiles

    % Copyright 2024-2026 The MathWorks, Inc.

    properties
        Profile = databricks.internal.configurationprofile.Profile
        RequestedAuthMethod (1,1) matlab.internal.databricks.AuthMethod = matlab.internal.databricks.AuthMethod.Chain
        AuthMethod matlab.internal.databricks.AuthMethod = matlab.internal.databricks.AuthMethod.empty
        Populated (1,1) logical = false
        Authenticated (1,1) logical = false
        Source (1,1) string = ""
        Username (1,1) string = ""
        Password (1,1) string = ""
        AccountId (1,1) string = ""
        Token (1,1) string = ""
        Host (1,1) string = ""
        ClientId (1,1) string = ""
        ClientSecret (1,1) string = ""
    end

    methods
        function obj = ProviderImpl(options)
            % Provider A provider chain to acquire authentication details.
            % When the class is created it will first attempt to acquire authentication
            % credentials and where necessary e.g.if using Oauth authenticate
            % using them to acquire a token.
            %
            % Supported methods are defined by the matlab.internal.databricks.AuthMethod
            % enumeration. They are:
            %
            %   PAT - Databricks personal access token authentication
            %
            %   OauthM2M - OAuth machine-to-machine (M2M) authentication
            %
            %   OauthU2M - OAuth user-to-machine (U2M) authentication
            %
            % The AuthMethod argument is specified as RequestedAuthMethod as Chain
            % will result in an actual method to be used which will differ.
            %
            % If the Chain method is specified then methods are tried in the following
            % order: PAT, OauthM2M and OauthU2M.
            %
            % Chain is used by default.
            %
            % The default profile name is given by databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            %
            % Examples:
            %
            %   % Use the default authentication method PAT with the DEFAULT profile
            %   p = databricks.internal.unifiedauthentication.Provider();
            %
            %   % Invoke the provider chain with a profile named MYPROFILE
            %   p = databricks.internal.unifiedauthentication.Provider(...
            %       RequestedAuthMethod=matlab.internal.databricks.AuthMethod.Chain,...
            %       profileName="MYPROFILE");

            arguments
                options.requestedAuthMethod matlab.internal.databricks.AuthMethod = matlab.internal.databricks.AuthMethod.Chain
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.enablePopulate (1,1) logical = true
                options.enableAuthenticate (1,1) logical = true
                options.verbose (1,1) logical = false
            end

            if options.enablePopulate
                args = matlab.internal.utils.addArgs(options, ["profileName", "requestedAuthMethod", "verbose"]);
                if ~populate(obj, args{:})
                    if options.verbose
                        fprintf(2, "Provider population failed.\n");
                    end
                end
            end

            if options.enableAuthenticate
                if ~obj.Populated
                    if options.verbose
                        fprintf(2, "Provider is not populated and so cannot authenticate.\n");
                    end
                else
                    if ~authenticate(obj)
                        if options.verbose
                            fprintf(2, "Provider authentication failed.\n");
                        end
                    end
                end
            end
        end


        function tf = populate(obj, options)
            % populate Populates the object properties used for authentication
            % If chain based authentication has been requested then the population will be attempted
            % in the order of the provider chain: PAT, OauthM2M and OauthU2M.
            % This in turn defines which authentication method will be called.
            % A requestedAuthMethod must be set.
            % Returns a logical true if authentication values have been populated
            % into the object and otherwise false.

            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                options.requestedAuthMethod matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.verbose (1,1) logical = false
            end

            % If Chain this is determined dynamically and assigned based on the chainPop output
            % Keep the optional argument as legacy support for now.
            if ~isfield(options, 'requestedAuthMethod')
                fprintf(2, "A requestedAuthMethod of type matlab.internal.databricks.AuthMethod, must be set.\n");
                tf = false;
                return;
            end

            switch options.requestedAuthMethod
                case matlab.internal.databricks.AuthMethod.Chain
                    % Set the auth method for Chain but it should be reset
                    % to the successful method if any
                    [tf, ~] = chainPop(obj, options.profileName, false);

                case matlab.internal.databricks.AuthMethod.PAT
                    tf = patPop(obj, options.profileName, options.verbose);

                case matlab.internal.databricks.AuthMethod.OauthM2M
                    tf = oauthM2MPop(obj, options.profileName, options.verbose);

                case matlab.internal.databricks.AuthMethod.OauthU2M
                    tf = oauthU2MPop(obj, options.profileName, options.verbose);

                case matlab.internal.databricks.AuthMethod.empty
                    tf = false;
                    fprintf(2, "No authentication mode set.\n");

                otherwise
                    tf = false;
                    fprintf(2, "Unexpected authentication method: %s\n", options.requestedAuthMethod);
            end

            if options.verbose && ~tf
                fprintf(2, "No credentials found for authentication method: %s\n", options.requestedAuthMethod);
            end
        end


        function providerAuthenticated = authenticate(obj, options)
            % AUTHENTICATE Returns a valid token using a given auth method
            % Otherwise false is returned.
            % The Provider object's Authenticated field is set to the return value.
            % The Provider object should first be populated.

            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                options.verbose (1,1) logical = false
            end

            skipped = false;
            if ~obj.Populated
                fprintf(2, "Configuration details have not been populated in the provider, skipping authentication.\n");
                skipped = true;
            else
                switch obj.AuthMethod
                    case matlab.internal.databricks.AuthMethod.PAT
                        % If the provider is populated there is a token

                    case matlab.internal.databricks.AuthMethod.OauthM2M
                        if strlength(obj.AccountId) > 0
                            obj.Token = databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth(obj.Host, obj.ClientId, obj.ClientSecret, obj.AccountId); % tODO check named arg accountid or not
                        else
                            obj.Token = databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth(obj.Host, obj.ClientId, obj.ClientSecret);
                        end

                    case matlab.internal.databricks.AuthMethod.OauthU2M
                        if strlength(obj.AccountId) > 0
                            obj.Token = databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth(obj.Host, accountId=obj.AccountId);
                        else
                            obj.Token = databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth(obj.Host);
                        end

                    case matlab.internal.databricks.AuthMethod.Chain
                        skipped = true;
                        fprintf(2, "Cannot authenticate based on Chain mode an actual most must be determined.\n");

                    case matlab.internal.databricks.AuthMethod.empty
                        skipped = true;
                        fprintf(2, "No authentication mode set.\n");

                    otherwise
                        fprintf(2, "Unsupported authentication method: %s\n", obj.AuthMethod);
                        skipped = true;
                end
            end

            if skipped
                obj.Authenticated = false;
                if options.verbose
                    fprintf(2, "Provider not authenticated.\n")
                end
            elseif strlength(obj.Token) == 0
                obj.Authenticated = false;
                if options.verbose
                    fprintf(2, "No token value was returned.\n")
                end
            else
                obj.Authenticated = true;
            end
            providerAuthenticated = obj.Authenticated;
        end
    end


    methods (Hidden)
        %% Populate methods
        function [tf, actualAuthMethod] = chainPop(obj, profileName, verbose)
            % CHAINPOP Attempts to populate provider in the order  PAT, OauthM2M, OauthU2M
            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                verbose (1,1) logical = false
            end

            % Order defines the order of the provider chain: PAT, OauthM2M, OauthU2M
            tf = true;
            if patPop(obj, profileName, verbose)
                actualAuthMethod = matlab.internal.databricks.AuthMethod.PAT;
            elseif oauthM2MPop(obj, profileName, verbose)
                actualAuthMethod = matlab.internal.databricks.AuthMethod.OauthM2M;
            elseif oauthU2MPop(obj, profileName, verbose)
                actualAuthMethod = matlab.internal.databricks.AuthMethod.OauthU2M;
            else
                tf = false;
                actualAuthMethod = matlab.internal.databricks.AuthMethod.empty;
                if verbose
                    fprintf(2, "Authentication provider chain failed to find credentials, for profile: %s\n", profileName);
                end
            end
            obj.AuthMethod = actualAuthMethod;
        end


        function providerPopulated = patPop(obj, profileName, verbose)
            % patPop Populate a provider object for Personal Access Token based authentication
            % Environment variables are tried first then a named profile.
            % If a profile name is not provided DEFAULT is used.
            % See: https://docs.databricks.com/en/dev-tools/auth/pat.html#language-Environment
            % Returns true if the provider can be populated fully.
            % If the host and token are defined in the env vars then the .databrickscfg file will
            % be ignored. Otherwise the .databrickscfg file is used to populate the provider object
            % if it exists.
            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                verbose (1,1) logical = false
            end

            % host has the form https://dbc-a1b2345c-d6e7.cloud.databricks.com
            host = string(databricks.internal.Object.sanitizeHost(getenv('DATABRICKS_HOST')));
            token = string(strtrim(getenv('DATABRICKS_TOKEN')));
            if strlength(host) > 0 && strlength(token) > 0
                % Env vars found create a profile object using them alone
                % The token field will be added will be added to the profile at this point because it is already known.
                profile = databricks.internal.configurationprofile.Profile(name="ENVIRONMENT", keys=["host", "token"], values=[host, token]);
                source = "Environment";
            else
                % Get .databrickscfg file details
                [cfgTf, cfgFile] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile;
                if cfgTf
                    configFile = databricks.internal.configurationprofile.ConfigFile(cfgFile);
                    profile = configFile.getProfile(profileName);
                    source = string(cfgFile);
                    if isempty(profile)
                        if verbose
                            fprintf(2, "Profile: %s, not found in configuration file: %s\n", profileName, cfgFile);
                        end
                    end
                else
                    if verbose
                        fprintf(2, "Configuration file not found: %s\n", cfgFile);
                    end
                end
            end

            % Method used to attempt population
            obj.AuthMethod = matlab.internal.databricks.AuthMethod.PAT;
            if profile.isKey("host")
                 obj.Host = databricks.internal.Object.sanitizeHost(profile.getValue('host'));
            end
            if profile.isKey("token")
                obj.Token = profile.getValue('token');
            end
            if (~isempty(obj.Token) && strlength(obj.Token) > 0) && ...
                (~isempty(obj.Host) && strlength(obj.Host) > 0)
                obj.Profile = profile;
                obj.Populated = true;
                obj.Source = source;
            else
                if verbose
                    fprintf(2, "Host and or token not found.\n");
                end
                obj.Profile = databricks.internal.configurationprofile.Profile();
                obj.Populated = false;
                obj.Source = "";
            end
            providerPopulated = obj.Populated;
        end


        function providerPopulated = oauthM2MPop(obj, profileName, verbose)
            % oauthM2MPop Populate a provider object for OAuth machine-to-machine (M2M) authentication
            % Covers both workspace and account-level operations
            % See also: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                verbose (1,1) logical = false
            end

            % First check env vars then the .databrickscfg file
            % host has the form https://dbc-a1b2345c-d6e7.cloud.databricks.com
            host = string(databricks.internal.Object.sanitizeHost(getenv('DATABRICKS_HOST')));
            clientId = string(strtrim(getenv('DATABRICKS_CLIENT_ID')));
            clientSecret = string(strtrim(getenv('DATABRICKS_CLIENT_SECRET')));
            account_id = string(strtrim(getenv('DATABRICKS_ACCOUNT_ID')));
            if strlength(host) > 0 && strlength(clientId) > 0 && strlength(clientSecret) > 0
                if strlength(account_id) > 0  % account level includes account_id or not, workspace level does not use account_id
                    profile = databricks.internal.configurationprofile.Profile(name="ENVIRONMENT", keys=["host", "client_id", "client_secret", "account_id"], values=[host, clientId, clientSecret, account_id]);
                else
                    profile = databricks.internal.configurationprofile.Profile(name="ENVIRONMENT", keys=["host", "client_id", "client_secret"], values=[host, clientId, clientSecret]);
                end
                source = "Environment";
            else
                % Get .databrickscfg file details
                [cfgTf, cfgFile] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile;
                if cfgTf
                    configFile = databricks.internal.configurationprofile.ConfigFile();
                    profile = configFile.getProfile(profileName);
                    source = string(cfgFile);
                    if isempty(profile)
                        if verbose
                            fprintf(2, "Profile: %s, not found in configuration file: %s\n", profileName, cfgFile);
                        end
                    end
                else
                    if verbose
                        fprintf(2, "Configuration file not found: %s\n", cfgFile);
                    end
                end
            end

            % Method used to attempt population
            obj.AuthMethod = matlab.internal.databricks.AuthMethod.OauthM2M;
            % M2M properties
            if profile.isKey("host")
                obj.Host = databricks.internal.Object.sanitizeHost(profile.getValue('host'));
            end
            if profile.isKey("client_id")
                obj.ClientId = profile.getValue('client_id');
            end
            if profile.isKey("client_secret")
                obj.ClientSecret = profile.getValue('client_secret');
            end
            if profile.isKey("account_id")
                obj.AccountId = profile.getValue('account_id');
            end
            if (~isempty(obj.Host) && strlength(obj.Host) > 0) && ...
                (~isempty(obj.ClientId) && strlength(obj.ClientId) > 0) && ...
                (~isempty(obj.ClientSecret) && strlength(obj.ClientSecret) > 0) % don't check accountId
                obj.Profile = profile;
                obj.Populated = true;
                obj.Source = source;
            else
                obj.Profile = databricks.internal.configurationprofile.Profile();
                obj.Populated = false;
                obj.Source = "";
            end
            providerPopulated = obj.Populated;
        end


        function providerPopulated = oauthU2MPop(obj, profileName, verbose)
            % oauthU2MPop Populate a provider object for OAuth user-to-machine based authentication
            % Covers both workspace and account-level operations
            % See also: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html
            arguments
                obj (1,1) databricks.internal.unifiedauthentication.ProviderImpl
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                verbose (1,1) logical = false
            end

            % First check env vars then the .databrickscfg file
            % host has the form https://dbc-a1b2345c-d6e7.cloud.databricks.com
            host = string(databricks.internal.Object.sanitizeHost(getenv('DATABRICKS_HOST')));
            account_id = string(strtrim(getenv('DATABRICKS_ACCOUNT_ID')));
            if strlength(host) > 0
                if strlength(account_id) > 0
                    % account level includes account_id
                    profile = databricks.internal.configurationprofile.Profile(name="ENVIRONMENT", keys=["host", "account_id"], values=[host, account_id]);
                else
                    % workspace level does not use account_id
                    profile = databricks.internal.configurationprofile.Profile(name="ENVIRONMENT", keys="host", values=host);
                end
                source = "Environment";
            else
                % Get .databrickscfg file details
                [cfgTf, cfgFile] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile;
                if cfgTf
                    configFile = databricks.internal.configurationprofile.ConfigFile();
                    profile = configFile.getProfile(profileName);
                    source = string(cfgFile);
                    if isempty(profile)
                        if verbose
                            fprintf(2, "Profile: %s, not found in configuration file: %s\n", profileName, cfgFile);
                        end
                    end
                else
                    source = "";
                    if verbose
                        fprintf(2, "Configuration file not found: %s\n", cfgFile);
                    end
                end
            end

            % Method used to attempt population
            obj.AuthMethod = matlab.internal.databricks.AuthMethod.OauthU2M;
            % U2M properties
            if profile.isKey("host")
                obj.Host = databricks.internal.Object.sanitizeHost(profile.getValue('host'));
            end
            if profile.isKey("account_id")
                obj.AccountId = profile.getValue('account_id');
            end
            if (~isempty(obj.Host) && strlength(obj.Host) > 0) % don't check accountId
                obj.Profile = profile;
                obj.Populated = true;
                obj.Source = source;
            else
                obj.Profile = databricks.internal.configurationprofile.Profile();
                obj.Populated = false;
                obj.Source = "";
            end
            providerPopulated = obj.Populated;
       end
    end
end
