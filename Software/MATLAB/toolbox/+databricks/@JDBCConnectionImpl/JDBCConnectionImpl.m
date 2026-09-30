classdef JDBCConnectionImpl < databricks.internal.Object & matlab.mixin.CustomDisplay
    % JDBCConnectionImpl Creates a Database Toolbox connection object
    %
    % The primary role of this class is to construct the connection URL used
    % by the Databricks JDBC driver. Essentially this URL combines a large number
    % of configuration values. This is error prone to construct by hand.
    %
    % The Connection object is stored in the JDBCConnectionImpl's Connection property.
    % By default the class will use the same authentication provider chain as
    % used by the REST API interfaces, see Documentation/Authentication.md.
    %
    % The following optional named arguments can be used to override the values
    % obtained from settings & configuration files and defaults.
    %
    %    Name                       Type      Default
    %    --------------------------------------------
    %    % JDBC Driver configuration
    %    driverClass                string    "com.databricks.client.jdbc.Driver"
    %    jarFilePath                string    matlab.internal.databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
    %    useDriverType              char      Must be either 'oss' or 'simba'
    %
    %    % Provide the connection string directly
    %    % connectionURL overrides the complete connection URL value.
    %    connectionURL              string
    %    % connectionURLAppend a value appended to the connection URL.
    %    connectionURLAppend        string
    %
    %    % Databricks host and port
    %    % If the DATABRICKS_SERVER_HOSTNAME environment variable value is set it will
    %    % override the host argument. The configuration file host value respects the
    %    % DATABRICKS_HOST environment variable.
    %    host                       string
    %    port                       string    "443"
    %
    %    % Set a schema and catalog
    %    % schema name of the database/schema to use
    %    schema                     string    "default"
    %    % catalog set the Unity Catalog catalog
    %    catalog                    string
    %
    %    % Leading and trailing whitespace is removed from unescaped catalog and schema\
    %    % arguments.
    %    % If a catalog or schema contains a hyphen or space and is not already escaped
    %    % using backticks, the backticks will be added automatically. This does not apply
    %    % if they are named in the SQL statement.
    %
    %    % Set a specific cluster, should be a databricks.Cluster(scalar) or a scalar string/char
    %    cluster                    databricks.Cluster or Cluster Id
    %
    %    % Authentication
    %    % By default the JDBC drivers authentication mechanism is used to
    %    % retrieve tokens for OAuth2 flows.
    %    useDriverAuth              logical   true
    %    % authMethod a matlab.internal.databricks.AuthMethod
    %    % to force a given authentication method default preferred method
    %    % is not used. See: Documentation/Authentication.md
    %    authMethod                 matlab.internal.databricks.AuthMethod    Settings file authMethod value
    %    %  profileName a scalar text name for a profile to be sourced
    %    % from a .databrickscfg file. See: Documentation/Authentication.md
    %    profileName                string    Settings file profileName value
    %
    %    % Oauth2
    %    % Specify an OAuth service provider
    %    OauthService               matlab.internal.databricks.OauthService    matlab.internal.databricks.OauthService.Databricks
    %    % Client Id for OAuth 2.0 authentication, not the OAuthM2M client_id
    %    oauth2ClientId             string    "databricks-sql-jdbc"
    %    % Value for a token that is passed opaquely
    %    passthroughAccessToken     string
    %    % Value for a token that is passed opaquely
    %    passthroughRefreshToken    string
    %    % set the scope used with OAuth flows
    %    scope                      string
    %    % Set the TokenCachePassPhrase argument to a password of your choice.
    %    % This is used for refresh token encryption when using driver based authentication.
    %    % The default is the user's username, this is NOT secure.
    %    TokenCachePassPhrase       string
    %    % Controls caching of tokens when using driver based
    %    % authentication only
    %    enableTokenCache           logical
    %    % cacheFilePath Path used to cache tokens when using the package's authentication only.
    %    % PATs are stored in <home directory>/.databrickscfg by default.
    %    cacheFilePath              string
    %
    %    % httpPath overrides the httpPath portion of the connection URL.
    %    % If the DATABRICKS_HTTP_PATH environment variable is set it overrides the
    %    % argument or derived valued.
    %    httpPath                   string
    %    ssl                        logical   true
    %    thriftTransport            int32
    %
    %    defaultStringColumnLength Sets the maximum number of characters that can be
    %    contained in STRING columns. By default, the columns metadata for Spark does
    %    not specify a maximum length for STRING columns. In a future MATLAB release
    %    this can be used to address string truncation for long strings > 4000
    %    characters in length.
    %    defaultStringColumnLength  int32
    %
    %    % Database Explorer App Data Source
    %    % Prevents automatic creation of a Data Source object
    %    disableSourceCreation      logical   false
    %    % Set a non default name for the DataSource
    %    dataSourceName             string    Databricks-<Cluster Id>
    %
    %    % Write optimization (Simba driver only)
    %    useNativeQuery                 logical   true
    %    enableNativeParameterizedQuery logical   false
    %
    %    % A string text logging level.
    %    logLevel                   string    "0"
    %    % A logical flag to enable more or less feedback,
    %    % default is true.
    %    verbose                    logical   true
    %
    % This class requires the Databricks Simba JDBC driver v2.7.3 and greater,
    % or the Databricks OSS JDBC driver v1.0.7 or greater.
    %
    % This functionality is independent of the Spark.sql() functionality which
    % can also be used to execute SQL commands on Databricks.
    %
    % Call the Connection's close method when the connection is no longer needed.
    % The object's close method will also call the connection's close method.
    % This is also called by the object's delete destructor.
    %
    % If a connection cannot be created an empty database.jdbc.connection is returned
    % in the connection property. If a JDBC Driver Error is returned in the connection's
    % Message property it will be displayed but an error will not be raised directly.
    %
    % Examples:
    %    j = databricks.JDBCConnectionImpl(schema='myDatabaseName');
    %    conn = j.Connection;
    %
    %    j = databricks.JDBCConnectionImpl; % Use default schema/database name: "default"
    %    data = fetch(j.Connection, "SELECT * FROM mycatalog.myschema.mytable LIMIT 10");
    %
    % The connectionURLAppend argument can be used to add further values to the
    % connection URL. It is appended to the constructed value.
    %
    % If using token passthrough an access token obtained by some means is passed
    % as a named (passthroughAccessToken) argument. A corresponding optional passthrough
    % refresh token can be passed using the passthroughRefreshToken argument.
    % Be aware that these tokens will expire. At which point a new connection must
    % be made with new tokens.
    %
    % The priority order for selecting the authentication mechanism is as follows:
    %   1) A connectionURL is provided is is used first.
    %   2) A passthroughAccessToken and optional passthroughRefreshToken is used second.
    %   3) If useDriverAuth is set to false then the package's authentication is used.
    %   4) (Default) The drivers authentication support is used.
    %      If using OAuthU2M the driver authentication is not supported and so the
    %      package's authentication is used.
    %
    % If using PAT authentication with MATLAB on Databricks then a token automatically
    % taken from the user context will not work and PAT value must be provided,
    % and typically updated in the .databrickscfg configuration file.
    %
    % See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf
    %
    % Logging has not been configured or minimized for the OSS driver by default
    % at this point for diagnostic purposes.
    %
    % By default if using a Java version > 8 and the OSS driver is present it will
    % be used.
    %
    % For OSS driver parameters see: https://raw.githubusercontent.com/databricks/databricks-jdbc/refs/heads/main/src/main/java/com/databricks/jdbc/common/DatabricksJdbcUrlParams.java

    % Copyright 2024-2026 The MathWorks, Inc.

    %% Write Performance
    % See: https://github.com/databricks/databricks-jdbc/issues/867
    % By default, the value is true. If set to true, JDBC will execute each statement
    % in the batch using the constructs of the V8 CLI protocol. The parameterized
    % query support of the V8 protocol does not support batch execution. Therefore,
    % each statement of the batch has to be executed individually by JDBC.
    % When EnableNativeParameterizedQuery is set to false, JDBC does not use the
    % parameterized query constructs in the V8 protocol. Instead, it does client-side
    % interpolation of the parameterized query. At the same time, JDBC does a
    % client side optimization to prepare a batch INSERT query

    properties
        Connection database.jdbc.connection
    end

    properties (Hidden)
        ConnectionURL string
        Opts database.options.jdbc.other.SQLConnectionOptions
        JarFilePath string
        DriverClass string
        ConnUsername string
        ConnPassword string
        Id string
        ErrBase string
    end

    methods
        function obj = JDBCConnectionImpl(options)
            arguments
                % JDBC Driver configuration
                options.driverClass string {mustBeTextScalar, mustBeNonzeroLengthText}= "com.databricks.client.jdbc.Driver"
                options.jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.useDriverType char {mustBeMember(options.useDriverType,{'simba','oss'})}

                % Provide the connection string directly
                options.connectionURL string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.connectionURLAppend string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Databricks host and port
                options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText} = "443"

                % Set a schema and catalog
                options.schema string {mustBeTextScalar, mustBeNonzeroLengthText} = "default"
                options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Set a specific cluster, should be a databricks.Cluster(scalar) or a scalar string/char
                options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}

                % Authentication
                options.useDriverAuth (1,1) logical = true;
                options.authMethod (1,1) matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

                % Oauth2
                options.OauthService matlab.internal.databricks.OauthService = matlab.internal.databricks.OauthService.Databricks
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText} = "databricks-sql-jdbc"
                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar}
                % Set the TokenCachePassPhrase argument to a password of your choice.
                % This is used for refresh token encryption when using driver based authentication.
                % The default is the user's username, this is NOT secure.
                options.TokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.settings.Settings.getSettingsField("username");
                options.enableTokenCache (1,1) logical
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl (1,1) logical = true
                options.thriftTransport (1,1) int32
                options.defaultStringColumnLength (1,1) int32 {mustBePositive, mustBeReal, mustBeFinite}

                % Database Explorer App Data Source
                options.disableSourceCreation (1,1) logical = false
                options.dataSourceName string {mustBeTextScalar, mustBeNonzeroLengthText}

                % Write optimization
                options.useNativeQuery (1,1) logical
                options.enableNativeParameterizedQuery (1,1) logical

                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText} = "0"
                options.verbose (1,1) logical = true;

                % Testing support: skip all initialization when true
                options.skipInit (1,1) logical = false
            end

            obj.ErrBase = "DATABRICKS:JDBCConnection";
            if options.skipInit
                return;
            end

            errBase = "DATABRICKS:JDBCConnection";
            id = string.empty;
            warehouseId = string.empty;
            clusterId = string.empty;

            %% Check for datasources conflict, assumes options.schema is populated
            databricks.JDBCConnectionImpl.checkDataSources(options.schema);
            if options.disableSourceCreation && isfield(options, "dataSourceName")
                fprintf(2, "A datasourceName is provided, yet source creation is disabled, skipping creation.\n")
            end

            %% Driver configuration
            javaVersion = databricks.JDBCConnectionImpl.getJavaVersion();
            if javaVersion < 8
                error(errBase, "Unsupported Java version: %d", javaVersion);
            end

            if isfield(options, 'useDriverType') && isfield(options, "jarFilePath")
                % Manual selection of the driver type and jar file
                useDriverType = options.useDriverType;
                jarFilePath = options.jarFilePath;
            elseif isfield(options, 'useDriverType') && ~isfield(options, "jarFilePath")
                % The driver type is set but the jar file is not
                useDriverType = options.useDriverType;
                if strcmp(useDriverType, 'oss')
                    jarFilePath = databricks.JDBCConnectionImpl.getDefaultJarFilePath('oss');
                elseif strcmp(useDriverType, 'simba')
                    jarFilePath = databricks.JDBCConnectionImpl.getDefaultJarFilePath('simba');
                end
            elseif ~isfield(options, 'useDriverType') && isfield(options, "jarFilePath")
                % The jar file is set bu the type is not
                jarFilePath = options.jarFilePath;
                if contains(jarFilePath, "OSS-Driver")
                    useDriverType = 'oss';
                else
                    useDriverType = 'simba';
                end
            elseif ~isfield(options, 'useDriverType') && ~isfield(options, "jarFilePath")
                % The type is not set and the jar file is not set
                ossJarFilePath = databricks.JDBCConnectionImpl.getDefaultJarFilePath('oss');
                simbaJarFilePath = databricks.JDBCConnectionImpl.getDefaultJarFilePath('simba');
                if javaVersion > 8
                    % If the java version is >8 use OSS if present otherwise Simba
                    if isfile(ossJarFilePath)
                        useDriverType = 'oss';
                        jarFilePath = ossJarFilePath;
                    elseif isfile(simbaJarFilePath)
                        useDriverType = 'simba';
                        jarFilePath = simbaJarFilePath;
                    else
                        error(errBase, "JDBC driver files not found:\n  %s\n  %s", simbaJarFilePath, ossJarFilePath);
                    end
                elseif javaVersion == 8
                    % If the java version is ==8 use Simba if present otherwise OSS
                    if isfile(simbaJarFilePath)
                        useDriverType = 'simba';
                        jarFilePath = simbaJarFilePath;
                    elseif isfile(ossJarFilePath)
                        error(errBase, "Java version: %d, does not support the Databricks OSS JDBC driver, upgrade the JVM used by MATLAB or use the Simba based JDBC driver.", javaVersion);
                    else
                        error(errBase, "JDBC driver files not found:\n  %s\n  %s", simbaJarFilePath, ossJarFilePath);
                    end
                else
                    error(errBase, "Unsupported Java version: %d", javaVersion);
                end
            else
                error(errBase, "Unexpected useDriverType and jarFilePath configuration.");
            end

            if javaVersion <= 8 && strcmp(useDriverType, 'oss')
                error(errBase, "Java version: %d, does not support the Databricks OSS JDBC driver, upgrade the JVM used by MATLAB or use the Simba based JDBC driver.", javaVersion);
            end
            if ~isfile(jarFilePath)
                error(errBase, "JDBC driver file not found: %s", jarFilePath);
            end

            if databricks.JDBCConnectionImpl.numberOfClassPathEntries(jarFilePath=jarFilePath) > 1
                error(errBase, "Expected only a single Databricks JDBC driver on the Java class paths.");
            end

            % Put the requested or "best" driver on the dynamic java class path
            if ~databricks.JDBCConnectionImpl.updateJavaclassPath(options.driverClass, jarFilePath, verbose=options.verbose)
                error(errBase, "Unable to configure the Java class path.");
            else
                obj.JarFilePath = jarFilePath;
            end

            % Check driver and get version
            if strcmp(useDriverType, 'oss')
                if ~databricks.JDBCConnectionImpl.isOSSDriver()
                    error(errBase, "Expected Databricks OSS JDBC driver not found on Java class path.");
                end
            end

            driverVersion = databricks.JDBCConnectionImpl.getDriverVersion(driverClass=options.driverClass);
            obj.DriverClass = options.driverClass;
            if ~databricks.JDBCConnectionImpl.validateDriverVersion(useDriverType, driverVersion, verbose=options.verbose)
                error(errBase, "Driver version validation failed: %s", string(driverVersion));
            end

            %% Auth Source configuration
            username = "";
            password = "";
            if isfield(options, "connectionURL") && strlength(options.connectionURL) > 0
                % Auth is passed completely through connectionURL connection string
                authSrc = "connectionURL";
                if options.verbose
                    fprintf("Authenticating using a provided Connection URL.\n");
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
                    fprintf("Authenticating using the MATLAB Interface for Databricks packages' authentication support.\n");
                end
            elseif options.useDriverAuth == true
                if ~databricks.internal.isOnDatabricksImpl
                    authSrc = "driverAuth"; % Default case
                    if options.verbose
                        fprintf("Authenticating using the Databricks JDBC driver's built-in authentication support.\n");
                    end
                else
                    authObjectArgs = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
                    obj.getAuth("verbose", true, authObjectArgs{:}, "enableAuthenticate", false, "verbose", false);
                    % The driver attempts to open a browser which is not supported
                    if obj.AuthMethod == matlab.internal.databricks.AuthMethod.OauthU2M
                        fprintf("When running on Databricks the Databricks JDBC driver cannot be used with OAuthU2M authentication.\n");
                        fprintf("Using MATLAB Interface for Databricks OAuthU2M flow instead.\n");
                        authSrc = "pkgAuth";
                    else
                        authSrc = "driverAuth"; % Default case
                        if options.verbose
                            fprintf("Authenticating using the Databricks JDBC driver's built-in authentication support.\n");
                        end
                    end
                end
            else
                error(errBase, "Could not determine an authentication flow.\n");
            end

            if strcmp(authSrc, "connectionURL")
                if startsWith(options.connectionURL, "jdbc:databricks://", ignoreCase=true)
                    connectionURL = options.connectionURL;
                    httpPath = extractBetween(lower(connectionURL), "httppath=", ";");
                    f = split(string(httpPath), "/");
                    id = f(end);
                else
                    error(errBase, "Expected connection string to start with: jdbc:databricks://");
                end
            else
                %% get getAuth() details
                authObjectArgs = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
                if strcmp(authSrc, "pkgAuth")
                    % Do full auth, not using the driver to auth
                    obj.getAuth("verbose", true, authObjectArgs{:});
                else
                    % Do auth to figure out actual authMethod for later on obj.AuthMethod
                    obj.getAuth(authObjectArgs{:}, "enableAuthenticate", false, "verbose", false);
                    % If PAT is returned as the authMethod then redo the process but enable
                    % auth in this case so that an obj.Token is configured
                    if obj.AuthMethod == matlab.internal.databricks.AuthMethod.PAT
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
                    error(errBase, "Could not determine a host, either a connection string or host value must be provided.");
                end

                %% Scheme
                if startsWith(host, "http", IgnoreCase=true)
                    hostURI = matlab.net.URI(host);
                    hostEncodedAuthority = string(hostURI.EncodedAuthority);
                else
                    hostEncodedAuthority = host;
                end
                connectionURL = "jdbc:databricks://" + hostEncodedAuthority + ":" + options.port;

                %% Schema (must follow port directly)
                if isfield(options, "schema")
                    if strlength(options.schema) > 0
                        escapedSchema = databricks.JDBCConnectionImpl.escapeUCName(options.schema);
                        connectionURL = connectionURL + "/" + escapedSchema + ";";
                    end
                else
                    % "default" set by default - should not arise
                    error(errBase, "schema not set.");
                end

                %% httpPath
                args = matlab.internal.utils.addArgs(options, ["httpPath", "cluster", "profileName"]);
                [httpPath, clusterId, warehouseId] = databricks.JDBCConnectionImpl.getHttpPath(args{:});
                connectionURL = connectionURL + httpPath;

                %% ssl, default is logical true
                connectionURL = connectionURL + "ssl=" + string(num2str(options.ssl)) + ";";

                %% thriftTransport
                if strcmp(useDriverType, 'simba')
                    if isfield(options, "thriftTransport")
                        connectionURL = connectionURL + "thriftTransport=" + string(options.thriftTransport) + ";";
                    end
                end

                %% transportMode
                if strcmp(useDriverType, 'oss')
                    connectionURL = connectionURL + "transportMode=http" + ";";
                end

                %% defaultStringColumnLength truncation workaround support for a future release
                if isfield(options, "defaultStringColumnLength")
                    connectionURL = connectionURL + "DefaultStringColumnLength=" + string(options.defaultStringColumnLength) + ";";
                end

                %% catalog
                if isfield(options, "catalog")
                    escapedCatalog = databricks.JDBCConnectionImpl.escapeUCName(options.catalog);
                    connectionURL = connectionURL + "Catalog=" + escapedCatalog + ";";
                end

                %% Proxy
                connectionURL = connectionURL + databricks.JDBCConnectionImpl.getHTTPProxy();

                %% useNativeQuery
                if strcmp(useDriverType, 'simba')
                    if isfield(options, "useNativeQuery")
                        connectionURL = connectionURL + "UseNativeQuery=" + string(int32(options.useNativeQuery)) + ";";
                    else
                        connectionURL = connectionURL + "UseNativeQuery=" + string(int32(true)) + ";";
                    end
                else
                    if isfield(options, "useNativeQuery") && options.verbose
                        fprintf(2, "The UseNativeQuery parameter is supported only by version 2.x of the JDBC driver.\n");
                    end
                end

                %% enableNativeParameterizedQuery
                if strcmp(useDriverType, 'simba')
                    if isfield(options, "enableNativeParameterizedQuery")
                        connectionURL = connectionURL + "EnableNativeParameterizedQuery=" + string(int32(options.enableNativeParameterizedQuery)) + ";";
                    else
                        connectionURL = connectionURL + "EnableNativeParameterizedQuery=" + string(int32(false)) + ";";
                    end
                else
                    if isfield(options, "enableNativeParameterizedQuery") && options.verbose
                        fprintf(2, "The EnableNativeParameterizedQuery parameter is supported only by version 2.x of the JDBC driver.\n");
                    end
                end

                %% Add authentication details
                args = matlab.internal.utils.addArgs(options, ["passthroughAccessToken", "passthroughRefreshToken",...
                    "cacheFilePath", "scope", "OauthService", "oauth2ClientId"...
                    "TokenCachePassPhrase", "authMethod", "profileName"]);
                [authStr, username, password] = obj.getAuthArgs(authSrc, host, driverVersion, useDriverType, args{:});
                connectionURL = connectionURL + authStr;

                %% UserAgentEntry
                connectionURL = connectionURL + "UserAgentEntry=" + obj.UserAgent + ";";

                %% LogLevel
                connectionURL = connectionURL + "LogLevel=" + options.logLevel + ";";

                %% connectionURLAppend
                if isfield(options, "connectionURLAppend")
                    connectionURL = connectionURL + options.connectionURLAppend;
                end
            end
            obj.ConnectionURL = connectionURL;
            obj.DriverClass = options.driverClass;
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
                obj.Connection = database(options.schema, username, password, options.driverClass, obj.ConnectionURL);
                if ~isempty(obj.Connection.Message)
                    fprintf(2, "Error JDBC connection not open, Message:\n%s\n\n", obj.Connection.Message);
                end
                if ~options.disableSourceCreation
                    try
                        args = matlab.internal.utils.addArgs(options, "dataSourceName");
                        obj.Opts = createSourceOpts(obj, args{:});
                    catch MEInner
                        fprintf(2, "Error creating data source, Message:\n%s\n\n", MEInner.message);
                    end
                end
            catch ME
                fprintf(2, "Error creating JDBC connection, Message:\n%s\n\n", ME.message);
            end
        end


        function delete(obj) %#ok<INUSD>
        end


        function close(obj)
            if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.jdbc.connection')
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
                fprintf(2, "If using the Databricks JDBC driver's OathU2M/M2M flow the token is not available.\n")
                fprintf(2, "Use: databricks.JDBCConnectionImpl(useDriverAuth=false)\n")
                tf = false;
            end
        end


        function [tf, message] = testConnection(obj)
            % TESTCONNECTION Tests the JDBC connection
            arguments
                obj (1,1) databricks.JDBCConnectionImpl
            end

            if isempty(obj.Opts)
                message = "Source options were not created when the connection was created, set disableSourceCreation to false.";
                fprintf(2, "%s\n", message);
                tf = false;
                return;
            end

            [tf, message] = testConnection(obj.Opts, obj.ConnUsername, obj.ConnPassword);
            if ~tf
                fprintf(2, "%s\n", message);
            end
            message = string(message);
        end


        function dataSourceName = saveSource(obj, options)
            % SAVESOURCE Saves the data source the Data Explorer app UI
            arguments
                obj (1,1) databricks.JDBCConnectionImpl
                options.overwrite (1,1) logical = false
            end

            if isempty(obj.Opts)
                fprintf(2, "Source options were not created when the connection was created, set disableSourceCreation to false.\n");
                dataSourceName = string.empty;
                return;
            end

            if ~options.overwrite
                datasources = listDataSources;
                namesCell = cellstr(datasources.Name');
                if ~isempty(namesCell)
                    if any(contains(namesCell, obj.Opts.DataSourceName))
                        fprintf(2, "A data source exists named: %s, provide an alternative name when creating the connection or set named overwrite argument to true.\n", obj.Opts.DataSourceName);
                        dataSourceName = string.empty;
                        return;
                    end
                end
            end
            dataSourceName = obj.Opts.DataSourceName;
            saveAsDataSource(obj.Opts);
        end


        function opts = createSourceOpts(obj, options)
            % CREATESOURCEOPTS Creates data source options for the JDBC connection
            arguments
                obj (1,1) databricks.JDBCConnectionImpl
                options.dataSourceName {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isfield(options, "dataSourceName")
                dataSourceName = options.dataSourceName;
            else
                if contains(lower(obj.ConnectionURL), "/warehouses/")
                    id = extractBetween(lower(obj.ConnectionURL), "/warehouses/", ";");
                else
                    id = extractBetween(lower(obj.ConnectionURL), "sql/protocolv1/o/"+digitsPattern+"/", ";");
                end
                if isempty(id) || strlength(id) == 0
                    dataSourceName = "Databricks-UnspecifiedId";
                else
                    dataSourceName = "Databricks-" + id;
                end
            end
            if isfile(dataSourceName) && ~options.overwrite
                fprintf(2, "File already exists: %s, Remove or use optional overwrite argument.\n", dataSourceName);
                return;
            end

            opts = databaseConnectionOptions("jdbc", "Other");
            opts = setoptions(opts, ...
                'DataSourceName', dataSourceName, ...
                'JDBCDriverLocation', obj.JarFilePath, ...
                'Driver', obj.DriverClass,...
                'URL', obj.ConnectionURL);
        end
    end %methods


    methods(Hidden)
        function [authStr, username, password] = getAuthArgs(obj, authSrc, host, driverVersion, useDriverType, options)
            arguments
                obj (1,1) databricks.JDBCConnectionImpl
                authSrc string {mustBeTextScalar, mustBeNonzeroLengthText}
                host string {mustBeTextScalar, mustBeNonzeroLengthText}
                driverVersion (1,1) matlab.internal.utils.SemVer
                useDriverType char {mustBeMember(useDriverType,{'simba','oss'})}

                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar}

                options.OauthService matlab.internal.databricks.OauthService
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.TokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.enableTokenCache (1,1) logical

                options.authMethod (1,1) matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical
            end

            errBase = "DATABRICKS:JDBCConnection";

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

            elseif strcmp(authSrc, "pkgAuth")
                % The JDBCConnection class should be authenticated already
                % and so the Token should be configured and ready to passthrough
                switch obj.AuthMethod
                    case matlab.internal.databricks.AuthMethod.PAT
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Personal Access Token is not configured.\n");
                        end
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + obj.Token + ";";
                        username = "token";
                        password = obj.Token;
                        if databricks.internal.isOnDatabricksImpl
                            if strcmp(obj.Token, char(matlab.net.base64decode(getenv('MW_API_TOKEN_B64'))))
                                fprintf("The PAT has the same as the MW_API_TOKEN_B64 environment variable value.\n");
                                fprintf("If this value was derived from the user's context is will not support a JDBC connection.\n");
                                fprintf("An alternative PAT must be provided and typically updated in the .databrickscfg configuration file.\n");
                            end
                        end

                    case {matlab.internal.databricks.AuthMethod.OauthM2M, matlab.internal.databricks.AuthMethod.OauthU2M}
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Access token is not configured.\n");
                        end
                        authStr = "AuthMech=11;Auth_Flow=0;Auth_AccessToken=" + obj.Token + ";";
                        % Add refresh token if present
                        if isempty(obj.AuthMethod)
                            error(errBase, "Authentication method is not configured.\n");
                        end
                        if isfield(options, "cacheFilePath")
                            cacheFilePath = options.cacheFilePath;
                        else
                            cacheFilePath = databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath(obj.AuthMethod);
                        end
                        refreshToken = databricks.internal.unifiedauthentication.OauthImpl.getCachedValue(obj.AuthMethod, "refresh_token", host, cacheFilePath=cacheFilePath);
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
                    case matlab.internal.databricks.AuthMethod.PAT
                        if isempty(obj.Token) || strlength(obj.Token) == 0
                            error(errBase, "Personal Access Token is not configured.\n");
                        end
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + obj.Token + ";";
                        username = "token";
                        password = obj.Token;

                    case matlab.internal.databricks.AuthMethod.OauthM2M
                        authStr = "AuthMech=11" + ";Auth_Flow=1" + ";OAuth2ClientId=" + string(obj.ClientId) + ";OAuth2Secret=" + string(obj.ClientSecret) + ";";

                    case matlab.internal.databricks.AuthMethod.OauthU2M
                        authStr = "AuthMech=11" + ";Auth_Flow=2" + ";";
                        enableTokenCacheArgs = matlab.internal.utils.addArgs(options, "enableTokenCache");
                        enableTokenCache = databricks.JDBCConnectionImpl.getEnableTokenCache(driverVersion, useDriverType, obj.JarFilePath, enableTokenCacheArgs{:});
                        authStr = authStr + "EnableTokenCache=" + string(num2str(enableTokenCache)) + ";";
                        if isfield(options, "TokenCachePassPhrase")
                            authStr = authStr + "TokenCachePassPhrase=" + options.TokenCachePassPhrase + ";";
                        end

                    otherwise
                        error(errBase, "Unexpected authentication method.");
                end
            else
                error(errBase, "Unexpected authentication flow.");
            end

            if obj.AuthMethod == matlab.internal.databricks.AuthMethod.OauthM2M || obj.AuthMethod == matlab.internal.databricks.AuthMethod.OauthU2M
                scopeArgs = matlab.internal.utils.addArgs(options, ["scope", "OauthService", "oauth2ClientId"]);
                scopeStr = databricks.JDBCConnectionImpl.getScope(obj.AuthMethod, scopeArgs{:});
                authStr = authStr + scopeStr;
            end
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

        function numEntries = numberOfClassPathEntries(options)
            % NUMBEROFCLASSPATHENTRIES Returns number of matching JDBC drivers on the Java class paths
            % Both the static and dynamic paths are checked.
            % An optional jarFilePath can be specified if the driver .jar naming does not
            % match the expected conventions.
            % The check looks for both the OSS and Simba drivers.

            arguments
                options.jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            dynamicP = javaclasspath('-dynamic');
            staticP = javaclasspath('-static');

            simbaNativePattern = "databricks-jdbc-" + digitsPattern(1,10) + "." + digitsPattern(1,10) + "." + digitsPattern(1,10);
            simbaNativePatternCount = sum(contains(dynamicP, simbaNativePattern)) + sum(contains(staticP, simbaNativePattern));
            oosNativePattern = simbaNativePattern + "-oss";
            oosNativePatternCount = sum(contains(dynamicP, oosNativePattern)) + sum(contains(staticP, oosNativePattern));

            if isfield(options, "jarFilePath")
                jarFilePathCount = sum(contains(dynamicP, options.jarFilePath)) + sum(contains(staticP, options.jarFilePath));
            else
                jarFilePathCount = 0;
            end

            jarDir = dir(matlab.internal.databricksRoot("lib", "jar") + filesep + "*Driver*.jar");
            jarDirCount = 0;
            for n = 1:numel(jarDir)
                jName = fullfile(jarDir(n).name, jarDir(n).folder);
                jarDirCount = jarDirCount + sum(contains(dynamicP, jName)) + + sum(contains(staticP, jName));
            end

            numEntries = simbaNativePatternCount + oosNativePatternCount + jarFilePathCount + jarDirCount;
        end


        function tf = isOSSDriver()
            % ISOSSDRIVER Returns true if the OSS JDBC driver is on the Java class path

            try
                u = com.databricks.jdbc.common.util.DriverUtil();
                if strcmp(string(u.getDriverName), "oss-jdbc")
                    tf = true;
                else
                    tf = false;
                end
            catch
                tf = false;
            end
        end


        function tf = updateJavaclassPath(driverClass, jarFilePath, options)
            % UPDATEJAVACLASSPATH Adds the specified jar file to the Java class path
            arguments
                driverClass string {mustBeTextScalar, mustBeNonzeroLengthText}
                jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            if exist(driverClass, "class") == 8
                tf = true;
                return;
            end

            if isfile(jarFilePath)
                if options.verbose
                    fprintf("Adding: %s to the Java class path.\n", jarFilePath);
                end
                javaaddpath(jarFilePath)
                if exist(driverClass, "class") == 8
                    tf = true;
                else
                    fprintf(2, "Driver added but not found on Java class path.\n");
                    tf = false;
                end
            else
                fprintf(2, "JDBC driver file not found: %s\n", jarFilePath);
                tf = false;
            end
        end


        function checkDataSources(schema)
            % CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
            arguments
                schema string {mustBeTextScalar, mustBeNonzeroLengthText} = "default"
            end

            datasources = listDataSources;
            namesCell = cellstr(datasources.Name');
            if ~isempty(namesCell)
                if any(contains(namesCell, schema))
                    error('DATABRICKS:JDBCConnection', 'An ODBC/JDBC datasource exists with the same name as the database: %s\nAmend the datasource name.', schema);
                end
            end
        end


        function jarFilePath = getDefaultJarFilePath(driverType)
            % GETDEFAULTJARFILEPATH Returns the default jar file path for the driver
            arguments
                driverType char {mustBeMember(driverType,{'simba','oss'})}
            end

            if strcmp(driverType, 'simba')
                pomVersion = matlab.internal.utils.Maven.getPomProjectVersion(matlab.internal.databricksRoot("lib", "jar", "pom.xml"));
                if isempty(pomVersion) || strlength(pomVersion) == 0
                    error("Unable to determine JDBC Simba driver pom file version.");
                else
                    jarFilePath = matlab.internal.databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-" + pomVersion + ".jar");
                end
            elseif strcmp(driverType, 'oss')
                pomVersion = matlab.internal.utils.Maven.getPomProjectVersion(matlab.internal.databricksRoot("lib", "jar", "pomOSS.xml"));
                if isempty(pomVersion) || strlength(pomVersion) == 0
                    error("Unable to determine JDBC OSS driver pom file version.");
                else
                    jarFilePath = matlab.internal.databricksRoot("lib", "jar", "Databricks-JDBC-OSS-Driver-" + pomVersion + ".jar");
                end
            else
                error('DATABRICKS:JDBCConnection', "Unexpected driverType: %s", driverType);
            end
        end


        function version = getDriverVersion(options)
            % GETDRIVERVERSION Returns the driver version as a matlab.internal.utils.SemVer
            % Works with both the Simba and OSS driver.
            % Does not return the patch version, it will always be 0.
            % If the driver is not found on the class path then 0.0.0 is returned.
            % An optional driverClass may be provided.

            arguments
                options.driverClass string {mustBeTextScalar, mustBeNonzeroLengthText} = "com.databricks.client.jdbc.Driver"
            end

            version = matlab.internal.utils.SemVer();
            version.major = 0;
            version.minor = 0;
            version.patch = 0;

            if isfield(options, "driverClass") && ~isempty(options.driverClass) && strlength(options.driverClass) > 0
                if exist(options.driverClass, 'class') ~= 8
                    fprintf(2,'Driver class: %s, not found on the Java classpath.\n', options.driverClass);
                    return;
                else
                    drv = javaObject(options.driverClass);
                    version.major = drv.getMajorVersion();
                    version.minor = drv.getMinorVersion();
                end
            else
                error('DATABRICKS:JDBCConnection','Required driverClass value is not defined.');
            end
        end


        function tf = validateDriverVersion(driverType, version, options)
            % VALIDATEDRIVERVERSION Validates that the driver version meets minimum requirements
            arguments
                driverType string {mustBeMember(driverType,{'simba','oss'})}
                version (1,1) matlab.internal.utils.SemVer
                options.verbose (1,1) logical = true
            end

            if strcmp(driverType, 'simba')
                if version.lt("2.7") % driver does not return the patch version
                    if options.verbose
                        fprintf(2, "Databricks JDBC Simba driver version 2.7 and less than 3.0 is required.\n");
                    end
                    tf = false;
                else
                    tf = true;
                end
            elseif strcmp(driverType, 'oss')
                if version.lt("3.0") % driver does not return the patch version
                    if options.verbose
                        fprintf(2, "Databricks JDBC OSS driver version 3.0 or greater is required.\n");
                    end
                    tf = false;
                else
                    tf = true;
                end
            else
                error('DATABRICKS:JDBCConnection','Unexpected driverType: %s', driverType);
            end
        end


        function enableTokenCache = getEnableTokenCache(driverVersion, driverType, jarFilePath, options)
            % GETENABLETOKENCACHE Determines if token caching should be enabled based on driver type and version
            arguments
                driverVersion (1,1) matlab.internal.utils.SemVer
                driverType string {mustBeMember(driverType,{'simba','oss'})}
                jarFilePath string
                options.enableTokenCachePreference (1,1) logical = true
            end

            if strcmp(driverType, 'oss')
                enableTokenCache = options.enableTokenCachePreference;
            elseif strcmp(driverType, 'simba')
                if ~options.enableTokenCachePreference
                    enableTokenCache = false;
                else
                    % A proper semantic version comparison cannot be done because the driver
                    % does not return the patch (3rd) version number.
                    if driverVersion.ge("2.7")
                        if ispc
                            enableTokenCache = true;
                        else
                            if matlab.internal.utils.SemVer(matlab.internal.databricks.databricksPackageVersion).ge("5.3.9") && ...
                                ~isempty(jarFilePath) && strlength(jarFilePath) > 0 && ...
                                isfile(jarFilePath) && ...
                                strcmp(jarFilePath, matlab.internal.databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar'))
                                enableTokenCache = true;
                            else
                                fprintf(2, "Disabling token caching on Linux & macOS for JDBC Simba driver versions >= 2.7 and < 2.7.3, as a driver bug workaround.\n");
                                enableTokenCache = false;
                            end
                        end
                    else
                        fprintf(2, "Disabling token caching for JDBC Simba driver versions < 2.7.\n");
                        enableTokenCache = false;
                    end
                end
            else
                error('DATABRICKS:JDBCConnection','Unexpected driverType: %s', driverType);
            end
        end


        function [httpPath, clusterId, warehouseId] = getHttpPath(options)
            % GETHTTPPATH Determines the HTTP path for Databricks connection string
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
            errBase = "DATABRICKS:JDBCConnection:getHttpPath";

            envHTTPPath = getenv("DATABRICKS_HTTP_PATH");
            if ~isempty(envHTTPPath)
                f = split(string(envHTTPPath), "/");
                httpPath = "httpPath=" + string(envHTTPPath) + ";";
                if contains(envHTTPPath, "/warehouses/")
                    warehouseId = f(end);
                else
                    clusterId = f(end);
                end
            elseif isfield(options, 'httpPath')
                f = split(string(options.httpPath), "/");
                if contains(options.httpPath, "/warehouses/")
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
                    error(errBase+":CLUSTERID", "cluster_id not set in profile: %s, use: updateClusterId('cluster-id-value')", options.profileName);
                end
                httpPath = "httpPath=" + "sql/protocolv1/o/" + org_id + "/" + clusterId + ";";
            end

            if isempty(warehouseId) && isempty(clusterId)
                error(errBase+":NOID", "Expected either a clusterId or warehouseId.");
            end
        end


        function scope = getScope(authMethod, options)
            % GETSCOPE Returns a scope field as a string
            arguments
                authMethod (1,1) matlab.internal.databricks.AuthMethod
                options.scope string {mustBeTextScalar}
                options.OauthService matlab.internal.databricks.OauthService = matlab.internal.databricks.OauthService.Databricks
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if ~(authMethod == matlab.internal.databricks.AuthMethod.OauthU2M || authMethod == matlab.internal.databricks.AuthMethod.OauthM2M)
                warning("DATABRICKS:JDBCCONNECTION:GETSCOPE", "Scope value should only be set when using OauthU2M or OauthM2M.");
                scope = "";
                return;
            end

            if isfield(options, "scope")
                scope = "OAuth2ConnAuthAuthscopeKey=" + options.scope + ";";
            else
                switch options.OauthService
                    case matlab.internal.databricks.OauthService.Databricks
                        if authMethod == matlab.internal.databricks.AuthMethod.OauthU2M
                            if strcmp(options.oauth2ClientId, "databricks-sql-jdbc")
                                scope = "OAuth2ConnAuthAuthscopeKey=sql, offline_access;";
                            else
                                if strcmpi(databricks.internal.settings.Settings.getSettingsField("vendor"), "azure")
                                    scope = "OAuth2ConnAuthAuthscopeKey=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/user_impersonation, offline_access;";
                                else
                                    scope = "OAuth2ConnAuthAuthscopeKey=sql, offline_access;";
                                end
                            end
                        elseif authMethod == matlab.internal.databricks.AuthMethod.OauthM2M
                            if strcmp(options.oauth2ClientId, "databricks-sql-jdbc") % Updated for driver version 2.8.2
                                scope = "OAuth2ConnAuthAuthscopeKey=sql;";
                            else
                                if strcmpi(databricks.internal.settings.Settings.getSettingsField("vendor"), "azure")
                                    scope = "OAuth2ConnAuthAuthscopeKey=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default;";
                                else
                                    scope = "OAuth2ConnAuthAuthscopeKey=sql, offline_access;";
                                end
                            end
                        else
                            scope = "";
                        end

                    case matlab.internal.databricks.OauthService.EntraID
                        scope = "";

                    case matlab.internal.databricks.OauthService.Unspecified
                        scope = "";

                    otherwise
                        error("DATABRICKS:JDBCCONNECTION", "Unexpected OauthService value: %s", options.OauthService);
                end
            end
        end


        function tf = validateCluster(clusterId, options)
            % VALIDATECLUSTER Check the clusters state and Spark version
            arguments
                clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
                options.authMethod (1,1) matlab.internal.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            tf = false; %#ok<NASGU>

            if strlength(clusterId) > 0
                args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
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


        function proxyStr = getHTTPProxy()
            % SETHTTPPROXY Sets HTTP proxy environment variables for Python

            % Check if a MATLAB preference is set
            [tf, proxyURI] = matlab.internal.databricks.detectProxy();

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


        function [numericVersion, fullVersion] = getJavaVersion()
            % GETJAVAVERSION Get java version in numeric form and string form
            %
            % Uses the result of the java.lang.System.getProperty("java.version") command.
            %
            % For MATLAB's included Java the full version value is: "1.8.0_202"
            %
            % numericVersion is the single digit Java version returned as a double.
            % For Java 1.8 8 is returned otherwise the number preceding the . returned e.g. 17
            %
            % The fullVersion is the output of java.lang.System.getProperty("java.version").
            %
            % If a Java environment is not enabled an error is thrown.
            %
            % Example:
            %   [numericVersion, fullVersion] = databricks.JDBCConnectionImpl.getJavaVersion()
            %
            % See also: jenv and matlab_jenv

            if ~usejava('jvm')
                error('DATABRICKS:JDBCConnection:getJavaVersion', "Java is not enabled in MATLAB.")
            end

            try
                fullVersion = string(java.lang.System.getProperty("java.version"));
            catch ME
                error('DATABRICKS:JDBCConnection:getJavaVersion', "Unable to get Java version");
            end

            if startsWith(fullVersion, "1.8.")
                numericVersion = 8;
            else
                numStr = extractBefore(fullVersion, ".");
                if isempty(numStr) || strlength(numStr) == 0
                    error('DATABRICKS:JDBCConnection:getJavaVersion', "Expected version value to start with a number, found: %s", fullVersion);
                end
                numericVersion = double(string(numStr));
            end
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            % GETPROPERTYGROUPS Customize the display of JDBCConnection objects
            % Redacts sensitive information from the connection URL.
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
