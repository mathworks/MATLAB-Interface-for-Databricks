classdef Oauth
    % OAUTH Container class for U2M & M2M Oauth related functionality
    % Delegates to databricks.internal.unifiedauthentication.OauthImpl

    % Copyright 2024-2026 MathWorks, Inc.

    properties (SetAccess = private)
        OauthImpl databricks.internal.unifiedauthentication.OauthImpl;
    end

    properties (Dependent)
        % Client ID used in Oauth flows, pending a MathWorks specific value
        clientId 
    end

    methods
        function val = get.clientId(obj)
            val = obj.OauthImpl.clientId;
        end        
        function obj = Oauth()
            obj.OauthImpl = databricks.internal.unifiedauthentication.OauthImpl();
        end
    end

    methods(Static)
        function tokenValue = oauthM2MAuth(varargin)
            tokenValue = databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth(varargin{:}); 
        end


        function tokenValue = oauthU2MAuth(varargin)
            tokenValue = databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth(varargin{:});           
        end


        function tokenJWT = getCachedAccessTokenJWT(varargin)
            tokenJWT = databricks.internal.unifiedauthentication.OauthImpl.getCachedAccessTokenJWT(varargin{:});      
        end


        function tokenString = getCachedAccessTokenString(varargin)
            tokenString = databricks.internal.unifiedauthentication.OauthImpl.getCachedAccessTokenString(varargin{:});        
        end


        function value = getCachedValue(varargin)
            % getCachedValue Returns a cached token indexed by host field name and auth method
            % If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE all
            % calls silently return string.empty.
            value = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(varargin{:});   
        end


        function cacheFilePath = getDefaultCacheFilePath(authMethod)
            if isa(authMethod, 'matlab.databricks.AuthMethod')
                authMethod = authMethod.authMethodImpl;
            end
            cacheFilePath = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(authMethod);
        end


        function writeTokenCache(varargin)
            databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache(varargin{:}); 
        end


        function authCode = getWSAuthCode(varargin)
            % getWSAuthCode Use a challenge code to generate an authorization code
            % Requires user interaction with a browser.
            % Used by U2M auth
            % See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile

            % Curl equivalent for Workspace:
            % https://<databricks-instance>/oidc/v1/authorize
            % ?client_id=databricks-cli
            % &redirect_uri=<redirect-url>
            % &response_type=code
            % &state=<state>
            % &code_challenge=<code-challenge>
            % &code_challenge_method=S256
            % &scope=all-apis+offline_access
            authCode = databricks.internal.unifiedauthentication.OauthImpl.getWSAuthCode(varargin{:});            
        end


        function [verifier, challenge] = genVerifierChallenge()
            % genVerifierChallenge Generate verifier and challenge values of U2M auth
            % See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile

            [verifier, challenge] = databricks.internal.unifiedauthentication.OauthImpl.genVerifierChallenge();          
        end


        function [tokenStruct, response] = getRefreshedToken(varargin)
            [tokenStruct, response] = databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken(varargin{:});     
        end


        function tokenStruct = getU2MToken(varargin)
            % getU2MToken Gets a structure containing the Oauth token

            % curl --request POST \
            % https://<databricks-instance>/oidc/v1/token \
            % --data "client_id=databricks-cli" \
            % --data "grant_type=authorization_code" \
            % --data "scope=all-apis offline_access" \
            % --data "redirect_uri=<redirect-url>" \
            % --data "code_verifier=<code-verifier>" \
            % --data "code=<authorization-code>"
            tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getU2MToken(varargin{:});
        end


        function missingFieldWarning(varargin)
            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(varargin{:});
        end


        function tokenStruct = getM2MToken(varargin)
            % getM2MToken Gets a structure containing the Oauth token

            % Account level
            % curl --request POST \
            % --url <token-endpoint-URL> \
            % --user "$CLIENT_ID:$CLIENT_SECRET" \
            % --data 'grant_type=client_credentials&scope=all-apis'
            tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getM2MToken(varargin{:});

        end


        function [tString, tInt64] = epochSecondsUTCNow()
            % epochSecondsUTCNow Return epoch time in UTC in seconds as a string and an int64
            [tString, tInt64] = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow();

        end


        function tf = isTokenCachingDisabled()
            % isTokenCachingDisabled Return true if DISABLE_DATABRICKS_TOKEN_CACHE is true otherwise false
            % Testing of DISABLE_DATABRICKS_TOKEN_CACHE is not case sensitive.
            tf = databricks.internal.unifiedauthentication.OauthImpl.isTokenCachingDisabled();
                      
        end
    end
end