classdef Config < handle
    % CONFIG Configuration class for Databricks Python SDK
    %
    % Example:
    %   cfg = databricks.internal.sdk.core.Config();
    %
    % See also (Python): >>> help('databricks.sdk.core.Config')

    % Copyright 2025-2026 MathWorks Inc.

    properties
        ConfigPy
    end

    properties (Hidden)
        errBase = "DATABRICKS.INTERNAL.SDK.CORE.CONFIG"
    end

    methods
        function obj = Config(varargin)
            % CONFIG Constructor for databricks.internal.sdk.core.Config class
            if nargin == 0
                obj.ConfigPy = py.databricks.sdk.core.Config();
            elseif nargin == 1 && isStringScalar(varargin{1}) || ischar(varargin{1})
                obj.ConfigPy = pyrun(sprintf("import databricks.sdk.core; x=databricks.sdk.core.Config(%s)", varargin{1}), "x");
            elseif nargin == 1 && isa(varargin{1}, "dictionary")
                obj.ConfigPy = pyrun(sprintf("import databricks.sdk.core; x=databricks.sdk.core.Config(%s)", matlab.utils.dictionary2kwargsStr(varargin{1})), "x");
            elseif nargin == 1 && isa(varargin{1}, "containers.Map")
                obj.ConfigPy = pyrun(sprintf("import databricks.sdk.core; x=databricks.sdk.core.Config(%s)", matlab.utils.map2kwargsStr(varargin{1})), "x");
            elseif nargin == 1 && isa(varargin{1}, 'py.databricks.sdk.config.Config')
                obj.ConfigPy = varargin{1};
            else
                error(errBase+":INVALIDARGS", "Invalid argument(s)");
            end
        end

        function pyObj = toPy(obj)
            % TOPY Convert to Python object
            % Returns the Python object representation of this Config
            pyObj = obj.ConfigPy;
        end

        function authHeaders = authenticate(obj)
            authHeaders = obj.ConfigPy.authenticate();
        end

        function str = debugString(obj)
            % DEBUGSTRING Get debug string representation of config
            str = string(obj.ConfigPy.debug_string());
        end

        function initAuth(obj)
            obj.ConfigPy.init_auth();
        end

        function token = OauthToken(obj)
            % OauthToken Returns the OAuth token from the current credential provider
            % Returns a databricks.sdk.oauth.Token.
            %
            % This method only works when using OAuth-based authentication methods.
            % If the current credential provider is an OAuthCredentialsProvider, it reuses
            % the existing provider. Otherwise, it raises a ValueError indicating that
            % OAuth tokens are not available for the current authentication method.

            token = obj.ConfigPy.oauth_token();
        end


        function obj = configureAuth(obj, options)
            % APPLYSETTINGSANDCONFIGURATION Apply settings and configuration options
            % Looks at the .databrickscfg file and databricks-settings.json files
            % to configure the Config object with the appropriate values.
            %
            % Optional named arguments:
            %    useSDKAuth: Use SDK authentication, default: false
            %   profileName: Profile name from .databrickscfg, default: "DEFAULT"
            %    authMethod: Authentication method, type: matlab.databricks.AuthMethod
            %       verbose: Enable additional output, default: true
            arguments
                obj
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.verbose (1,1) logical = true
            end

            auth_type = get_auth_type_field(options.profileName, options.verbose);

            % The profile is set at this point so the databricks.Object derived
            % properties override it if required. Applies if using SDK auth too.
            obj.ConfigPy.profile = options.profileName;

            % Don't do the auth here just force resolution of the authMethod
            authObj = databricks.Object();
            authObjArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            authObj.getAuth(authObjArgs{:}, "enableAuthenticate", false, "verbose", false);

            % Apply the authMethod to the Config object
            switch authObj.AuthMethod
                case matlab.databricks.AuthMethod.OauthU2M
                    obj.ConfigPy.auth_type = "external-browser";

                case matlab.databricks.AuthMethod.OauthM2M
                    obj.ConfigPy.auth_type = "oauth-m2m";

                case matlab.databricks.AuthMethod.PAT
                    obj.ConfigPy.auth_type = "pat";

                otherwise
                    error(obj.errBase+":AUTHMETHOD", "Unsupported authentication method: %s", string(authObj.AuthMethod));
            end

            % Do the auth here using the interface auth functionality and apply
            % results to the Config object
            authObj = databricks.Object();
            authObjArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            authObj.getAuth(authObjArgs{:}, "enableAuthenticate", true, "verbose", true);

            obj.ConfigPy.host = authObj.Host;
            obj.ConfigPy.token = authObj.Token;

            % This can change when the interface adopts the auth_type field
            if ~isempty(auth_type) && authObj.AuthMethod.authMethod2AuthType() ~= lower(auth_type)
                fprintf(2, "The current AuthMethod value is: %s, an auth_type configuration value is set to: %s, this will be ignored.", authObj.AuthMethod, auth_type);
            end
        end


        function obj = sdkAuth(obj, options)
            % SDKAUTH Configure authentication using SDK-based authentication
            arguments
                obj
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.verbose (1,1) logical = true
            end

            [auth_type, ~] = databricks.internal.sdk.core.Config.getAuthTypeCfgField(options.profileName, options.verbose);
            authObj = databricks.Object();
            authObjArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            authObj.getAuth(authObjArgs{:}, "enableAuthenticate", false, "verbose", true);

            if databricks.internal.isOnDatabricks && auth_type == "external-browser"
                % This won't work as the SDK will attempt to open a browser
                % in the Web desktop
                error(obj.errBase+":EXTBROWSER", ...
                    "External Browser authentication is not supported on Databricks using Python SDK based authentication, i.e. sdkAuth().\n");
            end

            if databricks.internal.isOnDatabricks && authObj.AuthMethod == "OauthU2M"
                % This won't work as the SDK will attempt to open a browser
                % in the Web desktop
                error(obj.errBase+":OAUTHU2M", ...
                    "OAuth U2M authentication is not supported on Databricks using Python SDK based authentication, i.e. sdkAuth().\n");
            end
        end
    end


    methods (Static)
        function cm = getAuthCfgMap(options)
            % GETAUTHCFGMAP Get authentication configuration as a container.Map
            %
            % Example:
            %    cm = databricks.internal.sdk.core.Config.getAuthCfgMap(authMethod=matlab.databricks.AuthMethod.PAT, profileName="DEFAULT");

            arguments
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.verbose (1,1) logical = true
            end
            cm = containers.Map;

            % Don't do the auth here just force resolution of the authMethod
            authObj = databricks.Object();
            authObjArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            authObj.getAuth(authObjArgs{:}, "enableAuthenticate", false, "verbose", false);

            cm("host") = authObj.Host;

            % Apply the authMethod to the Config object
            switch authObj.AuthMethod
                case matlab.databricks.AuthMethod.OauthU2M
                    cm("auth_type") = "external-browser";

                case matlab.databricks.AuthMethod.OauthM2M
                    cm("auth_type") = "oauth-m2m";
                    cm("client_id") = authObj.ClientId;
                    cm("client_secret") = authObj.ClientSecret;
                    if isprop(authObj, "AccountId")
                        cm("account_id") = authObj.AccountId;
                    end

                case matlab.databricks.AuthMethod.PAT
                    % In the case of PAT set the Token value
                    cm ("auth_type") = "pat";
                    tObj = databricks.Object();
                    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                    tObj.getAuth(args{:}, "enableAuthenticate", true, "verbose", false);
                    cm("token") = tObj.Token;

                otherwise
                    error("GETAUTHCFGDICT:AUTHMETHOD", "Unsupported authentication method: %s", string(authObj.AuthMethod));
            end
        end


        function [auth_type, source] = getAuthTypeCfgField(profileName, verbose)
            % GET_AUTH_TYPE_FIELD Get the auth_type field from the .databrickscfg file
            % Returns an empty string if the field is not found or the profile does not exist.
            % A source value is also returned indicating where the auth_type was found.
            %
            % Example:
            %    [auth_type, source] = databricks.internal.sdk.core.Config.getAuthCfgDict.getAuthTypeCfgField()

            arguments (Input)
                profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                verbose (1,1) logical = false
            end
            arguments (Output)
                auth_type string
                source string
            end

            auth_type = string.empty;
            source = string.empty;

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

            if profile.isKey("auth_type")
                auth_type = profile.getValue('auth_type');
            end
        end
    end
end
