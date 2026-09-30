classdef OauthImpl
    % OAUTHIMPL Container class for U2M & M2M Oauth related functionality

    % Copyright 2024-2026 The MathWorks, Inc.

    properties
        % Client ID used in Oauth flows, pending a MathWorks specific value
        clientId = "databricks-cli";
    end

    methods
        function obj = OauthImpl()
        end
    end

    methods(Static)
        function tokenValue = oauthM2MAuth(host, clientId, clientSecret, options)
            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientSecret string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.OauthM2M)
            end

            authMethod = matlab.internal.databricks.AuthMethod.OauthM2M;

            accessTokenString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "access_token", host, cacheFilePath=options.cacheFilePath);

            if isempty(accessTokenString)
                doFullAuth = true;
            else
                % If the token exists check if it is expired, values in seconds, stored as strings to simplify int64 issues
                expiresInString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "expires_in", host, cacheFilePath=options.cacheFilePath);
                if ~isStringScalar(expiresInString)
                    try
                        expiresInString = string(expiresInString);
                    catch ME
                        error("expires_in field could not be converted to a string: %s", ME.message);
                    end
                end
                iatString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "iat", host, cacheFilePath=options.cacheFilePath);
                if ~isStringScalar(iatString)
                    try
                        iatString = string(iatString);
                    catch ME
                        error("iat field could not be converted to a string: %s", ME.message);
                    end
                end
                if isempty(expiresInString) || isempty(iatString)
                    % If either value is missing consider the token expired
                    doFullAuth = true;
                else
                    expiresInInt64 = sscanf(expiresInString, "%lu");
                    iatInt64 = sscanf(iatString, "%lu");
                    [~, nowInt64] = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow();
                    if nowInt64 > iatInt64 + expiresInInt64
                        doFullAuth = true;
                    else
                        doFullAuth = false;
                    end
                end
            end

            if doFullAuth
                if isfield(options, 'accountId')
                    tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getM2MToken(host, clientId, clientSecret, accountId=options.accountId);
                else
                    tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getM2MToken(host, clientId, clientSecret);
                end
                if numel(fieldnames(tokenStruct)) > 0
                    if isfield(tokenStruct, "access_token")
                        tokenValue = tokenStruct.access_token;
                        % iat should not be returned by the API if it does warn but overwrite it
                        if isfield(tokenStruct, "iat")
                            warning("DATABRICKS:oauthU2MAuth","Unexpected iat field returned.");
                        end
                        tokenStruct.iat = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow;
                        % Write the cached token struct to disk
                        databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache(authMethod, tokenStruct, host, cacheFilePath=options.cacheFilePath);
                    else
                        error("DATABRICKS:oauthM2MAuth","No access_token value returned.");
                    end
                else
                    error("DATABRICKS:oauthM2MAuth","Unable to get valid token.");
                end
            else
                tokenValue = accessTokenString;
            end
        end


        function tokenValue = oauthU2MAuth(host, options)
            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.OauthU2M)
                options.redirectURL string {mustBeTextScalar, mustBeNonzeroLengthText} = "http://localhost:8020"
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if batchStartupOptionUsed || isdeployed
                error("DATABRICKS:oauthU2MAuth", "Cannot use OauthU2M authentication in deployed mode or batch mode as this requires opening a browser.");
            end

            authMethod = matlab.internal.databricks.AuthMethod.OauthU2M;

            accessTokenString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "access_token", host, cacheFilePath=options.cacheFilePath);

            if isempty(accessTokenString)
                doFullAuth = true;
            else
                % If the token exists check if it is expired, values in seconds, stored as strings to simplify int64 issues
                expiresInString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "expires_in", host, cacheFilePath= options.cacheFilePath);
                if ~isStringScalar(expiresInString)
                    try
                        expiresInString = string(expiresInString);
                    catch ME
                        error("DATABRICKS:oauthU2MAuth", "expires_in field could not be converted to a string: %s", ME.message);
                    end
                end
                iatString = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "iat", host, cacheFilePath=options.cacheFilePath);
                if ~isStringScalar(iatString)
                    try
                        iatString = string(iatString);
                    catch ME
                        error("DATABRICKS:oauthU2MAuth", "iat field could not be converted to a string: %s", ME.message);
                    end
                end
                if isempty(expiresInString) || isempty(iatString)
                    % If either value is missing consider the token expired
                    accessTokenExpired = true;
                else
                    expiresInInt64 = sscanf(expiresInString, "%lu");
                    iatInt64 = sscanf(iatString, "%lu");
                    [~, nowInt64] = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow();
                    if nowInt64 > iatInt64 + expiresInInt64
                        accessTokenExpired = true;
                    else
                        accessTokenExpired = false;
                    end
                end

                if accessTokenExpired
                    % Access token has expired so try to refresh it
                    refreshToken = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(authMethod, "refresh_token", host, cacheFilePath=options.cacheFilePath);
                    if isempty(refreshToken)
                        doFullAuth = true;
                    else
                        if isfield(options, 'accountId')
                            [tokenStruct, response] = databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken(host, refreshToken, accountId=options.accountId);
                        else
                            [tokenStruct, response] = databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken(host, refreshToken);
                        end
                        if numel(fieldnames(tokenStruct)) > 0
                            if isfield(tokenStruct, "access_token")
                                tokenValue = tokenStruct.access_token;
                                % iat should not be returned by the API if it does warn but overwrite it
                                if isfield(tokenStruct, "iat")
                                    warning("DATABRICKS:oauthU2MAuth","Unexpected iat field returned.");
                                end
                                tokenStruct.iat = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow;
                                % Write the cached token struct to disk
                                databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache(authMethod, tokenStruct, host, cacheFilePath=options.cacheFilePath);
                                doFullAuth = false;
                            else
                                fprintf("Refresh did not return an access token\n");
                                doFullAuth = true;
                            end
                        else
                            if isprop(response, 'Body') && isprop(response.Body, 'Data') && isfield(response.Body.Data, 'error_description') && strlength(response.Body.Data.error_description) > 0
                                fprintf("Could not refresh token: %s\n", response.Body.Data.error_description);
                            else
                                fprintf("Could not refresh token\n");
                            end
                            doFullAuth = true;
                        end
                    end
                else
                    tokenValue = accessTokenString;
                    doFullAuth = false;
                end
            end

            if doFullAuth
                % There is no access token expired or otherwise so do a full auth cycle
                [verifier, challenge] = databricks.internal.unifiedauthentication.OauthImpl.genVerifierChallenge();
                state = extractBefore(string(java.util.UUID.randomUUID), "-");
                authCode = databricks.internal.unifiedauthentication.OauthImpl.getWSAuthCode(host, options.redirectURL, state, challenge);

                if isfield(options, 'accountId')
                    tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getU2MToken(host, options.redirectURL, verifier, authCode, accountId=options.accountId);
                else
                    tokenStruct = databricks.internal.unifiedauthentication.OauthImpl.getU2MToken(host, options.redirectURL, verifier, authCode);
                end

                if ~isfield(tokenStruct, "access_token")
                    error("DATABRICKS:oauthU2MAuth","No access_token value returned.");
                else
                    tokenValue = string(tokenStruct.access_token);
                end

                % iat should not be returned by the API if it does warn but overwrite it
                if isfield(tokenStruct, "iat")
                    warning("DATABRICKS:oauthU2MAuth","Unexpected iat field returned.");
                end
                tokenStruct.iat = databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow;

                % Write the cached token struct to disk
                databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache(authMethod, tokenStruct, host, cacheFilePath=options.cacheFilePath);
            end
        end


        function value = getCachedValue(authMethod, fieldName, host, options)
            % getCachedValue Returns a cached token indexed by host field name and auth method
            % If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE all
            % calls silently return string.empty.

            arguments
                authMethod (1,1) matlab.internal.databricks.AuthMethod
                fieldName (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                host (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if databricks.internal.unifiedauthentication.OauthImpl.isTokenCachingDisabled
                value = string.empty;
                return;
            end

            if isfield(options, 'cacheFilePath')
                cacheFilePath = options.cacheFilePath;
            else
                cacheFilePath = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(authMethod);
            end

            if isfile(cacheFilePath)
                values = jsondecode(fileread(cacheFilePath));
                if isstruct(values)
                    % Use the hostname as an index for the cached values
                    validHostName = string(matlab.lang.makeValidName(host));
                    if isfield(values, validHostName)
                        authMethodStr = string(authMethod);
                        if isfield(values.(validHostName), authMethodStr)
                            if isfield(values.(validHostName).(authMethodStr), fieldName)
                                value = values.(validHostName).(authMethodStr).(fieldName);
                            else
                                value = string.empty;
                            end
                        else
                            value = string.empty;
                        end
                    else
                        value = string.empty;
                    end
                else
                    error("DATABRICKS:getCachedValue", "Expected cache to return a struct.");
                end
            else
                value = string.empty;
            end
        end


        function cacheFilePath = getDefaultCacheFilePath(authMethod)
            arguments
                authMethod (1,1) matlab.internal.databricks.AuthMethod
            end

            envVarPath = getenv("DATABRICKS_TOKEN_CACHE_FILE");
            if strlength(envVarPath) == 0
                if authMethod == matlab.internal.databricks.AuthMethod.OauthU2M || authMethod == matlab.internal.databricks.AuthMethod.OauthM2M
                    cacheFilePath = string(fullfile(matlab.internal.utils.getHomeDirectory(), '.databricksOauthTokenCache'));
                else
                    error("DATABRICKS:getDefaultCacheFilePath", "Oauth tokens can only be cached for OauthU2M & OauthM2M authentication modes.");
                end
            else
                cacheFilePath = string(envVarPath);
            end
        end


        function writeTokenCache(authMethod, tokenValues, host, options)
            % writeTokenCache Caches a token indexed by host field name and auth method
            % If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE this
            % function does nothing and returns.

            arguments
                authMethod (1,1) matlab.internal.databricks.AuthMethod
                tokenValues (1,1) struct
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if databricks.internal.unifiedauthentication.OauthImpl.isTokenCachingDisabled
                return;
            end

            if isfield(options, 'cacheFilePath')
                cacheFilePath = options.cacheFilePath;
            else
                cacheFilePath = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(authMethod);
            end

            % Use the hostname and authMethod as indices for the cached values
            validHostName = string(matlab.lang.makeValidName(host));
            if isfile(cacheFilePath)
                % Read the existing token struct
                fileStruct = jsondecode(fileread(cacheFilePath));
            else
                fileStruct = struct;
            end
            fileStruct.(validHostName).(string(authMethod)) = tokenValues;
            [fid, errmsg] = fopen(cacheFilePath, 'w');
            cleanup = onCleanup(@() fclose(fid));

            if fid ~= -1
                fprintf(fid, "%s", jsonencode(fileStruct, PrettyPrint=true));
            else
                error("DATABRICKS:writeTokenCache","Could not cache Oauth token values in: %s\nMessage: %s", cacheFilePath, errmsg);
            end
        end


        function authCode = getWSAuthCode(host, redirectURL, state, challenge, options)
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

            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                redirectURL string {mustBeTextScalar, mustBeNonzeroLengthText}
                state string {mustBeTextScalar, mustBeNonzeroLengthText}
                challenge string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if batchStartupOptionUsed || isdeployed
                error("DATABRICKS:genWSAuthCode", "Cannot generate an authorization code in deployed mode or batch mode as this requires opening a browser.");
            end

            oauthObj = databricks.internal.unifiedauthentication.OauthImpl;

            req = matlab.net.http.RequestMessage;
            req.Method = matlab.net.http.RequestMethod.GET;

            uri = matlab.net.URI(host);
            if isfield(options, 'accountId')
                uri.Path = {'oidc', 'accounts', char(options.accountId), 'v1', 'authorize'};
            else
                uri.Path = {'oidc', 'v1', 'authorize'};
            end
            uri.Query(end+1) = matlab.net.QueryParameter("client_id", oauthObj.clientId);
            uri.Query(end+1) = matlab.net.QueryParameter("redirect_uri", redirectURL);
            uri.Query(end+1) = matlab.net.QueryParameter("response_type", "code");
            uri.Query(end+1) = matlab.net.QueryParameter("state", state);
            uri.Query(end+1) = matlab.net.QueryParameter("code_challenge", challenge);
            uri.Query(end+1) = matlab.net.QueryParameter("code_challenge_method", "S256");
            uri.Query(end+1) = matlab.net.QueryParameter("scope", "all-apis+offline_access");

            % Debug only - MATLAB cannot follow a redirect because interactive auth is required
            % [response, completedRequest, history] = req.send(uri);

            % Get the redirected URL post login
            fprintf("Authenticating to Databricks.\n");
            fprintf("Opening: %s\n", uri.EncodedURI);
            fprintf("Login and when the browser redirects, paste the new URL back into MATLAB.\n");
            fprintf("Opening browser...\n");
            fprintf("An apparent connection error is expected.\n")
            % Pause for a second so it feels less glitchy
            pause(1);
            stat = web(uri.EncodedURI); %#ok<NASGU>

            redirectedURLStr = strtrim(input('Enter the redirected URL from the browser address field: ', 's'));
            % Response has the form: http://localhost:8020/?code=dcod4d5a45f5337439d9def743f4f89611f8&state=My+state+text
            redirectedURI = matlab.net.URI(redirectedURLStr);

            % First check state matches
            encodedState = string(java.net.URLEncoder.encode(state, "UTF-8"));

            redirectedURLBase = redirectedURI.Scheme+"://"+redirectedURI.EncodedAuthority;
            if ~strcmp(redirectURL, redirectedURLBase)
                warning("DATABRICKS:genWSAuthCode", "The redirected URL scheme or encoded authority: %s, does not matched the expected value: %s", redirectedURLBase, redirectURL);
            end

            if numel(redirectedURI.Query) < 2
                error("DATABRICKS:genWSAuthCode", "Expected at least 2 query parameters, code and state, in the redirected URL.");
            end

            stateQueryValue = string.empty;
            authCode = string.empty;
            for n = 1:numel(redirectedURI.Query)
                if strcmp(redirectedURI.Query(n).Name, "state")
                    stateQueryValue = redirectedURI.Query(n).Value;
                end
                if strcmp(redirectedURI.Query(n).Name, "code")
                    authCode = redirectedURI.Query(n).Value;
                end
            end

            if isempty(authCode)
                error("DATABRICKS:genWSAuthCode:authCode", "Expected code query parameter not found in the redirected URL.");
            end

            if isempty(stateQueryValue)
                error("DATABRICKS:genWSAuthCode:stateQueryValue", "Expected state query parameter not found in the redirected URL.");
            else
                if ~strcmp(stateQueryValue, encodedState)
                    % Potential security problem, the code should not be used
                    error("DATABRICKS:genWSAuthCode:statemismatch", "The encoded value of state: %s, does not match the returned value: %s", encodedState, stateQueryValue);
                end
            end
        end


        function [verifier, challenge] = genVerifierChallenge()
            % genVerifierChallenge Generate verifier and challenge values of U2M auth
            % See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile

            % Generate a UUID
            uuid1 = string(java.util.UUID.randomUUID());
            % Convert the UUID to a string
            uuid_str1 = upper(uuid1);
            % Create the code verifier
            verifier = uuid_str1 + "-" + uuid_str1;

            % Create the code challenge based on the code verifier.
            md = java.security.MessageDigest.getInstance("SHA-256");
            unicodeStr = native2unicode(verifier,'UTF-8');
            challenge = strrep(string(char(java.util.Base64.getUrlEncoder().encode(md.digest(java.lang.String(unicodeStr).getBytes(java.nio.charset.StandardCharsets.UTF_8)))')), "=", "");
        end


        function [tokenStruct, response] = getRefreshedToken(host, refreshToken, options)
            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                refreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = false
            end

            oauthObj = databricks.internal.unifiedauthentication.OauthImpl;

            uri = matlab.net.URI(host);
            uri.Path = {'oidc', 'v1', 'token'};
            if isfield(options, 'accountId')
                uri.Path = {'oidc', 'accounts', char(options.accountId), 'v1', 'token'};
            else
                uri.Path = {'oidc', 'v1', 'token'};
            end

            % Use a URI to build the query string
            uriq = matlab.net.URI(host);
            uriq.Query(end+1) = matlab.net.QueryParameter("client_id", oauthObj.clientId);
            uriq.Query(end+1) = matlab.net.QueryParameter("grant_type", "refresh_token");
            uriq.Query(end+1) = matlab.net.QueryParameter("refresh_token", refreshToken);

            % Send request
            req =  matlab.net.http.RequestMessage;
            req.Method = matlab.net.http.RequestMethod.POST;
            messageBody = matlab.net.http.MessageBody;
            messageBody.Payload = uriq.EncodedQuery;

            req.Body = messageBody;
            req.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');

            httpOpts = databricks.internal.getHTTPOptionsImpl(convertResponse=true);
            [response, completedRequest, history] = req.send(uri, httpOpts); %#ok<ASGLU>
            if response.StatusCode == matlab.net.http.StatusCode.OK
                tokenStruct = struct;
                if isprop(response, 'Body')
                    if isprop(response.Body, 'Data')
                        if isstruct(response.Body.Data)
                            tokenStruct = response.Body.Data;
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'access_token');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'refresh_token');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'scope');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'token_type');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'expires_in');
                        end
                    end
                end
            else
                if options.verbose
                    fprintf("Error:\n")
                    fprintf("      HTTP Status: %s\n", string(response.StartLine));
                    if isprop(response, 'Body') && isprop(response.Body, 'Data') && isstruct(response.Body.Data)
                        if isfield(response.Body.Data, 'error')
                            fprintf("            Error: %s\n", response.Body.Data.error);
                        end
                        if isfield(response.Body.Data, 'error_description')
                            fprintf("Error Description: %s\n", response.Body.Data.error_description);
                        end
                    end
                end
                tokenStruct = struct;
            end
        end


        function tokenStruct = getU2MToken(host, redirectURL, codeVerifier, code, options)
            % getU2MToken Gets a structure containing the Oauth token

            % curl --request POST \
            % https://<databricks-instance>/oidc/v1/token \
            % --data "client_id=databricks-cli" \
            % --data "grant_type=authorization_code" \
            % --data "scope=all-apis offline_access" \
            % --data "redirect_uri=<redirect-url>" \
            % --data "code_verifier=<code-verifier>" \
            % --data "code=<authorization-code>"

            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                redirectURL string {mustBeTextScalar, mustBeNonzeroLengthText}
                codeVerifier string {mustBeTextScalar, mustBeNonzeroLengthText}
                code string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            oauthObj = databricks.internal.unifiedauthentication.OauthImpl;

            uri = matlab.net.URI(host);
            uri.Path = {'oidc', 'v1', 'token'};
            if isfield(options, 'accountId')
                uri.Path = {'oidc', 'accounts', char(options.accountId), 'v1', 'token'};
            else
                uri.Path = {'oidc', 'v1', 'token'};
            end

            % Use a URI to build the query string
            uriq = matlab.net.URI(host);
            uriq.Query(end+1) = matlab.net.QueryParameter("client_id", oauthObj.clientId);
            uriq.Query(end+1) = matlab.net.QueryParameter("grant_type", "authorization_code");
            uriq.Query(end+1) = matlab.net.QueryParameter("scope", "all-apis+offline_access");
            uriq.Query(end+1) = matlab.net.QueryParameter("redirect_uri", redirectURL);
            uriq.Query(end+1) = matlab.net.QueryParameter("code_verifier", codeVerifier);
            uriq.Query(end+1) = matlab.net.QueryParameter("code", code);

            % Send request
            req =  matlab.net.http.RequestMessage;
            req.Method = matlab.net.http.RequestMethod.POST;
            messageBody = matlab.net.http.MessageBody;
            messageBody.Payload = uriq.EncodedQuery;

            req.Body = messageBody;
            req.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');

            httpOpts =databricks.internal.getHTTPOptionsImpl(convertResponse=true);
            [response, completedRequest, history] = req.send(uri, httpOpts); %#ok<ASGLU>

            if response.StatusCode == matlab.net.http.StatusCode.OK
                tokenStruct = struct;
                if isprop(response, 'Body')
                    if isprop(response.Body, 'Data')
                        if isstruct(response.Body.Data)
                            tokenStruct = response.Body.Data;
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'access_token');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'refresh_token');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'scope');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'token_type');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'expires_in');
                        end
                    end
                end
            else
                if options.verbose
                    fprintf("Error:\n")
                    fprintf("      HTTP Status: %s\n", string(response.StartLine));
                    if isprop(response, 'Body') && isprop(response.Body, 'Data') && isstruct(response.Body.Data)
                        if isfield(response.Body.Data, 'error')
                            fprintf("            Error: %s\n", response.Body.Data.error);
                        end
                        if isfield(response.Body.Data, 'error_description')
                            fprintf("Error Description: %s\n", response.Body.Data.error_description);
                        end
                    end
                end
                tokenStruct = struct;
            end
        end


        function missingFieldWarning(s, fieldName)
            arguments
                s (1,1) struct
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if ~isfield(s, fieldName)
                warning("DATABRICKS:getToken", "Expected field: %s, not found", fieldName);
            end
        end


        function tokenStruct = getM2MToken(host, clientId, clientSecret, options)
            % getM2MToken Gets a structure containing the Oauth token

            % Account level
            % curl --request POST \
            % --url <token-endpoint-URL> \
            % --user "$CLIENT_ID:$CLIENT_SECRET" \
            % --data 'grant_type=client_credentials&scope=all-apis'

            arguments
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientSecret string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.accountId string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isfield(options, 'accountId')
                tokenEndpointURL = matlab.net.URI("https://accounts.cloud.databricks.com/");
                tokenEndpointURL.Path = {'oidc', 'accounts', char(options.accountId), 'v1', 'token'};
            else
                tokenEndpointURL = matlab.net.URI(host);
                tokenEndpointURL.Path = {'oidc', 'v1', 'token'};
            end

            % Use a URI to build the query string
            uriq = matlab.net.URI(host);
            uriq.Query(end+1) = matlab.net.QueryParameter("grant_type", "client_credentials");
            uriq.Query(end+1) = matlab.net.QueryParameter("scope", "all-apis");

            % basicAuth = matlab.net.http.AuthenticationScheme.Basic;
            creds = matlab.net.http.Credentials("Username", clientId, "Password", clientSecret, "Scheme", "Basic");

            % Send request
            req =  matlab.net.http.RequestMessage;
            req.Method = matlab.net.http.RequestMethod.POST;
            messageBody = matlab.net.http.MessageBody;
            messageBody.Payload = uriq.EncodedQuery;

            httpOpts = databricks.internal.getHTTPOptionsImpl(convertResponse=true);
            httpOpts.Credentials = creds;

            req.Body = messageBody;
            req.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');

            % A bug on the databricks side returns the media content field
            % twice g3556761
            % This breaks the send but the response etc. is available in ME
            % so get that there if the id is known
            try
                [response, completedRequest, history] = req.send(tokenEndpointURL, httpOpts); %#ok<ASGLU>
            catch ME
                if strcmp(ME.identifier, 'MATLAB:http:CannotConvertContent')
                    response = ME.History.Response;
                    history = ME.History; %#ok<NASGU>
                    completedRequest= ME.History.Request; %#ok<NASGU>
                    % This won't have happened in send so decode it now.
                    if httpOpts.ConvertResponse
                        try
                            response.Body.Data = jsondecode(char(response.Body.Payload'));
                        catch MEINNER
                            error("DATABRICKS:oauthM2MAuth", "Unable to decode response body.\nMessage: %s", MEINNER.message);
                        end
                    end
                else
                    rethrow(ME)
                end
            end

            if response.StatusCode == matlab.net.http.StatusCode.OK
                tokenStruct = struct;
                if isprop(response, 'Body')
                    if isprop(response.Body, 'Data')
                        if isstruct(response.Body.Data)
                            tokenStruct = response.Body.Data;
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'access_token');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'token_type');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'expires_in');
                            databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning(tokenStruct, 'scope');
                        end
                    end
                end
            else
                fprintf("Error:\n")
                fprintf("      HTTP Status: %s\n", string(response.StartLine));
                if isprop(response, 'Body')
                    if isprop(response.Body, 'Data')
                        if isstruct(response.Body.Data)
                            if isfield(response.Body.Data, 'error')
                                fprintf("            Error: %s\n", response.Body.Data.error);
                            end
                            if isfield(response.Body.Data, 'error_description')
                                fprintf("Error Description: %s\n", response.Body.Data.error_description);
                            end
                            if isfield(response.Body.Data, 'error_description')
                                fprintf("         Error Id: %s\n", response.Body.Data.error_id);
                            end
                        end
                    end
                end
                tokenStruct = struct;
            end
        end


        function [tString, tInt64] = epochSecondsUTCNow()
            % epochSecondsUTCNow Return epoch time in UTC in seconds as a string and an int64

            tInt64 = convertTo(datetime("now", TimeZone="UTC"), "epochTime", Epoch="1970-01-01", TicksPerSecond=1);
            tString = string(tInt64);
        end


        function tf = isTokenCachingDisabled()
            % isTokenCachingDisabled Return true if DISABLE_DATABRICKS_TOKEN_CACHE is true otherwise false
            % Testing of DISABLE_DATABRICKS_TOKEN_CACHE is not case sensitive.

            envVar = getenv("DISABLE_DATABRICKS_TOKEN_CACHE");
            if strlength(envVar) == 0
                tf = false;
            else
                if strcmpi(envVar, 'true')
                    tf = true;
                else
                    tf = false;
                end
            end
        end
    end
end
