classdef JDBCConnection < handle
    % JDBCConnection Creates a Database Toolbox connection object
    %
    % The primary role of this class is to construct the connection URL used
    % by the Databricks JDBC driver. Essentially this URL combines a large number
    % of configuration values. This is error prone to construct by hand.
    %
    % The Connection object is stored in the JDBCConnection's Connection property.
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
    %    jarFilePath                string    databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
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
    %    % authMethod a matlab.databricks.AuthMethod
    %    % to force a given authentication method default preferred method
    %    % is not used. See: Documentation/Authentication.md
    %    authMethod                 matlab.databricks.AuthMethod    Settings file authMethod value
    %    %  profileName a scalar text name for a profile to be sourced
    %    % from a .databrickscfg file. See: Documentation/Authentication.md
    %    profileName                string    Settings file profileName value
    %
    %    % Oauth2
    %    % Specify an OAuth service provider
    %    OauthService               matlab.databricks.OauthService    matlab.databricks.OauthService.Databricks
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
    %    j = databricks.JDBCConnection(schema='myDatabaseName');
    %    conn = j.Connection;
    %
    %    j = databricks.JDBCConnection; % Use default schema/database name: "default"
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


    properties(SetAccess = private, Hidden)
        connectionImpl databricks.JDBCConnectionImpl;
    end

    properties (Dependent)
        Connection database.jdbc.connection
    end

    properties (Dependent,Hidden)
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
        function val = get.Connection(obj)
            val = obj.connectionImpl.Connection;
        end

        function val = get.ConnectionURL(obj)
            val = obj.connectionImpl.ConnectionURL;
        end

        function set.ConnectionURL(obj, val)
            obj.connectionImpl.ConnectionURL = val;
        end

        function val = get.Opts(obj)
            val = obj.connectionImpl.Opts;
        end

        function set.Opts(obj, val)
            obj.connectionImpl.Opts = val;
        end
        function val = get.JarFilePath(obj)
            val = obj.connectionImpl.JarFilePath;
        end

        function set.JarFilePath(obj, val)
            obj.connectionImpl.JarFilePath = val;
        end

        function val = get.DriverClass(obj)
            val = obj.connectionImpl.DriverClass;
        end

        function set.DriverClass(obj, val)
            obj.connectionImpl.DriverClass = val;
        end

        function val = get.ConnUsername(obj)
            val = obj.connectionImpl.ConnUsername;
        end

        function set.ConnUsername(obj, val)
            obj.connectionImpl.ConnUsername = val;
        end

        function val = get.ConnPassword(obj)
            val = obj.connectionImpl.ConnPassword;
        end

        function set.ConnPassword(obj, val)
            obj.connectionImpl.ConnPassword = val;
        end

        function val = get.Id(obj)
            val = obj.connectionImpl.Id;
        end

        function set.Id(obj, val)
            obj.connectionImpl.Id = val;
        end


        function val = get.ErrBase(obj)
            val = obj.connectionImpl.Id;
        end

        function set.ErrBase(obj, val)
            obj.connectionImpl.ErrBase = val;
        end

        function obj = JDBCConnection(varargin)
            args = varargin;
            if ~any(strcmpi(args(1:2:end), 'jarFilePath'))
                driverType = databricks.JDBCConnection.resolveDriverType(args{:});
                jarFilePath = databricks.JDBCConnection.getDefaultJarFilePath(driverType);
                if isfile(jarFilePath)
                    args = [args, {'jarFilePath', jarFilePath}];
                end
            end
            for i = 1:numel(args)
                if isa(args{i}, 'matlab.databricks.AuthMethod')
                    args{i} = args{i}.authMethodImpl;
                elseif isa(args{i}, 'matlab.databricks.OauthService')
                    args{i} = args{i}.OauthServiceImpl;
                end
            end
            obj.connectionImpl = databricks.JDBCConnectionImpl(args{:});
        end


        function close(obj)
            obj.connectionImpl.close();
        end


        function tf = copyToken(obj)
            % COPYTOKEN Copies the connection password/token to the system clipboard
            % Returns true if a value is copied, otherwise false.
            tf = obj.connectionImpl.copyToken();
        end


        function [tf, message] = testConnection(obj)
           [tf,message] = obj.connectionImpl.testConnection();
        end


        function dataSourceName = saveSource(obj, varargin)
            dataSourceName = obj.connectionImpl.saveSource(varargin{:});
        end


        function opts = createSourceOpts(obj, varargin)            
            % CREATESOURCEOPTS Creates data source options for the JDBC connection
            opts = obj.connectionImpl.createSourceOpts(obj,varargin{:});
        end
           
    end %methods


    methods(Hidden)
        function [authStr, username, password] = getAuthArgs(obj, varargin)
            [authStr, username, password] = obj.connectionImpl.getAuthArgs(varargin{:});
        end
    end


    methods(Static, Hidden)
        function driverType = resolveDriverType(varargin)
            args = varargin;
            idx = find(strcmpi(args(1:2:end), 'useDriverType'));
            if ~isempty(idx)
                driverType = args{idx*2};
            else
                [javaVersion, ~] = databricks.JDBCConnectionImpl.getJavaVersion();
                if javaVersion > 8
                    driverType = 'oss';
                else
                    driverType = 'simba';
                end
            end
        end


        function out = escapeUCName(in)
          out = databricks.JDBCConnectionImpl.escapeUCName(in);
        end

        function numEntries = numberOfClassPathEntries(varargin)
            % NUMBEROFCLASSPATHENTRIES Returns number of matching JDBC drivers on the Java class paths
            % Both the static and dynamic paths are checked.
            % An optional jarFilePath can be specified if the driver .jar naming does not
            % match the expected conventions.
            % The check looks for both the OSS and Simba drivers.
           numEntries = databricks.JDBCConnectionImpl.numberOfClassPathEntries(varargin{:});
        end


        function tf = isOSSDriver()
            % ISOSSDRIVER Returns true if the OSS JDBC driver is on the Java class path
            tf = databricks.JDBCConnectionImpl.isOSSDriver();
        end


        function tf = updateJavaclassPath(varargin)
            % UPDATEJAVACLASSPATH Adds the specified jar file to the Java class path
            tf = databricks.JDBCConnectionImpl.updateJavaclassPath(varargin{:});
        end


        function checkDataSources(varargin)
            % CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
              databricks.JDBCConnectionImpl.checkDataSources(varargin{:});
        end


        function jarFilePath = getDefaultJarFilePath(driverType)
            % GETDEFAULTJARFILEPATH Returns the default jar file path for the driver
            arguments
                driverType char {mustBeMember(driverType,{'simba','oss'})}
            end

            jarFilePath = databricks.JDBCConnectionImpl.getDefaultJarFilePath(driverType);
            if ~isfile(jarFilePath)
                if strcmp(driverType, 'simba')
                    pomVersion = matlab.internal.utils.Maven.getPomProjectVersion(matlab.internal.databricksRoot("lib", "jar", "pom.xml"));
                    jarFilePath = matlab.internal.databricksRoot(-1, "lib", "jar", "Shaded-Databricks-JDBC-Driver-" + pomVersion + ".jar");
                else
                    pomVersion = matlab.internal.utils.Maven.getPomProjectVersion(matlab.internal.databricksRoot("lib", "jar", "pomOSS.xml"));
                    jarFilePath = matlab.internal.databricksRoot(-1, "lib", "jar", "Databricks-JDBC-OSS-Driver-" + pomVersion + ".jar");
                end
            end
        end


        function version = getDriverVersion(varargin)
            % GETDRIVERVERSION Returns the driver version as a matlab.utils.SemVer
            % Works with both the Simba and OSS driver.
            % Does not return the patch version, it will always be 0.
            % If the driver is not found on the class path then 0.0.0 is returned.
            % An optional driverClass may be provided.
            internalVer = databricks.JDBCConnectionImpl.getDriverVersion(varargin{:});
            version = matlab.utils.SemVer(internalVer);
        end


        function tf = validateDriverVersion(driverType, version, varargin)
            % VALIDATEDRIVERVERSION Validates that the driver version meets minimum requirements
            if isa(version, 'matlab.utils.SemVer')
                version = matlab.internal.utils.SemVer(string(version));
            end
            tf = databricks.JDBCConnectionImpl.validateDriverVersion(driverType, version, varargin{:});
        end


        function enableTokenCache = getEnableTokenCache(driverVersion, driverType, jarFilePath, options)
            % GETENABLETOKENCACHE Determines if token caching should be
            % enabled based on driver type and version
            arguments
                driverVersion (1,1) matlab.utils.SemVer
                driverType string {mustBeMember(driverType,{'simba','oss'})}
                jarFilePath string
                options.enableTokenCachePreference (1,1) logical = true
            end

            if isa(driverVersion, 'matlab.utils.SemVer')
                driverVersion = matlab.internal.utils.SemVer(string(driverVersion));
            end
            % Keeping the logic of getting token cache preference for simba
            % driver in the PSP because of dependencies with the
            % availability of Java. Otherwise use the internal
            % implementation
            if strcmp(driverType, 'simba')
                % A proper semantic version comparison cannot be done because the driver
                % does not return the patch (3rd) version number.
                if driverVersion.ge("2.7") && ~ispc
                    if matlab.internal.utils.SemVer(matlab.internal.databricks.databricksPackageVersion).ge("5.3.9") && ...
                            ~isempty(jarFilePath) && strlength(jarFilePath) > 0 && ...
                            isfile(jarFilePath) && ...
                            strcmp(jarFilePath, matlab.internal.databricksRoot(-1,'lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar'))
                        enableTokenCache = true;
                        return;
                    end
                end
            end
            enableTokenCache = databricks.JDBCConnectionImpl.getEnableTokenCache(driverVersion, driverType, jarFilePath);
        end


        function [httpPath, clusterId, warehouseId] = getHttpPath(varargin)
            % GETHTTPPATH Determines the HTTP path for Databricks connection string
            [httpPath, clusterId, warehouseId] = databricks.JDBCConnectionImpl.getHttpPath(varargin{:});
        end


        function scope = getScope(varargin)
            % GETSCOPE Returns a scope field as a string
            scope = databricks.JDBCConnectionImpl.getScope(varargin{:});      
        end


        function tf = validateCluster(varargin)
            % VALIDATECLUSTER Check the clusters state and Spark version
            tf = databricks.JDBCConnectionImpl.validateCluster(varargin{:});
        end


        function proxyStr = getHTTPProxy()
            % SETHTTPPROXY Sets HTTP proxy environment variables for Python

            % Check if a MATLAB preference is set
            proxyStr = databricks.JDBCConnectionImpl.getHTTPProxy();           
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
            %   [numericVersion, fullVersion] = databricks.JDBCConnection.getJavaVersion()
            %
            % See also: jenv and matlab_jenv
            [numericVersion, fullVersion] = databricks.JDBCConnectionImpl.getJavaVersion();
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            % GETPROPERTYGROUPS Customize the display of JDBCConnection objects
            % Redacts sensitive information from the connection URL.
            groups = obj.connectionImpl.getPropertyGroups();
        end %function
    end %methods
end