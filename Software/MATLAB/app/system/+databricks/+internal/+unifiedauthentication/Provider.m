classdef Provider < handle
    % Provider A class to handle configuration profiles
    % Delegates to databricks.internal.unifiedauthentication.ProviderImpl

    % Copyright 2024-2026 MathWorks, Inc.

    properties (Dependent)
        Profile 
        RequestedAuthMethod 
        AuthMethod 
        Populated 
        Authenticated 
        Source 
        Username 
        Password 
        AccountId 
        Token 
        Host 
        ClientId 
        ClientSecret 
    end

    properties (SetAccess = private)
        providerImpl databricks.internal.unifiedauthentication.ProviderImpl;
    end



    methods
        function val = get.Profile(obj)
            val = obj.providerImpl.Profile;
        end

        function  set.Profile(obj, val)
            obj.providerImpl.Profile = val;
        end

        function val = get.RequestedAuthMethod(obj)
            authMethod = obj.providerImpl.RequestedAuthMethod;
            if isempty(authMethod)
                val = matlab.databricks.AuthMethod.empty;
            else
                val = matlab.databricks.AuthMethod.(string(authMethod));
            end
        end

        function set.RequestedAuthMethod(obj, val)
            obj.providerImpl.RequestedAuthMethod = string(val);
        end
  
        function val = get.AuthMethod(obj)
            authMethod = obj.providerImpl.AuthMethod;
            if isempty(authMethod)
                val = matlab.databricks.AuthMethod.empty;
            else
                val = matlab.databricks.AuthMethod.(string(authMethod));
            end
        end

        function set.AuthMethod(obj, val)
            obj.providerImpl.AuthMethod = string(val);
        end

        function val = get.Populated(obj)
            val = obj.providerImpl.Populated;
        end

        function set.Populated(obj, val)
            obj.providerImpl.Populated = val;
        end

        function val = get.Authenticated(obj)
            val = obj.providerImpl.Authenticated;
        end

        function set.Authenticated(obj, val)
            obj.providerImpl.Authenticated = val;
        end

        function val = get.Source(obj)
            val = obj.providerImpl.Source;
        end

        function set.Source(obj, val)
            obj.providerImpl.Source = val;
        end

        function val = get.Username(obj)
            val = obj.providerImpl.Username;
        end

        function set.Username(obj, val)
            obj.providerImpl.Username = val;
        end

        function val = get.Password(obj)
            val = obj.providerImpl.Password;
        end

        function set.Password(obj, val)
            obj.providerImpl.Password = val;
        end

        function val = get.AccountId(obj)
            val = obj.providerImpl.AccountId;
        end

        function set.AccountId(obj, val)
            obj.providerImpl.AccountId = val;
        end

        function val = get.Token(obj)
            val = obj.providerImpl.Token;
        end

        function set.Token(obj, val)
            obj.providerImpl.Token = val;
        end

        function val = get.Host(obj)
            val = obj.providerImpl.Host;
        end

        function set.Host(obj, val)
            obj.providerImpl.Host = val;
        end

        function val = get.ClientId(obj)
            val = obj.providerImpl.ClientId;
        end

        function set.ClientId(obj, val)
            obj.providerImpl.ClientId = val;
        end

        function val = get.ClientSecret(obj)
            val = obj.providerImpl.ClientSecret;
        end

        function set.ClientSecret(obj, val)
            obj.providerImpl.ClientSecret = val;
        end

        function obj = Provider(varargin)
            % Provider A provider chain to acquire authentication details.
            % When the class is created it will first attempt to acquire authentication
            % credentials and where necessary e.g.if using Oauth authenticate
            % using them to acquire a token.
            %
            % Supported methods are defined by the matlab.databricks.AuthMethod
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
            %       RequestedAuthMethod=matlab.databricks.AuthMethod.Chain,...
            %       profileName="MYPROFILE")
           
        
            % Convert public AuthMethod enum to internal enum before forwarding
            for i = 1:2:numel(varargin)
                if (strcmpi(varargin{i}, 'RequestedAuthMethod') || strcmpi(varargin{i}, 'AuthMethod')) && isa(varargin{i+1}, 'matlab.databricks.AuthMethod')
                    varargin{i+1} = matlab.internal.databricks.AuthMethod.(string(varargin{i+1}));  
                end
            end

            obj.providerImpl = databricks.internal.unifiedauthentication.ProviderImpl(varargin{:});
        end


        function tf = populate(obj, varargin)
            % populate Populates the object properties used for authentication
            % If chain based authentication has been requested then the population will be attempted
            % in the order of the provider chain: PAT, OauthM2M and OauthU2M.
            % This in turn defines which authentication method will be called.
            % A requestedAuthMethod must be set.
            % Returns a logical true if authentication values have been populated
            % into the object and otherwise false.
            for i = 1:2:numel(varargin)
                if (strcmpi(varargin{i}, 'RequestedAuthMethod') || strcmpi(varargin{i}, 'AuthMethod')) && isa(varargin{i+1}, 'matlab.databricks.AuthMethod')
                    varargin{i+1} = matlab.internal.databricks.AuthMethod.(string(varargin{i+1}));  
                end
            end
            tf = obj.providerImpl.populate(varargin{:});
        end


        function providerAuthenticated = authenticate(obj, varargin)
            % AUTHENTICATE Returns a valid token using a given auth method
            % Otherwise false is returned.
            % The Provider object's Authenticated field is set to the return value.
            % The Provider object should first be populated.
            for i = 1:2:numel(varargin)
                if (strcmpi(varargin{i}, 'RequestedAuthMethod') || strcmpi(varargin{i}, 'AuthMethod')) && isa(varargin{i+1}, 'matlab.databricks.AuthMethod')
                    varargin{i+1} = matlab.internal.databricks.AuthMethod.(string(varargin{i+1}));  
                end
            end
             providerAuthenticated = obj.providerImpl.authenticate(varargin{:});
        end
    end


    methods (Hidden)
        %% Populate methods
        function [tf, actualAuthMethod] = chainPop(obj, varargin)
            [tf, actualAuthMethod] = obj.providerImpl.chainPop(varargin{:});
            if isempty(actualAuthMethod)
                actualAuthMethod = matlab.databricks.AuthMethod.empty;
            else
                actualAuthMethod = matlab.databricks.AuthMethod.(string(actualAuthMethod));
            end
        end


        function providerPopulated = patPop(obj, varargin)
            % patPop Populate a provider object for Personal Access Token based authentication
            % Environment variables are tried first then a named profile.
            % If a profile name is not provided DEFAULT is used.
            % See: https://docs.databricks.com/en/dev-tools/auth/pat.html#language-Environment
            % Returns true if the provider can be populated fully.
            % If the host and token are defined in the env vars then the .databrickscfg file will
            % be ignored. Otherwise the .databrickscfg file is used to populate the provider object
            % if it exists.
            providerPopulated = obj.providerImpl.patPop(varargin{:});          
        end


        function providerPopulated = oauthM2MPop(obj, varargin)
            % oauthM2MPop Populate a provider object for OAuth machine-to-machine (M2M) authentication
            % Covers both workspace and account-level operations
            % See also: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
            providerPopulated = obj.providerImpl.oauthM2MPop(varargin{:});
        end


        function providerPopulated = oauthU2MPop(obj, varargin)
            % oauthU2MPop Populate a provider object for OAuth user-to-machine based authentication
            % Covers both workspace and account-level operations
            % See also: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html
            providerPopulated = obj.providerImpl.oauthU2MPop(varargin{:});  
       end
    end
end
