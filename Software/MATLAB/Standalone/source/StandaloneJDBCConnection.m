classdef StandaloneJDBCConnection %  < matlab.mixin.CustomDisplay
    % STANDALONEJDBCCONNECTION Creates a JDBC based Database Toolbox connection
    %
    % The StandaloneJDBCConnection class is designed to provide standalone
    % functionality which can be used independently of the wider MATLAB Interface
    % for Databricks package.
    % This class has no external dependencies to the the Databricks, making this
    % class simpler to integrate in certain scenarios where a Database Toolbox based
    % interface *only* is required, i.e. other interfaces such as the REST API or
    % Databricks Connect are not required. A JSON settings file is also
    % typically used. A template can be found in:
    %   /Software/MATLAB/config/databricks_standalone_jdbc_settings.json
    %
    % Settings are applied with the following precedence:
    %   1) Arguments to the constructor
    %   2) Values defined in databricks_standalone_jdbc_settings.json where present
    %   3) Defaults defined in configureDefaults where present
    %
    % By design this class does not use the same configuration and settings files
    % as the wider MATLAB Interface for Databricks package.
    % Required values for which a default is not defined must be provided are
    % function arguments.
    %
    % The expectation is that this file will be copied outside the context
    % of the Databricks package and so the MATLAB path is searched for the
    % location of the databricks_standalone_jdbc_settings.json file.
    % All fields in the JSON file are specified as scalar strings.
    %
    % If using the wider package then the databricks.JDBCConnection class provides
    % similar functionality with deeper integration and so is then recommended.
    %
    % The primary role of this class is to construct the connection URL used
    % by the Databricks JDBC driver. Essentially this URL combines a large number
    % of configuration values. This is somewhat error prone to construct by hand.
    %
    % The Connection object is stored in the Connection property.
    %
    % MATLAB R2022b or later and Database Toolbox are required.
    %
    % The following optional named arguments can be used to override the values
    % obtained from the JSON file. Aside from a logical verbose flag arguments are
    % scalar strings as the package's dedicated classes and enumerations are
    % assumed not to be available.
    %
    % | Name                    | Required |  JSON file default  | Description                       |
    % | ----------------------- | -------- | ------------------- | --------------------------------- |
    % | settingsFile            |          | databricks_standalone_jdbc_settings.json | Non default must be set as a function argument |
    % |                         |          |                     | |
    % | host                    |   Yes    |                     | Workspace URL e.g. "https://adb-1234567890123456.1.azuredatabricks.net" |
    % | port                    |   Yes    | 443                 | Port used by the driver, specified as a string |
    % | orgId                   |   Yes    |                     | Workspace org_id e.g. "1234567890123456" |
    % | clusterId               |   Yes    |                     | Id of cluster or SQL Warehouse e.g. "0912-173539-zf4ob0md" |
    % | schema                  |   Yes    |                     | Name of the database/schema to use |
    % | catalog                 |   Yes    |                     | Name of the Unity Catalog catalog |
    % |                         |          |                     | |
    % | authMethod              |   Yes    | OauthU2M            | Authentication method, one of PAT, OauthU2M, OauthM2M |
    % | token                   |          |                     | Token if using authMethod PAT |
    % | clientId                |          |                     | Client Id if using OauthM2M |
    % | clientSecret            |          |                     | Client secret if using OauthM2M |
    % | passthroughAccessToken  |          |                     | Value for an access token that is passed opaquely |
    % | passthroughRefreshToken |          |                     | Value for a refresh token that is passed opaquely |
    % | enableTokenCache        |          | 1                   | 1 or 0, specified as a string, enable caching of Oauth Tokens |
    % | tokenCachePassPhrase    |          | InsecureTokenCachePassPhrase | Optional pass phrase to protect cached tokens |
    % |                         |          |                     | |
    % | scope                   |          |                     | Sets the scope used with Oauth flows |
    % | oauthService            |   Yes    | Databricks          | Oauth service provider one of Databricks, EntraID, Unspecified |
    % | oauth2ClientId          |          | databricks-sql-jdbc | Defaults to: databricks-sql-jdbc |
    % | vendor                  |          |                     | Set to azure or aws |
    % |                         |          |                     | |
    % | driverClass             |   Yes    | com.databricks.client.jdbc.Driver | JDBC driver class |
    % | jarFilePath             |   Yes    | Shaded-Databricks-JDBC-Driver-0.0.2.jar | JDBC driver jar file |
    % |                         |          |                     | |
    % | connectionURL           |          |                     | Overrides the complete connection URL value |
    % | connectionURLAppend     |          |                     | Value appended to the connection URL, can be used to add further values to the connection URL |
    % | httpPath                |          |                     | Overrides the httpPath portion of the connection URL |
    % | ssl                     |          | 1                   | 1 or 0, specified as a string |
    % | thriftTransport         |          |                     | Thrift transport flag |
    % |                         |          |                     | |
    % | logLevel                |          | 0                   | Specified as a string |
    % | verbose                 |          | 1                   | Function argument only, specified as a logical |
    %
    % The following authentication arguments are required:
    %
    % | Auth method | Authentication arguments |
    % | ----------- | ------------------------ |
    % | PAT         | token                    |
    % | OauthU2M    | None                     |
    % | OauthM2M    | clientId & clientSecret  |
    % 
    % If a passthroughAccessToken and optional passthroughRefreshToken are provided
    % They will be used directly as passthrough value for authentication and the
    % drivers authentication mechanisms will not be used. Be aware that access
    % tokens typically expire after a certain amount of time, after which you must
    % either refresh the token or obtain a new token(s).
    %
    % If running on Databricks then the Databricks JDBC driver's OAuthU2M support
    % cannot be used and passthroughAccessToken or alternative authentication
    % method should be used.
    %
    % This class requires the Databricks JDBC driver v2.7.1 and greater.
    % The shaded JDBC driver provided with the MATLAB Interface for Databricks
    % is required. This differs very slightly from the original Databricks driver.
    % The driver's license can be found here:
    %       https://www.databricks.com/legal/jdbc-odbc-driver-license
    % Should a custom updated version be required, the MATLAB interface for Databricks
    % provides the means to produce the shaded version. The driver included
    % in the package can be found at: Software/MATLAB/lib/jar/Shaded-Databricks-JDBC-Driver-0.0.2.jar
    % This function assumes that this driver file has been added to MATLAB dynamic
    % Java class path, see the javaaddpath() command.
    %
    % The class is not added to the MATLAB path by the `Software/MATLAB/startup.m` function
    % as it is intended to be used in isolation and so should be added to the path manually
    % or as part of a wider code base.
    %
    % This functionality is independent of the Spark.sql() functionality which
    % can also be used to execute SQL commands on Databricks.
    %
    % Call the Connection's close method when the connection is no longer needed.
    % The object's close method will also call the connection's close method.
    %
    % If a connection cannot be created an empty database.jdbc.connection is returned
    % in the connection property. If a JDBC Driver Error is returned in the connection's
    % Message property it will be displayed but an error will not be raised directly.
    %
    % Examples:
    %    % Can be moved to a namespace if desired
    %    % Not added to the path by startup.m
    %    j = StandaloneJDBCConnection(schema='myDatabaseName', ...);
    %    conn = j.Connection;
    %
    %    j = StandaloneJDBCConnection; % Use default schema/database name from the settings file
    %    resultTable = fetch(j.Connection, "SELECT * from myTableName")
    %
    %
    % Sample databricks_standalone_jdbc_settings.json file:
    %
    % {
    %     "host":"https://adb-1234567890123456.1.azuredatabricks.net",
    %     "port": "",
    %     "orgId": "1234567890123456",
    %     "clusterId": "0912-173539-zf4ob0md",
    %     "schema": "myschema",
    %     "catalog": "mycatalog",
    %
    %     "authMethod": "OauthU2M",
    %     "token":"",
    %     "clientId": "",
    %     "clientSecret": "",
    %     "passthroughAccessToken": "",
    %     "passthroughRefreshToken": "",
    %     "enableTokenCache": "",
    %     "tokenCachePassPhrase": "",
    %     
    %     "scope": "",
    %     "oauthService": "Databricks",
    %     "oauth2ClientId": "",
    %     "vendor": "",
    %
    %     "driverClass": "",
    %     "jarFilePath": "",
    %
    %     "connectionURL": "",
    %     "connectionURLAppend": "",
    %     "httpPath": "",
    %     "ssl": "",
    %     "thriftTransport": "",
    %
    %     "logLevel": ""
    %     "verbose": "1"
    % }
    %
    % Values set to "" are ignored.
    %
    % If specifying a jarFilePath argument using a Windows path that contains "\"
    % In the JSON settings file escape any slashes with an additional slash as
    % required by JSON syntax, e.g.: "jarFilePath": "c:\\mydir\\Shaded-Databricks-JDBC-Driver-0.0.2.jar",
    %
    % See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf

    % TODO enable proxy support

    % Copyright 2024-2025 The MathWorks, Inc.

    properties
        Connection database.jdbc.connection
    end

    properties (Hidden)
        ConnectionURL string
    end

    methods
        function obj = StandaloneJDBCConnection(options)
            arguments
                % See also: configureDefaults() below
                options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.orgId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.schema string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.token string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.clientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.clientSecret string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.enableTokenCache string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.tokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.scope string {mustBeTextScalar}
                options.oauthService string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.vendor string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.driverClass string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.connectionURL string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.connectionURLAppend string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.thriftTransport string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) string = "1"
            end

            if isMATLABReleaseOlderThan("R2022b")
                fprintf(2, "This package requires MATLAB R2022b or later.\n");
                return; % will likely hit a hard error at a later point if allowed to continue
            end

            if isempty(ver('database'))
                fprintf(2, "Database Toolbox is not installed.\n");
                fprintf(2, "JDBC/ODBC/SQL Warehouse connections cannot be used.\n");
                return;
            end

            if ~usejava('jvm')
                fprintf(2, "MATLAB must be used with the JVM enabled.\n");
                return;
            end

            settings = configureDefaults(obj, options);

            [driverVersionMajor, driverVersionMinor] = checkJDBCDriver(obj, settings);
            checkDatasourceConflict(obj, settings);

            % Needs numerous JDBC driver settings to be validated in checkJDBCDriver
            settings = configureEnableTokenCache(obj, driverVersionMajor, driverVersionMinor, settings);

            % Package based authentication is not available in the standalone scenario
            if obj.nonzeroSettingsString(settings, "connectionURL")
                authSrc = "connectionURL";
                if options.verbose
                    fprintf("Authenticating using a provided Connection URL.\n")
                end
            elseif obj.nonzeroSettingsString(settings, "passthroughAccessToken")
                authSrc = "passthroughToken";
                if obj.nonzeroSettingsString(settings, "verbose")
                    if isfield(options, 'passthroughRefreshToken')
                        fprintf("Authenticating using a provided passthrough access token and refresh token.\n")
                    else
                        fprintf("Authenticating using a provided passthrough access token.\n")
                    end
                end
            elseif obj.isOnDatabricks && settings.authMethod == "OauthU2M"
                fprintf("When running on Databricks the Databricks JDBC driver cannot be used with OAuthU2M authentication.\n");
                fprintf("Checking for a passthroughToken instead.\n");
                authSrc = "passthroughToken";
                if ~obj.nonzeroSettingsString(settings, "passthroughAccessToken")
                    error("DATABRICKS:STANDALONEJDBCCONNECTION", "A passthroughAccessToken argument or alternative authentication method is required.");
                end
            else
                authSrc = "driverAuth";
                % Default case
                if obj.nonzeroSettingsString(settings, "verbose")
                    fprintf("Authenticating using the JDBC driver's built-in authentication support.\n")
                end
            end


            if strcmp(authSrc, "connectionURL")
                %% connectionURL
                if startsWith(options.connectionURL, "jdbc:databricks://", ignoreCase=true)
                    connectionURL = settings.connectionURL;
                else
                    error("DATABRICKS:STANDALONEJDBCCONNECTION", "Expected connection string to start with: jdbc:databricks://");
                end
            else
                %% Host
                obj.notSetError(settings, "host");
                %% Scheme
                if startsWith(settings.host, "http", IgnoreCase=true)
                    hostURI = matlab.net.URI(settings.host);
                    hostEncodedAuthority = string(hostURI.EncodedAuthority);
                else
                    hostEncodedAuthority = settings.host;
                end
                obj.notSetError(settings, "port");
                connectionURL = "jdbc:databricks://" + hostEncodedAuthority + ":" + settings.port;

                %% schema (must follow port directly)
                connectionURL = connectionURL + "/" + settings.schema + ";";

                %% httpPath
                if obj.nonzeroSettingsString(settings, "httpPath")
                    connectionURL = connectionURL + "settings=" + settings.httpPath + ";";
                else
                    %% clusterId
                    obj.notSetError(settings, "clusterId");
                    %% orgId
                    obj.notSetError(settings, "orgId");
                    connectionURL = connectionURL + "httpPath=" + "sql/protocolv1/o/" + settings.orgId + "/" + settings.clusterId + ";";
                end

                %% ssl
                obj.notSetError(settings, "ssl");
                connectionURL = connectionURL + "ssl=" + settings.ssl + ";";

                %% thriftTransport
                if obj.nonzeroSettingsString(settings, "thriftTransport")
                    connectionURL = connectionURL + "thriftTransport=" + settings.thriftTransport + ";";
                end

                %% catalog
                if obj.nonzeroSettingsString(settings, "catalog")
                    connectionURL = connectionURL + "catalog=" + settings.catalog + ";";
                end

                %% Add authentication details
                [authStr, username, password] = getAuthArgs(obj, authSrc, settings);
                if strlength(authStr) == 0
                    error("DATABRICKS:STANDALONEJDBCCONNECTION", "Authentication values not set.");
                else
                    connectionURL = connectionURL + authStr;
                end

                %% UserAgentEntry
                connectionURL = connectionURL + "UserAgentEntry=" + obj.getUserAgent() + ";";

                %% LogLevel
                if obj.nonzeroSettingsString(settings, "logLevel")
                    connectionURL = connectionURL + "LogLevel=" + settings.logLevel + ";";
                end

                %% connectionURLAppend
                if obj.nonzeroSettingsString(settings, "connectionURLAppend")
                    connectionURL = connectionURL + settings.connectionURLAppend;
                end
            end
            obj.ConnectionURL = connectionURL;

            try
                obj.Connection = database(settings.schema, username, password, settings.driverClass, obj.ConnectionURL);
                if ~isempty(obj.Connection.Message)
                    fprintf(2, "Error JDBC connection not open, Message:\n%s\n\n", obj.Connection.Message);
                end
            catch ME
                fprintf(2, "Error creating JDBC connection, Message:\n%s\n\n", ME.message);
            end
        end


        function close(obj)
            if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.jdbc.connection')
                obj.Connection.close();
            end
        end
    end %methods


    methods(Hidden)
        function checkDatasourceConflict(obj, settings)
            arguments
                obj (1,1)
                settings struct
            end

            obj.notSetError(settings, "schema");
            datasources = listDataSources;
            namesCell = cellstr(datasources.Name');
            if ~isempty(namesCell)
                if any(contains(namesCell, settings.schema))
                    % This will fail if there is a datasource with the same name as
                    % obj.Name, the database name
                    % This is expected behavior for the database command and relates to
                    % argument handling in:
                    %     conn = database(___,Name,Value)
                    %     conn = database(databasename,username,password,driver,url)
                    % When the database name and datasource are the same
                    error('DATABRICKS:STANDALONEJDBCCONNECTION', 'An ODBC/JDBC datasource exists with the same name as the database: %s\nAmend the datasource name', settings.schema);
                end
            end
        end


        function [driverVersionMajor, driverVersionMinor, driverPatchVersion] = checkJDBCDriver(obj, settings)
            arguments
                obj (1,1)
                settings struct
            end

            driverVersionMajor = ""; %#ok<NASGU>
            driverVersionMinor = ""; %#ok<NASGU>
            driverPatchVersion = ""; %#ok<NASGU>

            % Check that the driver class can be found on the MATLAB Java class path
            if obj.nonzeroSettingsString(settings, "driverClass")
                if exist(settings.driverClass,'class') ~= 8
                    fprintf(2, 'Driver class: %s, not found on the Java class path.\n', settings.driverClass);
                    if obj.nonzeroSettingsString(settings, "jarFilePath")
                        onJCP = obj.checkClasspathForJDBCDriverJar(settings.jarFilePath, verbose=settings.verbose);
                        if ~isfile(settings.jarFilePath)
                            error("DATABRICKS:STANDALONEJDBCCONNECTION", "Databricks JDBC driver jar file not found: %s", settings.jarFilePath);
                        else
                            if ~onJCP
                                javaaddpath(settings.jarFilePath);
                                error("Adding JDBC driver to Java class path using javaaddpath(), retry.");
                            else
                                error("Unexpected error, the driver jar files exists and is on the javaclasspath.")
                            end
                        end
                    else
                        error("jarFilePath value is not configured in settings.");
                    end
                else
                    drv = javaObject(settings.driverClass);
                    driverVersionMajor = drv.getMajorVersion();
                    driverVersionMinor = drv.getMinorVersion();
                    if driverVersionMajor < 2
                        error('DATABRICKS:STANDALONEJDBCCONNECTION', "Databricks JDBC driver version 2.7 or greater is required.");
                    elseif driverVersionMajor == 2
                        if driverVersionMinor < 7
                            error('DATABRICKS:STANDALONEJDBCCONNECTION', "Databricks JDBC driver version 2.7 or greater is required.");
                        end
                    end
                end
            else
                error('DATABRICKS:STANDALONEJDBCCONNECTION', 'driverClass value configured in settings, cannot check for driver.');
            end
        end


        function settings = configureEnableTokenCache(obj, driverVersionMajor, driverVersionMinor, settings)
            arguments
                obj (1,1)
                driverVersionMajor (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                driverVersionMinor (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                settings struct
            end
            
            % Should only be called on v2.7 or greater
            if double(driverVersionMajor) < 2
                error('DATABRICKS:STANDALONEJDBCCONNECTION', "Databricks JDBC driver version 2.7 or greater is required.");
            end

            if double(driverVersionMajor) == 2  && double(driverVersionMinor) < 7
                error('DATABRICKS:STANDALONEJDBCCONNECTION', "Databricks JDBC driver version 2.7 or greater is required.");
            end

            % Assume fixed in v3, enable if not set already
            if double(driverVersionMajor) > 2
                if ~obj.nonzeroSettingsString(settings, "enableTokenCache")
                    settings.enableTokenCache = "1";
                end
            end

            if double(driverVersionMajor) == 2
                % Assume fixed in v2.8, enable if not set already
                if double(driverVersionMinor) >= 7
                    % Assumes the JDBC driver is now on 2.7.3 or greater
                    % The driver does not expose the patch version
                    if ~obj.nonzeroSettingsString(settings, "enableTokenCache")
                        settings.enableTokenCache = "1";
                    end
                else
                    if ~obj.nonzeroSettingsString(settings, "enableTokenCache")
                        if ispc
                            settings.enableTokenCache = "1";
                        else
                            fprintf(2, "Disabling enableTokenCache for JDBC driver version 2.7, as a driver bug workaround, upgrade JDBC driver.\n");
                            settings.enableTokenCache = "0";
                        end
                    end
                end
            end
        end


        function settings = configureDefaults(obj, options)
            arguments
                obj (1,1)
                options struct
            end
            % Read settings from a json file and options as named arguments.
            % Settings are not related to the <prefdir>/databricks-settings.json file.
            % Options override the settings file when present in both.
            % The default setting file name is: databricks_standalone_jdbc_settings.json
            settings = obj.getSettings(options);

            % Set defaults if not set by arguments or the JSON file
            if ~obj.nonzeroSettingsString(settings, "authMethod")
                settings.authMethod = "OauthU2M";
            end
            if ~obj.nonzeroSettingsString(settings, "oauthService")
                settings.oauthService = "Databricks";
            end
            if ~obj.nonzeroSettingsString(settings, "oauth2ClientId")
                settings.oauth2ClientId = "databricks-sql-jdbc";
            end
            if ~obj.nonzeroSettingsString(settings, "port")
                settings.port = "443";
            end
            if ~obj.nonzeroSettingsString(settings, "driverClass")
                settings.driverClass = "com.databricks.client.jdbc.Driver";
            end
            if ~obj.nonzeroSettingsString(settings, "jarFilePath")
                settings.jarFilePath = "Shaded-Databricks-JDBC-Driver-0.0.2.jar";
            end
            if ~obj.nonzeroSettingsString(settings, "tokenCachePassPhrase")
                settings.tokenCachePassPhrase = "InsecureTokenCachePassPhrase";
            end
            if ~obj.nonzeroSettingsString(settings, "ssl")
                settings.ssl = "1";
            end
            if ~obj.nonzeroSettingsString(settings, "logLevel")
                settings.logLevel = "0";
            end

            % Convert verbose to a logical as that is how it will be used i.e. not in
            % the connection URL
            if ~obj.nonzeroSettingsString(settings, "verbose")
                settings.verbose = true;
            else
                if strcmpi(settings.verbose, "1") || strcmpi(settings.verbose, "true")
                    settings.verbose = true;
                else
                    settings.verbose = false;
                end
            end
        end


        function [authStr, username, password] = getAuthArgs(obj, authSrc, settings)
            % GETAUTHARGS Returns the auth section of the connection URL incl. scope
            % Also returns the username and password fields as required for PAT
            arguments
                obj (1,1)
                authSrc string {mustBeTextScalar, mustBeNonzeroLengthText}
                settings struct
            end

            username = "";
            password = "";

            if strcmp(authSrc, "passthroughToken")
                authStr = "AuthMech=11;Auth_Flow=0;Auth_AccessToken=" + settings.passthroughAccessToken + ";";
                % Add refresh token if present
                if obj.nonzeroSettingsString(settings, "passthroughRefreshToken")
                    authStr = authStr + "Auth_RefreshToken=" + settings.passthroughRefreshToken + ";";
                end

            elseif strcmp(authSrc, "driverAuth")
                % The JDBCConnection class should be authenticated already
                % and so the Token should be configured and ready to passthrough
                obj.notSetError(settings, "authMethod");
                switch settings.authMethod
                    case "PAT"
                        obj.notSetError(settings, "token");
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + settings.token + ";";
                        username = "token";
                        password = settings.token;

                    case "OauthM2M"
                        obj.notSetError(settings, "clientId");
                        obj.notSetError(settings, "clientSecret");
                        authStr = "AuthMech=11" + ";Auth_Flow=1" + ";OAuth2ClientId=" + settings.clientId + ";OAuth2Secret=" + settings.clientSecret + ";";

                    case "OauthU2M"
                        authStr = "AuthMech=11" + ";Auth_Flow=2" + ";";
                        if obj.nonzeroSettingsString(settings, "enableTokenCache")
                            authStr = authStr + "EnableTokenCache=" + settings.enableTokenCache + ";";
                        end
                        if obj.nonzeroSettingsString(settings, "tokenCachePassPhrase")
                            authStr = authStr + "TokenCachePassPhrase=" + settings.tokenCachePassPhrase + ";";
                        end
                        % PWD Set the PWD property to a password of your choice. This is the key used for refresh token encryption.
                        % See: https://learn.microsoft.com/en-us/azure/databricks/integrations/jdbc/authentication#--oauth-user-to-machine-u2m-authentication

                    otherwise
                        error("DATABRICKS:STANDALONEJDBCCONNECTION", "Unexpected authentication method.");
                end
            end

            %% Scope
            obj.notSetError(settings, "oauthService")
            scopeArgs = {};
            if obj.nonzeroSettingsString(settings, "scope")
                scopeArgs{end+1} = "scope";
                scopeArgs{end+1} = settings.scope;
            end
            if obj.nonzeroSettingsString(settings, "oauth2ClientId")
                scopeArgs{end+1} = "oauth2ClientId";
                scopeArgs{end+1} = settings.oauth2ClientId;
            end
            if obj.nonzeroSettingsString(settings, "vendor")
                scopeArgs{end+1} = "vendor";
                scopeArgs{end+1} = settings.vendor;
            end
            scopeStr = obj.getScope(settings.authMethod, settings.oauthService, scopeArgs{:});
            authStr = authStr + scopeStr;
        end


        function userAgent = getUserAgent(options)
            % getUserAgent Returns user agent based on a MATLAB Release value
            % Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
            % By default the current release is used.
            %
            % Example:
            %   userAgent = databricks.Object.getUserAgent(release="R2025b");

            arguments
                options.release string {mustBeTextScalar, mustBeNonzeroLengthText} = matlabRelease().Release
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


        function tf = checkClasspathForJDBCDriverJar(obj, jarFile, options)
            arguments
                obj %#ok<INUSA>
                jarFile string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
            % Warn if a candidate JDBC driver jar is not found on the path
            jcpD = javaclasspath;
            if ~any(contains(jcpD, jarFile))
                tf = false;
                if options.verbose
                    fprintf(2, 'Expected Databricks JDBC driver Jar: %s not found on Java dynamic class path.\n', jarFile);
                end
            else
                tf = true;
            end
        end


        function scope = getScope(obj, authMethod, oauthService, options)
            % getScope Returns a scope field as a string
            arguments
                obj %#ok<INUSA>
                authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
                oauthService string
                options.scope string {mustBeTextScalar}
                options.oauth2ClientId string
                options.vendor string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if ~(strcmp(authMethod, "OauthU2M") || strcmp(authMethod, "OauthM2M"))
                % fprintf(2, "Scope value should only be set when using OauthU2M or OauthM2M.\n");
                scope = "";
                return;
            end

            if isfield(options, "scope") && strlength(options.scope) > 0
                scope = "OAuth2ConnAuthAuthscopeKey=" + options.scope + ";";
            else
                switch oauthService
                    case "Databricks"
                        if strcmpi(authMethod, "OauthU2M")
                            scope = "OAuth2ConnAuthAuthscopeKey=sql, offline_access;";
                            if isfield(options, "oauth2ClientId") && ~strcmp(options.oauth2ClientId, "databricks-sql-jdbc") ...
                                    && isfield(options, "vendor") && strcmpi(options.vendor, "azure")
                                scope = "OAuth2ConnAuthAuthscopeKey=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/user_impersonation, offline_access;";
                            end

                        elseif strcmpi(authMethod, "OauthM2M")
                            if isfield(options, "oauth2ClientId") && strcmp(options.oauth2ClientId, "databricks-sql-jdbc") % Updated for driver version 2.8.2
                                scope = "OAuth2ConnAuthAuthscopeKey=sql;";
                            else
                                if isfield(options, "vendor")  && strcmpi(options.vendor, "azure")
                                    scope = "OAuth2ConnAuthAuthscopeKey=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default;";
                                else
                                    scope = "OAuth2ConnAuthAuthscopeKey=sql, offline_access;";
                                    % This case does not seem to be documented
                                end
                            end
                        else
                            % Don't override the scope based on the behavior of driver v 2.6.36
                            scope = "";
                        end

                    case "EntraID"
                        % Don't override the scope based on the behavior of driver v 2.6.36
                        scope = "";

                    case "Unspecified"
                        scope = ""; % Do nothing, leave it to the driver

                    otherwise
                        error("DATABRICKS:JDBCConnection", "Unexpected OauthService value: %s", oauthService);
                end
            end
        end


        function settings = getSettings(obj, constructorArgs, options)
            arguments
                obj %#ok<INUSA>
                constructorArgs (1,1) struct
                options.verbose (1,1) logical = true
            end

            if isfield(constructorArgs, "settingsFile")
                settingsFile = constructorArgs.settingsFile;
            else
                settingsFile = "databricks_standalone_jdbc_settings.json";
            end

            % Initial Settings are based on arguments to the constructor which may have defaults
            % i.e. the options to the constructor
            settings = constructorArgs;

            % Check for a settings file
            settingsFilePath = which(settingsFile);
            if isempty(settingsFilePath)
                if options.verbose
                    fprintf(2, "Settings file not configured.\n");
                end
            elseif ~isfile(settingsFilePath)
                if options.verbose
                    fprintf(2, "Settings file not found: %s\n", settingsFilePath);
                end
            else
                try
                    jsonSettings = jsondecode(fileread(settingsFilePath));
                catch ME
                    error("DATABRICKS:STANDALONEJDBCCONNECTION", "Unable to read: %s, check JSON syntax.\nMessage: %s", settingsFilePath, ME.message);
                end

                % If a field exists in the settingsFile that is not set in the
                % values from the constructor arguments set it otherwise the
                % constructor argument value takes precedence.
                jsonSettingsFields = fieldnames(jsonSettings);
                for n = 1:numel(jsonSettingsFields)
                    if ~isfield(constructorArgs, jsonSettingsFields{n})
                        settings.(jsonSettingsFields{n}) = jsonSettings.(jsonSettingsFields{n});
                    end
                end
            end

            % Return settings as strings
            settingsFields = fieldnames(settings);
            for n = 1:numel(settingsFields)
                if ischar(settings.(settingsFields{n}))
                    settings.(settingsFields{n}) = string(settings.(settingsFields{n}));
                elseif isStringScalar(settings.(settingsFields{n}))
                    % do nothing
                else
                    fprintf(2, "Unexpected settings fields class type for: %s, %s\n", settingsFields{n}, class(settings.(settingsFields{n})));
                end
            end
        end


        function tf = nonzeroSettingsString(obj, settings, name)
            arguments
                obj %#ok<INUSA>
                settings (1,1) struct
                name string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isfield(settings, name) && ~isempty(settings.(name)) && (isStringScalar(settings.(name)) || ischar(settings.(name))) && strlength(settings.(name)) > 0
                tf = true;
            else
                tf = false;
            end
        end


        function tf = nonEmptySettingsString(obj, settings, name)
            arguments
                obj %#ok<INUSA>
                settings (1,1) struct
                name string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isfield(settings, name) && ~isempty(settings.(name)) && (isStringScalar(settings.(name)) || ischar(settings.(name)))
                tf = true;
            else
                tf = false;
            end
        end


        function notSetError(obj, settings, name)
            arguments
                obj
                settings (1,1) struct
                name string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if ~obj.nonzeroSettingsString(settings, name)
                error("DATABRICKS:STANDALONEJDBCCONNECTION", "Field: %s is not found or configured in settings or options", name);
            end
        end

        function tf = isOnDatabricks(~)
            % ISONDATABRICKS Returns true if running on Databricks otherwise false
            % Tests the existence of the DB_HOME environment variable

            str = string(getenv("PYSPARK_PYTHON"));
            tf = str.startsWith("/databricks/python");
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                if ~isempty(obj.ConnectionURL)
                    cu = obj.ConnectionURL;
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
                    art = extractBetween(cu, "Auth_RefreshToken=", ";");
                    if strlength(art) > 0
                        cu = strrep(cu, art, "<REDACTED>");
                    end
                    aat = extractBetween(cu, "Auth_AccessToken=", ";");
                    if strlength(aat) > 0
                        cu = strrep(cu, aat, "<REDACTED>");
                    end
                    secret = extractBetween(cu, "OAuth2Secret=", ";");
                    if strlength(secret) > 0
                        cu = strrep(cu, secret, "<REDACTED>");
                    end
                    groups.PropertyList.ConnectionURL = cu;
                end
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods
end