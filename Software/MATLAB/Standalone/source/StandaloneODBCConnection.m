classdef StandaloneODBCConnection < matlab.mixin.CustomDisplay
    % STANDALONEODBCCONNECTION Creates an ODBC based Database Toolbox connection
    %
    % This class is designed to provide a standalone functionality which can be
    % used independently of the wider MATLAB Interface for Databricks package.
    % This class has no external dependencies to the the Databricks, making this
    % class simpler to integrate in certain scenarios where a Database Toolbox based
    % interface only is required, i.e. other interfaces such as the REST API or
    % Databricks Connect are not required. A JSON configuration file is also
    % required. A template can be found in: /Software/MATLAB/config/databricks_standalone_odbc_settings.json
    % This file sets certain required default values.
    %
    % The expectation is that this file will be copied outside the context
    % of the Databricks package and so the MATLAB path is searched for the
    % location of the databricks_standalone_odbc_settings.json file.
    %
    % If using the wider package then the databricks.ODBCConnection class provides
    % similar functionality with deeper integration and so is then recommended.
    %
    % The primary role of this class is to construct the connection URL used
    % by the Databricks ODBC driver. Essentially this URL combines a large number
    % of configuration values. This is error prone to construct by hand.
    %
    % The Connection object is stored in the Connection property.
    %
    % MATLAB R2022b or later and Database Toolbox are required.
    %
    % The following optional named arguments can be used to override the values
    % obtained from the JSON file. All optional arguments are of type string as
    % the package's dedicated classes and enumerations are assumed not to be
    % available.
    %
    % The primary role of this class is to construct the connection string used
    % by the Databricks ODBC driver. Essentially this string combines a large number
    % of configuration values. This is error prone to construct by hand.
    %
    % The Connection object is stored in the Connection property.
    %
    % The following optional named arguments can be used to override the values
    % obtained from the JSON file. All optional arguments are of type string as
    % the package's dedicated classes and enumerations are assumed not to be
    % available.
    %
    % | Name                      | Required |  JSON file default | Description                       |
    % | ------------------------- | -------- | ------------------ | --------------------------------- |
    % | settingsFile              |          | databricks_standalone_odbc_settings.json | Function argument only |
    % |                           |          |                    | |
    % | host                      |   Yes    |                    | Workspace URL e.g. "https://adb-1234567890123456.1.azuredatabricks.net" |
    % | port                      |   Yes    | 443                | Port used by the driver, specified as a string |
    % | orgId                     |   Yes    |                    | Workspace org_id e.g. "1234567890123456" |
    % | clusterId                 |   Yes    |                    | Id of cluster or SQL Warehouse e.g. "0912-173539-zf4ob0md" |
    % | schema                    |   Yes    |                    | Name of the database/schema to use |
    % | catalog                   |   Yes    |                    | Name of the Unity Catalog catalog |
    % |                           |          |                    | |
    % | authMethod                |   Yes    | OauthU2M           | Authentication method, one of PAT, OauthU2M, OauthM2M |
    % | token                     |          |                    | Token if using authMethod PAT |
    % | clientId                  |          |                    | Client Id if using OauthM2M |
    % | clientSecret              |          |                    | Client secret if using OauthM2M |
    % | passthroughAccessToken    |          |                    | Value for a token that is passed opaquely N1 |
    % | tokenCachePassPhrase      |          |                    | Optional pass phrase to protect cached tokens |
    % |                           |          |                    | |
    % | scope                     |          |                    | Sets the scope used with Oauth flows |
    % | oauthService              |   Yes    | Databricks         | Oauth service provider one of Databricks, EntraID, Unspecified |
    % | oauth2ClientId            |   Yes    | databricks-sql-odbc | Used in OauthU2M mode |
    % |                           |          |                    | |
    % | dsnless                   |          |                    | Overrides the complete dsnless value |
    % | dsnlessAppend             |          |                    | Value appended to the dsnless, can be used to add further values to the dsnless |
    % | driver                    |          |                    | ODBC driver |
    % | httpPath                  |          |                    | Overrides the httpPath portion of the dsnless |
    % | ssl                       |          | 1                  | 1 or 0, specified as a string |
    % | thriftTransport           |          | 2                  | Thrift transport flag |
    % |                           |          |                    | |
    % | defaultStringColumnLength |          |                    | Truncation work around value for string lengths > 4000 |
    % |                           |          |                    | |
    % | logLevel                  |          | 0                  | Specified as a string |
    % | verbose                   |          | 1                  | Function argument only, specified as a logical |
    %
    % * N1: token passthrough an access token obtained by some means is passed as
    % a named argument. Be aware that access tokens typically expire after a certain
    % amount of time, after which you must either refresh the token or obtain a new
    % one from the server.
    %
    % This class uses the Databricks ODBC driver v2.8.0 and greater.
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
    % This is also called by the object's delete destructor.
    %
    % If a connection cannot be created an empty database.odbc.connection is returned
    % in the connection property. If an ODBC Driver Error is returned in the connection's
    % Message property it will be displayed but an error will not be raised directly.
    %
    % defaultStringColumnLength Sets the maximum number of characters that can be
    % contained in STRING columns. By default, the columns metadata for Spark does
    % not specify a maximum length for STRING columns. In a future MATLAB release
    % this can be used to address string truncation for long strings > 4000
    % characters in length.
    %
    % Examples:
    %    % Can be moved to a namespace if desired
    %    % Not added to the path by startup.m
    %    o = StandaloneODBCConnection(schema='myDatabaseName');
    %    conn = o.Connection;
    %
    %    o = StandaloneODBCConnection;
    %    conn = o.Connection;
    %
    % The dsnlessAppend argument can be used to add further values to the
    % connection string. It is appended to the constructed value.
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

    % Copyright 2024-2025 The MathWorks, Inc.

    properties
        Connection database.odbc.connection
    end

    properties (Hidden)
        dsnless string
    end

    methods
        function obj = StandaloneODBCConnection(options)
            arguments
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
                options.tokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                options.scope string {mustBeTextScalar}
                options.oauthService string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.dsnless string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.dsnlessAppend string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.driver string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.thriftTransport string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                options.defaultStringColumnLength string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) string
            end

            if isMATLABReleaseOlderThan("R2022b")
                fprintf(2, "This package requires MATLAB R2022b or later\n.");
                return; % will likely hit a hard error at a later point
            end

            if isempty(ver('database'))
                fprintf(2, "Database Toolbox is not installed.\n");
                fprintf(2, "JDBC/ODBC/SQL Warehouse connections cannot be used.\n");
                return;
            end

            % Read settings from a json file and options as named arguments.
            % Settings are not related to the <prefdir>/databricks-settings.json file.
            % Options override the settings file when present in both.
            % The default setting file name is: databricks_standalone_odbc_settings.json
            settings = configureDefaults(obj, options);

            driver = getODBCDriver(obj, settings);

            checkDatasourceConflict(obj, settings);

            % Package based authentication is not available in the standalone scenario
            if obj.nonzeroSettingsString(settings, "dsnless")
                authSrc = "dsnless";
                if settings.verbose
                    fprintf("Authenticating using a provided dsnless.\n")
                end
            elseif obj.nonzeroSettingsString(settings, "passthroughAccessToken")
                authSrc = "passthroughToken";
                if settings.verbose
                    if isfield(options, 'passthroughRefreshToken')
                        fprintf("Authenticating using a provided passthrough access token and refresh token.\n")
                    else
                        fprintf("Authenticating using a provided passthrough access token.\n")
                    end
                end
            else
                authSrc = "driverAuth";
                % Default case
                if settings.verbose
                    fprintf("Authenticating using the ODBC driver's built-in authentication support.\n")
                end
            end


            if strcmp(authSrc, "dsnless")
                dsnless = string(settings.dsnless);
            else
                %% Host
                obj.notSetError(settings, "host");
                %% Scheme
                if startsWith(settings.host, "http", IgnoreCase=true)
                    hostURI = matlab.net.URI(settings.host);
                    hostEncodedAuthority = string(hostURI.EncodedAuthority);
                else
                    hostEncodedAuthority = host;
                end
                obj.notSetError(settings, "port");
                dsnless = "Driver=" + driver + ";" + "Host=" + hostEncodedAuthority + ";" + "Port=" + string(settings.port) + ";";

                %% schema - checked above
                dsnless = dsnless + "Schema=" + string(settings.schema) + ";";

                %% httpPath
                if obj.nonzeroSettingsString(settings, 'httpPath')
                    dsnless = dsnless + "httpPath=" + string(settings.httpPath) + ";";
                else
                    %% orgId
                    obj.notSetError(settings, "orgId");
                    %% clusterId
                    obj.notSetError(settings, "clusterId");
                    dsnless = dsnless + "httpPath=" + "sql/protocolv1/o/" + string(settings.orgId) + "/" + settings.clusterId + ";";
                end

                %% ssl
                obj.notSetError(settings, "ssl");
                dsnless = dsnless + "ssl=" + string(settings.ssl) + ";";

                %% thriftTransport
                if obj.nonzeroSettingsString(settings, "thriftTransport")
                    dsnless = dsnless + "thriftTransport=" + string(settings.thriftTransport) + ";";
                end

                %% defaultStringColumnLength truncation workaround support for a future release
                if  obj.nonzeroSettingsString(settings, "defaultStringColumnLength")
                    dsnless = dsnless + "DefaultStringColumnLength=" + string(settings.defaultStringColumnLength) + ";";
                end

                %% catalog
                if obj.nonzeroSettingsString(settings, "catalog")
                    dsnless = dsnless + "catalog=" + string(settings.catalog) + ";";
                end

                %% Add authentication details
                authStr = getAuthArgs(obj, authSrc, settings);
                if strlength(authStr) == 0
                    error("DATABRICKS:STANDALONEODBCCONNECTION", "Authentication values not set.");
                else
                    dsnless = dsnless + authStr;
                end

                %% UserAgentEntry
                dsnless = dsnless + "UserAgentEntry=" + obj.getUserAgent() + ";";

                %% LogLevel
                if obj.nonzeroSettingsString(settings, "logLevel")
                    dsnless = dsnless + "LogLevel=" + string(settings.logLevel) + ";";
                end

                %% dsnlessAppend
                if obj.nonzeroSettingsString(settings, "dsnlessAppend")
                    dsnless = dsnless + string(settings.dsnlessAppend);
                end
            end
            obj.dsnless = dsnless;

            try
                obj.Connection = database(dsnless);
                if ~isempty(obj.Connection.Message)
                    fprintf(2, "Error ODBC connection not open, Message:\n%s\n\n", obj.Connection.Message);
                end
                obj.checkDriverVersion("2.8.2");
            catch ME
                fprintf(2, "Error creating ODBC connection, Message:\n%s\n\n", ME.message);
            end
        end


        function close(obj)
            if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.odbc.connection')
                obj.Connection.close();
            end
        end
    end %methods


    methods(Hidden)
        function checkDriverVersion(obj, requiredVersion, errorOnLt)
            arguments
                obj (1,1)
                requiredVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
                errorOnLt (1,1) logical = false
            end

            if isempty(obj.Connection)
                fprintf(2, "Connection property is empty, cannot check driver version.\n")
                return;
            end
        
            if isempty(obj.Connection) || strlength(obj.Connection.DriverVersion) == 0
                fprintf(2, "The connection DriverVersion property is not set, cannot check driver version.\n")
                return;
            end

            % Does not return a true sematic version, assume we can ignore
            % the 4th numeric field
            verFields = split(string(obj.Connection.DriverVersion), ".");
            if numel(verFields) < 3
                 error("DATABRICKS:ODBCConnection", "Unexpected ODBC driver version value: %s", obj.Connection.DriverVersion);
            end

            major = double(verFields(1));
            minor = double(verFields(2));
            patch = double(verFields(3));

            tooLow = false;
            if major < 2
                tooLow = true;
            elseif major == 2
                if minor < 8
                   tooLow = true;
                elseif minor == 8
                    if patch < 2
                        tooLow = true;
                    end
                end
            end

            if tooLow
                if errorOnLt
                    error("DATABRICKS:ODBCConnection", "The ODBC driver is version: %s, expected: or greater.\n", obj.Connection.DriverVersion, requiredVersion);
                else
                    fprintf(2, "The ODBC driver is version: %s, expected: %s or greater.\n", obj.Connection.DriverVersion, requiredVersion);
                end
            end
        end


        function authStr = getAuthArgs(obj, authSrc, settings)
            % GETAUTHARGS Returns the auth section of the connection URL incl. scope
            % Also returns the username and password fields as required for PAT
            arguments
                obj (1,1)
                authSrc string {mustBeTextScalar, mustBeNonzeroLengthText}
                settings struct
            end

            if strcmp(authSrc, "passthroughToken")
                authStr = "AuthMech=11;Auth_Flow=0;Auth_AccessToken=" + settings.passthroughAccessToken + ";";
            
            else
                obj.notSetError(settings, "authMethod");
                switch settings.authMethod
                    case "PAT"
                        obj.notSetError(settings, "token");
                        authStr = "AuthMech=3" + ";UID=token" + ";PWD=" + settings.token + ";";

                    case "OauthM2M"
                        authStr = "AuthMech=11" + ";Auth_Flow=1" + ";Auth_Client_ID=" + settings.clientId + ";Auth_Client_Secret=" + settings.clientSecret + ";";
                        if obj.nonzeroSettingsString(settings, "tokenCachePassPhrase")
                            authStr = authStr + "TokenCachePassPhrase=" + settings.tokenCachePassPhrase + ";";
                        end

                    case "OauthU2M"
                        [~, uid] = fileparts(tempname);
                        authStr = "AuthMech=11" + ";Auth_Flow=2" + ";PWD=" +  uid + ";";
                        if obj.nonzeroSettingsString(settings, "oauth2ClientId")
                            authStr = authStr + "Auth_Client_ID=" + settings.oauth2ClientId + ";";
                        end
                        if obj.nonzeroSettingsString(settings, "tokenCachePassPhrase")
                            authStr = authStr + "TokenCachePassPhrase=" + settings.tokenCachePassPhrase + ";";
                        end

                    otherwise
                        error("DATABRICKS:STANDALONEODBCCONNECTION", "Unexpected authentication method");
                end
            end

            %% Scope
            obj.notSetError(settings, "oauthService")
            scopeArgs = {};
            if obj.nonEmptySettingsString(settings, "scope")
                scopeArgs{end+1} = "scope";
                scopeArgs{end+1} = string(settings.scope);
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
                    error('DATABRICKS:STANDALONEODBCCONNECTION', 'An ODBC/JDBC datasource exists with the same name as the database: %s\nAmend the datasource name', settings.schema);
                end
            end
        end


        function driver = getODBCDriver(obj, settings)
            arguments
                obj (1,1)
                settings struct
            end

            if obj.nonzeroSettingsString(settings, "driver")
                driver = settings.driver;
            else
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
                    driver = "{Simba Spark ODBC Driver}"; % As configured by the driver installer on Windows
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
            % The default setting file name is: databricks_standalone_odbc_settings.json
            settings = obj.getSettings(options);

            % Set defaults if not set by arguments or the JSON file
            if ~obj.nonzeroSettingsString(settings, "authMethod")
                settings.authMethod = "OauthU2M";
            end
            if ~obj.nonzeroSettingsString(settings, "oauthService")
                settings.oauthService = "Databricks";
            end
            if ~obj.nonzeroSettingsString(settings, "oauth2ClientId")
                settings.oauth2ClientId = "databricks-sql-odbc";
            end
            if ~obj.nonzeroSettingsString(settings, "port")
                settings.port = "443";
            end
            if ~obj.nonzeroSettingsString(settings, "thriftTransport")
                settings.thriftTransport = "2";
            end
            if ~obj.nonzeroSettingsString(settings, "tokenCachePassPhrase")
                if ~ispc
                    settings.tokenCachePassPhrase = "InsecureTokenCachePassPhrase";
                end
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


        function userAgent = getUserAgent(options)
            % getUserAgent Returns user agent based on a MATLAB Release value
            % Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
            % By default the current release is used.
            %
            % Example:
            %   userAgent = databricks.Object.getUserAgent(release="R2025b");

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


        function settings = getSettings(obj, constructorArgs, options)
            arguments
                obj %#ok<INUSA>
                constructorArgs (1,1) struct
                options.verbose (1,1) logical = true
            end

            if isfield(options, "settingsFile")
                settingsFile = options.settingsFile;
            else
                settingsFile = "databricks_standalone_odbc_settings.json";
            end

            % Initial Settings are based on arguments to the constructor which may have defaults
            % i.e. the options to the constructor
            settings = constructorArgs;

            settingsFilePath = which(settingsFile);
            if isempty(settingsFilePath)
                if options.verbose
                    fprintf(2, "Settings file not configured.\n");
                end
            elseif ~isfile(settingsFilePath)
                if options.verbose
                    fprintf(2, "Settings file not found: %s", settingsFilePath);
                end
            else
                try
                    jsonSettings = jsondecode(fileread(settingsFilePath));
                catch ME
                    error("DATABRICKS:STANDALONEODBCCONNECTION", "Unable to read: %s\nMessage: %s", settingsFilePath, ME.message);
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
                error("DATABRICKS:STANDALONEODBCCONNECTION", "Field: %s is not found or configured in settings or options", name);
            end
        end


        function scope = getScope(obj, authMethod, oauthService, options)
            % getScope Returns a scope field as a string
            arguments
                obj %#ok<INUSA>
                authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
                oauthService string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar}
                options.oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.vendor string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if ~(strcmp(authMethod, "OauthU2M") || strcmp(authMethod, "OauthM2M"))
                % fprintf(2, "Scope value should only be set when using OauthU2M or OauthM2M\n.");
                scope = "";
                return;
            end

            if isfield(options, "scope") && strlength(options.scope) > 0
                scope = "Auth_Scope=" + options.scope + ";";
            else
                switch oauthService
                    case "Databricks"
                        if strcmp(authMethod, "OauthU2M")
                            if isfield(options, "oauth2ClientId") && strcmp(options.oauth2ClientId, "databricks-sql-odbc")
                                scope = "Auth_Scope=sql offline_access;";
                            else
                                if isfield(options, "vendor") && strcmpi(options.vendor, "azure")
                                    scope = "Auth_Scope=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/user_impersonation, offline_access;";
                                else
                                    scope = "Auth_Scope=sql offline_access;";
                                end
                            end
                        elseif strcmp(authMethod, "OauthM2M")
                            if isfield(options, "oauth2ClientId") && strcmp(options.OAuth2ClientId, "databricks-sql-odbc") % Updated for driver version 2.8.2
                                scope = "Auth_Scope=all-apis;";
                                % https://docs.databricks.com/en/integrations/odbc/authentication.html says use: all-apis
                                % Potentially less recent driver Release Notes say to use "sql"
                            else
                                if isfield(options, "vendor") && strcmpi(options.vendor, "azure")
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

                    case "EntraID"
                        % Don't override the scope based on the behavior of driver v 2.6.36
                        scope = "";

                    case "Unspecified"
                        scope = ""; % Do nothing, leave it to the driver

                    otherwise
                        error("DATABRICKS:STANDALONEODBCCONNECTION", "Unexpected OauthService value: %s", authService);
                end
            end
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                if ~isempty(obj.dsnless)
                    cu = obj.dsnless;
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