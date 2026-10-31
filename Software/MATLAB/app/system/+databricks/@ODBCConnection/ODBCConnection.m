classdef ODBCConnection < databricks.Object & matlab.mixin.CustomDisplay
    % ODBCConnection Creates a Database Toolbox connection object using ODBC
    %
    % The primary role of this class is to construct the dsnless string used
    % by the Databricks ODBC driver. Essentially this string combines a large number
    % of configuration values. This is error prone to construct by hand.
    %
    % The Connection object is stored in the ODBCConnection's Connection property.
    % By default the class will use the same authentication provider chain as
    % used by the REST API interfaces, see Documentation/Authentication.md.
    %
    % The following optional named arguments can be used to override the values
    % obtained from settings & configuration files and defaults.
    %
    %    Name                       Type      Default
    %    --------------------------------------------
    %    % ODBC Driver configuration
    %    driver                     string
    %
    %    % Provide the complete dsnless connection string directly
    %    dsnless                    string
    %    % Append to a generated dsnless string
    %    dsnlessAppend              string
    %
    %    % Databricks host and port
    %    host                       string
    %    port                       string    "443"
    %
    %    % Set a schema and catalog
    %    schema                     string    "default"
    %    catalog                    string
    %
    %    % Set a specific cluster, should be a databricks.Cluster object or scalar text
    %    cluster                    databricks.Cluster or string
    %
    %    % Authentication
    %    useDriverAuth              logical   true;
    %    authMethod                 matlab.databricks.AuthMethod    Settings file authMethod value
    %    profileName                string    Settings file profileName value
    %
    %    % Oauth2
    %    OauthService               matlab.databricks.OauthService    matlab.databricks.OauthService.Databricks
    %    OAuth2ClientId             string    "databricks-sql-odbc"
    %    passthroughAccessToken     string
    %    passthroughRefreshToken    string
    %    scope                      string
    %    % Set the TokenCachePassPhrase argument to a password of your choice.
    %    % This is used for refresh token encryption when using driver based authentication.
    %    % The default is the user's username, this is NOT secure.
    %    tokenCachePassPhrase       string
    %    enableTokenCache           logical
    %    cacheFilePath              string
    %
    %    httpPath                   string
    %    ssl                        logical   true
    %    thriftTransport            int32     2
    %    defaultStringColumnLength  int32
    %
    %    logLevel                   string    "1"
    %    verbose                    logical   true
    %
    %  Descriptions
    %  ------------
    %  schema name of the database/schema to use.
    %
    %  catalog set the Unity Catalog catalog.
    %
    %  Leading and trailing whitespace is removed from unescaped catalog and schema\
    %  arguments.
    %  If a catalog or schema contains a hyphen or space and is not already escaped
    %  using backticks, the backticks will be added automatically. This does not apply
    %  if they are named in the SQL statement.
    %
    %  authMethod a matlab.databricks.AuthMethod
    %  to force a given authentication method default preferred method
    %  is not used. See: Documentation/Authentication.md
    %
    %  profileName a scalar text name for a profile to be sourced
    %  from a .databrickscfg file. See: Documentation/Authentication.md
    %
    %  passthroughAccessToken value for a token that is passed opaquely.
    %
    %  tokenCachePassPhrase, on non Windows systems an insecure default is applied
    %  On Windows system this is not required.
    %
    %  scope set the scope used with Oauth flows.
    %
    %  OauthService specify an Oauth service provider.
    %
    %  dsnless overrides the complete connection string value.
    %
    %  dsnlessAppend a value appended to the connection string.
    %
    %  httpPath overrides the httpPath portion of the connection string.
    %
    %  defaultStringColumnLength Sets the maximum number of characters that can be
    %  contained in STRING columns. By default, the columns metadata for Spark does
    %  not specify a maximum length for STRING columns. In a future MATLAB release
    %  this can be used to address string truncation for long strings > 4000
    %  characters in length.
    %
    %  logLevel a string text logging level, the default value is: "1".
    %
    %  verbose a logical flag to enable more or less feedback,
    %  default is true.
    %
    % This class uses the Databricks ODBC driver v2.8.2 and greater.
    %
    % This functionality is independent of the Spark.sql() functionality which
    % can also be used to execute SQL commands on Databricks.
    %
    % Call the Connection's close method when the connection is no longer needed.
    % The object's close method will also call the connection's close method.
    %
    % If a connection cannot be created an empty database.odbc.connection is returned
    % in the connection property. If an ODBC Driver Error is returned in the connection's
    % Message property it will be displayed but an error will not be raised directly.
    %
    % Saving a Data Source, for use with Database Explorer App, is not supported
    % for ODBC connections, if this is required use a JDBC based connection instead.
    %
    % Testing a connection, using testConnection(), is not supported for ODBC
    % based connections, if this is required use a JDBC based connection instead.
    %
    % Examples:
    %    o = databricks.ODBCConnection(schema='myDatabaseName');
    %    conn = o.Connection;
    %
    %    o = databricks.ODBCConnection; % Use default schema/database name: "default"
    %    conn = o.Connection;
    %
    % The dsnlessAppend argument can be used to add further values to the
    % dsnless connection string. It is appended to the constructed value.
    %
    % If using token passthrough an access token obtained by some means is passed
    % as a named (passthroughAccessToken) argument. Be aware that access tokens
    % typically expire after a certain amount of time, after which you must
    % either refresh the token or obtain a new one from the server.
    %
    % See also:
    %   https://www.databricks.com/spark/odbc-drivers-download
    %   https://docs.databricks.com/en/integrations/odbc/authentication.html
    %   https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf
    %   https://www.databricks.com/legal/jdbc-odbc-driver-license

    % Copyright 2024-2026 The MathWorks, Inc.

    properties
        Connection database.odbc.connection
    end

    properties (Hidden)
        DSNLess string
        ODBCDriver string
        ConnUsername string
        ConnPassword string
        Id string
        ErrBase string
    end

    methods
        function obj = ODBCConnection(options)
            arguments
                % ODBC Driver configuration
                options.driver string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Provide the connection string directly
                options.dsnless string {mustBeTextScalar, mustBeNonzeroLengthText}
                % Append to a generated dsnless string
                options.dsnlessAppend string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Databricks host and port
                options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText} = "443"

                % Set a schema and catalog
                options.schema string {mustBeTextScalar, mustBeNonzeroLengthText} = "default"
                options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Set a specific cluster, should be a databricks.Cluster object or scalar text
                options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}

                % Authentication
                options.useDriverAuth (1,1) logical = true;
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

                % Oauth2
                options.OauthService matlab.databricks.OauthService = matlab.databricks.OauthService.Databricks
                options.OAuth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText} = "databricks-sql-odbc"
                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar, mustBeNonzeroLengthText}
                % Set the TokenCachePassPhrase argument to a password of your choice.
                % This is used for refresh token encryption when using driver based authentication.
                % The default is the user's username, this is NOT secure.
                options.tokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.enableTokenCache (1,1) logical
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl (1,1) logical = true
                options.thriftTransport (1,1) int32 {mustBePositive, mustBeReal, mustBeFinite} = 2
                options.defaultStringColumnLength (1,1) int32 {mustBePositive, mustBeReal, mustBeFinite}

                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText} = "1"
                options.verbose (1,1) logical = true;
            end

            obj.ErrBase = "DATABRICKS:ODBCConnection";
            id = string.empty;
            warehouseId = string.empty;
            clusterId = string.empty;

            if ismac && isMATLABReleaseOlderThan("R2023b")
                fprintf(2, "ODBC connections are not supported on macOS for MATLAB releases older than R2023b.\n");
                return;
            end

            %% Check for datasources conflict, assumes options.schema is populated
            databricks.ODBCConnection.checkDataSources(options.schema);

            %% Driver configuration
            if isfield(options, "driver")
                driver = options.driverValue;
            else
                driver = databricks.ODBCConnection.getDefaultDriver();
            end
            obj.ODBCDriver = driver;

            %% Auth Source configuration
            username = "";
            password = "";
            if isfield(options, "dsnless") && strlength(options.dsnless) > 0
                % Auth is passed completely through dsnless connection string
                authSrc = "dsnless";
                if options.verbose
                    fprintf("Authenticating using a provided dsnless value.\n")
                end
            elseif isfield(options, 'passthroughAccessToken') && strlength(options.passthroughAccessToken) > 0
                authSrc = "passthroughToken";
                if options.verbose
                    if isfield(options, 'passthroughRefreshToken')
                        fprintf("Authenticating using a provided passthrough access token and refresh token.\n");
                    else
                        fprintf("Authenticating using a provided passthrough access token.\n");
                    end
                end
            elseif options.useDriverAuth == false
                authSrc = "pkgAuth";
                if options.verbose
                    fprintf("Authenticating using the MATLAB Interface for Databricks packages' authentication support.\n")
                end
            elseif options.useDriverAuth == true
                if databricks.internal.isOnDatabricks
                    authObjectArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                    obj.getAuth(authObjectArgs{:}, "enableAuthenticate", false, "verbose", false);
                    % The driver attempts to open a browser which is not supported
                    if obj.AuthMethod == matlab.databricks.AuthMethod.OauthU2M
                        fprintf("When running on Databricks the Databricks ODBC driver cannot be used with OAuthU2M authentication.\n");
                        fprintf("Using MATLAB Interface for Databricks OAuthU2M flow instead.\n");
                        authSrc = "pkgAuth";
                    else
                        authSrc = "driverAuth"; % Default case
                        if options.verbose
                            fprintf("Authenticating using the Databricks ODBC driver's built-in authentication support.\n");
                        end
                    end
                else
                    authSrc = "driverAuth";
                    % Default case
                    if options.verbose
                        fprintf("Authenticating using the Databricks ODBC driver's built-in authentication support.\n")
                    end
                end
            else
                error(obj.ErrBase, "Could not determine an authentication flow.\n");
            end

            if strcmp(authSrc, "dsnless")
                if startsWith(options.dsnless, "Driver=", ignoreCase=true)
                    dsnless = options.dsnless;
                    f = split(extractBetween(lower(connectionURL), "httppath=", ";"), "/");
                    clusterId = f(end);
                else
                    error(obj.ErrBase, "Expected dsnless string to start with: Driver=");
                end
            else
                %% get getAuth() details
                authObjectArgs = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                if strcmp(authSrc, "pkgAuth")
                    % Do full auth, not using the driver to auth
                    obj.getAuth("verbose", true, authObjectArgs{:});
                else
                    % Do auth to figure out actual authMethod for later on obj.AuthMethod
                    obj.getAuth("verbose", true, authObjectArgs{:}, "enableAuthenticate", false);
                    % If PAT is returned as the authMethod redo the process
                    % but enable auth in this case so that an obj.Token is
                    % configured
                    if obj.AuthMethod == matlab.databricks.AuthMethod.PAT
                        obj.getAuth("verbose", false, authObjectArgs{:});
                    end
                end

                %% Host
                envHost = getenv("DATABRICKS_SERVER_HOSTNAME");
                if ~isempty(envHost)
                    host = string(envHost);
                elseif isfield(options, 'host')
                    host = options.host;
                else
                    host = obj.Host;
                end
                if isempty(host) || strlength(host) == 0
                    error(obj.ErrBase, "Could not determine a host, either a dsnless string or host value must be provided.");
                end

                %% Scheme
                if startsWith(host, "http", IgnoreCase=true)
                    hostURI = matlab.net.URI(host);
                    hostEncodedAuthority = string(hostURI.EncodedAuthority);
                else
                    hostEncodedAuthority = host;
                end
                dsnless = "Driver=" + driver + ";" + "Host=" + hostEncodedAuthority + ";" + "Port=" + options.port + ";";

                %% schema
                if isfield(options, "schema")
                    if strlength(options.schema) > 0
                        escapedSchema = databricks.ODBCConnection.escapeUCName(options.schema);
                        dsnless = dsnless + "Schema=" + string(escapedSchema) + ";";
                    end
                else
                    % "default" set by default - should not arise
                    error(obj.ErrBase, "schema not set.");
                end

                %% httpPath
                args = matlab.utils.addArgs(options, ["httpPath", "cluster", "profileName"]);
                [httpPath, clusterId, warehouseId] = databricks.ODBCConnection.getHttpPath(args{:});
                dsnless = dsnless + httpPath;

                %% ssl
                dsnless = dsnless + "ssl=" + string(num2str(options.ssl)) + ";";

                %% thriftTransport
                if isfield(options, "thriftTransport")
                    dsnless = dsnless + "thriftTransport=" + string(options.thriftTransport) + ";";
                end

                %% defaultStringColumnLength truncation workaround support for a future release
                if isfield(options, "defaultStringColumnLength")
                    dsnless = dsnless + "DefaultStringColumnLength=" + string(options.defaultStringColumnLength) + ";";
                end

                %% catalog
                if isfield(options, "catalog")
                    escapedCatalog = databricks.ODBCConnection.escapeUCName(options.catalog);
                    dsnless = dsnless + "catalog=" + escapedCatalog + ";";
                end

                %% Proxy
                dsnless = dsnless + databricks.ODBCConnection.getHTTPProxy();

                %% Add authentication details
                args = matlab.utils.addArgs(options, ["passthroughAccessToken", "passthroughRefreshToken",...
                    "cacheFilePath", "scope", "OauthService", "OAuth2ClientId", ...
                    "TokenCachePassPhrase", "authMethod", "profileName"]);

                [authStr, username, password] = obj.getAuthArgs(authSrc, host, args{:});
                %% Add authentication details
                if strlength(authStr) == 0
                    error(obj.ErrBase, "Authentication values not set.");
                else
                    dsnless = dsnless + authStr;
                end

                %% UserAgentEntry
                dsnless = dsnless + "UserAgentEntry=" + databricks.Object.getUserAgent() + ";";

                %% LogLevel
                dsnless = dsnless + "LogLevel=" + options.logLevel + ";";

                %% dsnlessAppend
                if isfield(options, "dsnlessAppend")
                    dsnless = dsnless + options.dsnlessAppend;
                end
            end
            obj.DSNLess = dsnless;
            obj.ConnUsername = username;
            obj.ConnPassword = password;
            if strlength(id) > 0
                obj.Id = id;
            elseif strlength(clusterId) > 0
                obj.Id = clusterId;
            elseif strlength(warehouseId) > 0
                obj.Id = warehouseId;
            else
                error(errBase, "Could not determine a cluster or warehouse id.");
            end

            try
                obj.Connection = odbc(dsnless);
                if ~isempty(obj.Connection.Message)
                    fprintf(2, "Error ODBC connection not open, Message:\n%s\n\n", obj.Connection.Message);
                    % args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                    % if ~validateCluster(urlClusterId, "verbose", true, args{:})
                    %     fprintf("Error creating JDBC connection, Cluster validation failed\n");
                    % end
                end
                obj.checkDriverVersion("2.8.2");
            catch ME
                fprintf(2, "Error creating ODBC connection, Message:\n%s\n\n", ME.message);
            end
        end


        function delete(obj) %#ok<INUSD>
            % if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.odbc.connection')
            %     obj.Connection.close();
            % end
        end


        function close(obj)
            if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.odbc.connection')
                obj.Connection.close();
            end
        end


        function tf = copyToken(obj)
            % COPYTOKEN Copies the connection password/token to the system clipboard
            % Returns true if a value is copied, otherwise false.

            if ~isempty(obj.ConnPassword) && strlength(obj.ConnPassword) > 0
                clipboard('copy', obj.ConnPassword);
                tf = true;
            else
                fprintf(2, "Connection token/password is not set.\n");
                fprintf(2, "If using the Databricks ODBC driver's OauthU2M/M2M flow the token is not available.\n")
                fprintf(2, "Use: databricks.ODBCConnection(useDriverAuth=false)\n")
                tf = false;
            end
        end
    end %methods


    methods(Hidden)
        function checkDriverVersion(obj, requiredVersion, errorOnLt)
            arguments
                obj (1,1) databricks.ODBCConnection
                requiredVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
                errorOnLt (1,1) logical = false
            end

            errBase = "DATABRICKS:ODBCConnection";

            if isempty(obj.Connection)
                fprintf(2, "Connection property is empty, cannot check driver version.\n")
                return;
            end

            if isempty(obj.Connection) || strlength(obj.Connection.DriverVersion) == 0
                fprintf(2, "The connection DriverVersion property is not set, cannot check driver version.\n")
                return;
            end

            % Does not return a true semantic version, assume we can ignore
            % the 4th numeric field
            verFields = split(string(obj.Connection.DriverVersion), ".");
            if numel(verFields) == 0
                error(errBase, "Unexpected ODBC driver version value: %s", obj.Connection.DriverVersion);
            end
            if numel(verFields) > 3
                maxLen = 3;
            else
                maxLen = numel(verFields);
            end
            shortDriverVersion = join(verFields(1:maxLen), ".");
            driverSemVer = matlab.utils.SemVer(shortDriverVersion);
            requiredSemVer = matlab.utils.SemVer(requiredVersion);

            if driverSemVer < requiredSemVer
                if errorOnLt
                    error(errBase, "The ODBC driver is version: %s, expected: or greater.\n", obj.Connection.DriverVersion, requiredVersion);
                else
                    fprintf(2, "The ODBC driver is version: %s, expected: %s or greater.\n", obj.Connection.DriverVersion, requiredVersion);
                end
            end
        end


        function [authStr, username, password] = getAuthArgs(obj, authSrc, host, options)
            arguments
                obj (1,1) databricks.ODBCConnection
                authSrc string {mustBeTextScalar, mustBeNonzeroLengthText}
                host string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.OauthService matlab.databricks.OauthService
                options.OAuth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.tokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.enableTokenCache (1,1) logical

                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical
            end

            errBase = "DATABRICKS:ODBCConnection";

            username = "";
            password = "";
            if strcmp(authSrc, "passthroughToken")
                authStr = "AuthMech=11;Auth_Flow=0;Auth_AccessToken=" + options.passthroughAccessToken + ";";
                % Add refresh token if present
                if isfield(options, 'passthroughRefreshToken') && strlength(options.passthroughRefreshToken) > 0
                    authStr = authStr + "Auth_RefreshToken=" + options.passthroughRefreshToken + ";";
                end
                username = "token";
                password = options.passthroughAccessToken;

                if databricks.internal.isOnDatabricks
                    if strcmp(obj.Token, char(matlab.net.base64decode(getenv('MW_API_TOKEN_B64'))))
                        fprintf("The PAT has the same as the MW_API_TOKEN_B64 environment variable value.\n");
                        fprintf("If this value was derived from the user's context is will not support a JDBC connection.\n");
                        fprintf("An alternative PAT must be provided and typically updated in the .databrickscfg configuration file.\n");
                    end
                end

            elseif strcmp(authSrc, "pkgAuth")
                % The ODBCConnection class should be authenticated already
                % and so the Token should be configured and ready to passthrough
                switch obj.AuthMethod
                    case {matlab.databricks.AuthMethod.PAT}
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Personal Access Token is not configured.\n");
                        end
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + obj.Token + ";";
                        username = "token";
                        password = obj.Token;
                        if databricks.internal.isOnDatabricks
                            if strcmp(obj.Token, char(matlab.net.base64decode(getenv('MW_API_TOKEN_B64'))))
                                fprintf("The PAT has the same as the MW_API_TOKEN_B64 environment variable value.\n");
                                fprintf("If this value was derived from the user's context is will not support a JDBC connection.\n");
                                fprintf("An alternative PAT must be provided and typically updated in the .databrickscfg configuration file.\n");
                            end
                        end

                    case {matlab.databricks.AuthMethod.OauthM2M, matlab.databricks.AuthMethod.OauthU2M}
                        % The package is doing the auth so the configuration is
                        % similar to passsthrough
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Access token is not configured.\n");
                        end
                        % Same as passthrough
                        authStr = "AuthMech=11;Auth_Flow=0;Auth_AccessToken=" + obj.Token + ";";
                        if isempty(obj.AuthMethod)
                            error(errBase, "Authentication method is not configured.\n");
                        end
                        if isfield(options, "cacheFilePath")
                            cacheFilePath = options.cacheFilePath;
                        else
                            cacheFilePath = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(obj.AuthMethod);
                        end
                        refreshToken = databricks.internal.unifiedauthentication.Oauth.getCachedValue(obj.AuthMethod, "refresh_token", host, cacheFilePath=cacheFilePath);
                        if ~isempty(refreshToken) && strlength(refreshToken) > 0
                            authStr = authStr + "Auth_RefreshToken=" + refreshToken + ";";
                        end
                        username = "token";
                        password = obj.Token;

                    otherwise
                        error(errBase, "Unexpected authentication method.");
                end

            elseif strcmp(authSrc, "driverAuth")
                switch obj.AuthMethod
                    case matlab.databricks.AuthMethod.PAT
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Personal Access Token is not configured.\n");
                        end
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + obj.Token + ";";
                        username = "token";
                        password = obj.Token;

                    case matlab.databricks.AuthMethod.OauthM2M
                        authStr = "AuthMech=11" + ";Auth_Flow=1" + ";Auth_Client_ID=" + string(obj.ClientId) + ";Auth_Client_Secret=" + string(obj.ClientSecret) + ";";
                        if isfield(options, "tokenCachePassPhrase") && strlength(options.tokenCachePassPhrase) > 0
                            authStr = authStr + "TokenCachePassPhrase=" + options.tokenCachePassPhrase + ";";
                        end

                    case matlab.databricks.AuthMethod.OauthU2M
                        [~, uid] = fileparts(tempname);
                        authStr = "AuthMech=11" + ";Auth_Flow=2" + ";PWD=" +  uid + ";";
                        if isfield(options, "OAuth2ClientId")
                            authStr = authStr + "Auth_Client_ID=" + options.OAuth2ClientId + ";";
                        end
                        if isfield(options, "tokenCachePassPhrase") && strlength(options.tokenCachePassPhrase) > 0
                            authStr = authStr + "TokenCachePassPhrase=" + options.tokenCachePassPhrase + ";";
                        end
                        % PWD Set the PWD property to a password of your choice. This is the key used for refresh token encryption.
                        % See: https://docs.databricks.com/en/integrations/odbc/authentication.html

                    otherwise
                        error(errBase, "Unexpected authentication method.");
                end
            end

            if obj.AuthMethod == matlab.databricks.AuthMethod.OauthM2M || obj.AuthMethod == matlab.databricks.AuthMethod.OauthU2M
                scopeArgs = matlab.utils.addArgs(options, ["scope", "OauthService", "OAuth2ClientId"]);
                scopeStr = databricks.ODBCConnection.getScope(obj.AuthMethod, scopeArgs{:});
                authStr = authStr + scopeStr;
            end
        end
    end


    methods(Static)
        function DSNFilePath = generateDSNFile(options)
            % GENERATEDSNFILE Generates a DSN file based Databricks configuration details
            % The path to the file is returned.
            % If no path is provided <tempdir>/odbc.ini is used and overwritten if present.
            % If a path is provided the file is appended to if it already exists.
            % On Linux a [ODBC Data Sources] section is included.
            % Only PAT authentication is currently supported.
            %
            % See also: https://docs.databricks.com/aws/en/integrations/odbc/dsn
            %
            % Example:
            %   path = databricks.ODBCConnection.generateDSNFile()
            %
            % Note this file cannot be used by Database Toolbox to create a connection.

            arguments
                options.cluster
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText} = "443"
                options.driver string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl (1,1) logical = true
                options.thriftTransport (1,1) int32 = 2
                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText} = "1"

                options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.DSNFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.DSNSectionName = "Databricks"
                options.verbose (1,1) logical = true
            end

            errBase = "DATABRICKS:ODBCConnection";

            if isfield(options, "DSNFilePath")
                DSNFilePath = options.DSNFilePath;
                writeMode = "a";
            else
                DSNFilePath = fullfile(tempdir, "odbc.ini");
                writeMode = "w";
            end
            fid = fopen(DSNFilePath, writeMode);
            if fid == -1
                error(errBase, "Unable to open file: %s", DSNFilePath);
            end
            closeAfter = onCleanup(@() fclose(fid));

            if isunix && ~ismac
                % Write ODBC Data Sources section header, may collide!
                fprintf(fid, "\n[ODBC Data Sources]\n");
                fprintf(fid, "%s=Databricks ODBC Connector\n", options.DSNSectionName);
            end

            % Write section header, may collide!
            fprintf(fid, "\n[%s]\n", options.DSNSectionName);

            % Driver
            if isfield(options, "driver")
                fprintf(fid, "Driver=%s\n", options.driver);
            else
                fprintf(fid, "Driver=%s\n", databricks.ODBCConnection.getDefaultDriver());
            end

            % Host
            if isfield(options, 'host')
                host = options.host;
            else
                args = matlab.utils.addArgs(options, ["cfgFile", "profileName"]);
                host = databricks.internal.configurationprofile.ConfigFile.getProfileField("host", args{:});
            end
            fprintf(fid, "Host=%s\n", host);

            % Port
            fprintf(fid, "Port=%s\n", options.port);

            % Schema
            if isfield(options, "schema")
                escapedSchema = databricks.ODBCConnection.escapeUCName(options.schema);
                fprintf(fid, "Schema=%s\n", escapedSchema);
            end

            % HTTPPath
            args = matlab.utils.addArgs(options, ["httpPath", "cluster", "profileName"]);
            fprintf(fid, "HTTPPath=%s\n", databricks.ODBCConnection.getHttpPath(args{:}));

            % SSL
            fprintf(fid, "SSL=%s\n", string(num2str(options.ssl)));

            % ThriftTransport
            fprintf(fid, "ThriftTransport=%s\n" + string(options.thriftTransport));

            % logLevel
            fprintf(fid, "LogLevel=%s\n", options.logLevel);

            % User agent
            fprintf(fid, "UserAgentEntry=%s\n", databricks.Object.getUserAgent());

            % PAT Auth
            args = matlab.utils.addArgs(options, "settingsFile");
            authMethod = databricks.internal.settings.Settings.getSettingsField("authMethod", args{:});
            if isa(authMethod, 'matlab.internal.databricks.AuthMethod')
                authMethod = matlab.databricks.AuthMethod.(string(authMethod));
            end
            if ~isempty(authMethod)
                switch authMethod
                    case matlab.databricks.AuthMethod.PAT
                        fprintf(fid, "AuthMech=3\n");
                        fprintf(fid, "UID=token\n");
                        obj = databricks.Object();
                        obj.getAuth();
                        fprintf(fid, "PWD=%s\n", obj.Token);

                    otherwise
                        % TODO support M2M and U2M for DSNFile
                        fprintf(2, "Authentication method not currently supported: %s\n", authMethod);
                end
            else
                fprintf(2, "Authentication method not found.\n");
            end

            % Add a blank line at the end
            fprintf(fid, "\n");
        end
    end


    methods(Static, Hidden)
         function out = escapeUCName(in)
            arguments (Input)
                in string {mustBeTextScalar}
            end
            arguments (Output)
                out string {mustBeTextScalar}
            end

            if startsWith(in, "`") && endsWith(in, "`")
                out = in;
            else
                in = strip(in, "both");
                if contains(in, "-") || contains(in, " ")
                    out = "`" + in + "`";
                else
                    out = in;
                end
            end
        end

        function checkDataSources(schema)
            % CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
            arguments
                schema string {mustBeTextScalar, mustBeNonzeroLengthText} = "default"
            end

            schema = strip(schema, "both", "`");

            errBase = "DATABRICKS:ODBCConnection";

            datasources = listDataSources;
            namesCell = cellstr(datasources.Name');
            if ~isempty(namesCell)
                if any(contains(namesCell, schema))
                    % This will fail if there is a datasource with the same name as
                    % obj.Name, the database name
                    % This is expected behavior for the database command and relates to
                    % argument handling in:
                    %     conn = database(___,Name,Value)
                    %     conn = database(databasename,username,password,driver,url)
                    % When the database name and datasource are the same
                    error(errBase, 'An ODBC/JDBC datasource exists with the same name as the database: %s\nAmend the datasource name.', schema);
                end
            end
        end


        function driver = getDefaultDriver()
            if isunix && ~ismac
                defaultPath = "/opt/simba/spark/lib/64/libsparkodbc_sb64.so";
            elseif ismac
                defaultPath = "/Library/simba/spark/lib/libsparkodbc_sb64-universal.dylib";
            else
                defaultPath = "";
                % ispc case "C:\Program Files\Simba Spark ODBC Driver\lib\SparkODBC_sb64.dll";
                % Path doesn't work if used directly as per Linux and mac
            end
            if isfile(defaultPath)
                driver = defaultPath;
            else
                driver = "{Simba Spark ODBC Driver}"; % As configured by file exchange entry
            end
        end

        function tf = validateCluster(clusterId, options)
            % validateCluster Check the clusters state and Spark version
            arguments
                clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            tf = false; %#ok<NASGU>

            if strlength(clusterId) > 0
                args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                cluster = databricks.Cluster.findById(clusterId, args{:});
                if isempty(cluster)
                    if options.verbose
                        fprintf("Cluster: %s, not found.\n", clusterId);
                    end
                    tf = false;
                else
                    if isprop(cluster, 'state')
                        if strcmp(cluster.state, "RUNNING")
                            tf = true;
                        else
                            if options.verbose
                                fprintf("Cluster: %s, not running, state: %s\n", clusterId, cluster.state);
                                fprintf("To try to start the cluster use: databricks.Cluster.findById('%s').start\n", clusterId);
                            end
                            tf = false;
                        end
                    else
                        if options.verbose
                            fprintf("Cluster: %s, state property not found.\n", clusterId);
                        end
                        tf = false;
                    end
                end
            else
                if options.verbose
                    fprintf("Cluster Id not set.\n");
                end
                tf = false;
            end
        end


        function [httpPath, clusterId, warehouseId] = getHttpPath(options)
            arguments (Input)
                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
            end
            arguments (Output)
                httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                clusterId string
                warehouseId string
            end

            clusterId = string.empty;
            warehouseId = string.empty;
            errBase = "DATABRICKS:ODBCConnection:getHttpPath";

            envHTTPPath = getenv("DATABRICKS_HTTP_PATH");
            if ~isempty(envHTTPPath)
                f = split(string(envHTTPPath), "/");
                httpPath = "httpPath=" + string(envHTTPPath) + ";";
                if contains(lower(envHTTPPath), "/warehouses/")
                    warehouseId = f(end);
                else
                    clusterId = f(end);
                end
            elseif isfield(options, 'httpPath')
                f = split(string(options.httpPath), "/");
                if contains(lower(options.httpPath), "/warehouses/")
                    warehouseId = f(end);
                else
                    clusterId = f(end);
                end
                httpPath = "httpPath=" + options.httpPath + ";";
            else
                % Build the httpPath, only supports cluster mode not warehouse mode
                % Get the org_id
                org_id = databricks.internal.configurationprofile.ConfigFile.getProfileField("org_id", profileName=options.profileName);
                if isempty(org_id) || strlength(org_id) == 0
                    error(errBase+":NOORGID", "org_id not set in: %s", databricks.internal.configurationprofile.ConfigFile.getCfgFilePath());
                end
                %% cluster
                if isfield(options, "cluster")
                    if ischar(options.cluster)
                        clusterId = string(options.cluster);
                    elseif isa(options.cluster, 'databricks.Cluster')
                        if isprop(options.cluster, "cluster_id")
                            clusterId = options.cluster.cluster_id;
                        else
                            error(errBase+":NOCLUSTER", "cluster argument does not have a cluster_id property.");
                        end
                    elseif isStringScalar(options.cluster)
                        clusterId = options.cluster;
                    else
                        error(errBase+":CLUSTERTYPE", "Expected cluster optional argument to be of type char, scalar string or databricks.Cluster.");
                    end
                else
                    clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
                end
                if isempty(clusterId) || strlength(clusterId) == 0
                    error(errBase, "cluster_id not set in profile: %s, use: updateClusterId('cluster-id-value').", options.profileName);
                end
                httpPath = "httpPath=sql/protocolv1/o/" + org_id + "/" + clusterId + ";";
            end

            if isempty(warehouseId) && isempty(clusterId)
                error(errBase+":NOID", "Expected either a clusterId or warehouseId.");
            end
        end


        function scope = getScope(authMethod, options)
            % getScope Returns a scope field as a string
            arguments
                authMethod (1,1) matlab.databricks.AuthMethod
                options.scope string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.OauthService matlab.databricks.OauthService = matlab.databricks.OauthService.Databricks
                options.OAuth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            errBase = "DATABRICKS:ODBCConnection";

            if ~(authMethod == matlab.databricks.AuthMethod.OauthU2M || authMethod == matlab.databricks.AuthMethod.OauthM2M)
                fprintf(2, "Scope value should only be set when using OauthU2M or OauthM2M\n.");
                scope = "";
                return;
            end

            if isfield(options, "scope")
                scope = "Auth_Scope=" + options.scope + ";";
            else
                switch options.OauthService
                    case matlab.databricks.OauthService.Databricks
                        if authMethod == matlab.databricks.AuthMethod.OauthU2M
                            if strcmp(options.OAuth2ClientId, "databricks-sql-odbc")
                                scope = "Auth_Scope=sql offline_access;"; % Updated for driver version 2.8.2
                            else
                                if strcmpi(databricks.internal.settings.Settings.getSettingsField("vendor"), "azure")
                                    scope = "Auth_Scope=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/user_impersonation, offline_access;";
                                else
                                    scope = "Auth_Scope=sql offline_access;";
                                end
                            end
                        elseif authMethod == matlab.databricks.AuthMethod.OauthM2M
                            if strcmp(options.OAuth2ClientId, "databricks-sql-odbc") % Updated for driver version 2.8.2
                                scope = "Auth_Scope=all-apis;";
                                % https://docs.databricks.com/en/integrations/odbc/authentication.html says use: all-apis
                                % Potentially less recent driver Release Notes say to use "sql"
                            else
                                if strcmpi(databricks.internal.settings.Settings.getSettingsField("vendor"), "azure")
                                    scope = "Auth_Scope=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default;";
                                else
                                    scope = "Auth_Scope=all-apis;";
                                    % https://docs.databricks.com/en/integrations/odbc/authentication.html says use: all-apis
                                    % Potentially less recent driver Release Notes say to use "sql"
                                end
                            end
                        else
                            % Don't override the scope based on the behavior of driver v 2.6.36
                            scope = "";
                        end

                    case matlab.databricks.OauthService.EntraID
                        % Don't override the scope based on the behavior of driver v 2.6.36
                        scope = "";

                    case matlab.databricks.OauthService.Unspecified
                        scope = ""; % Do nothing, leave it to the driver

                    otherwise
                        error(errBase, "Unexpected OauthService value: %s", options.OauthService);
                end
            end
        end


        function proxyStr = getHTTPProxy()
            % SETHTTPPROXY Sets HTTP proxy environment variables for Python

            % Check if a MATLAB preference is set
            [tf, proxyURI] = matlab.databricks.detectProxy();

            if tf
                proxyStr = "UseProxy=1;";
                proxyStr = proxyStr + "ProxyHost=" + proxyURI.Host + ";";
                proxyStr = proxyStr + "ProxyPort=" + string(proxyURI.Port) + ";";
            else
                proxyStr = "";

                https_proxy = getenv("HTTPS_PROXY");
                http_proxy = getenv("HTTP_PROXY");
                if ~isempty(https_proxy) || strlength(https_proxy) > 0
                    fprintf(2, "A HTTPS_PROXY environment variable is set: %, however a proxy is not set in MATLAB's settings.\n", https_proxy);
                end
                if ~isempty(http_proxy) || strlength(http_proxy) > 0
                    fprintf(2, "A HTTP_PROXY environment variable is set: %, however a proxy is not set in MATLAB's settings.\n", http_proxy);
                end
            end
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                if ~isempty(obj.DSNLess)
                    cu = obj.DSNLess;
                    if ~endsWith(cu, ";")
                        cu = cu + ";"; % In case PWD etc. is the last field and is not terminated
                    end
                    pwd = extractBetween(cu, "PWD=", ";");
                    if strlength(pwd) > 0
                        cu = strrep(cu, pwd, "<REDACTED>");
                    end
                    tcpp = extractBetween(cu, "TokenCachePassPhrase=", ";");
                    if strlength(tcpp) > 0
                        cu = strrep(cu, tcpp, "<REDACTED>");
                    end
                    aat = extractBetween(cu, "Auth_AccessToken=", ";");
                    if strlength(aat) > 0
                        cu = strrep(cu, aat, "<REDACTED>");
                    end
                    secret = extractBetween(cu, "Auth_Client_Secret=", ";");
                    if strlength(secret) > 0
                        cu = strrep(cu, secret, "<REDACTED>");
                    end
                    groups.PropertyList.dsnless = cu;
                end
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods
end