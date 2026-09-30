classdef SQLWarehouse < databricks.Object & matlab.databricks.StructOrCellDeserializable
    % SQLWarehouse Databricks interface to manipulate SQL Warehouses
    % via the databricks 2.0 REST API. Please see the documentation at:
    % https://docs.databricks.com/sql/api/sql-endpoints.html
    %
    % To obtain a list of existing end-points call the static list method
    %
    %   warehouses = databricks.SQLWarehouse.list()
    %
    % When called without inputs, constructs an entirely empty SQLWarehouse
    % instance. One can then for example assign the ID of a known existing
    % warehouse and call refresh to see its status:
    %
    %   >> warehouse = databricks.SQLWarehouse();
    %   >> warehouse.id = "qfufxboufejuuibuxbz";
    %   >> warehouse.refresh
    %   >> warehouse
    %
    %   warehouse =
    %
    %       SQLWarehouse with properties:
    %
    %                            id: "qfufxboufejuuibuxbz"
    %                          name: "mywarehouse"
    %                  cluster_size: "2X-Small"
    %                auto_stop_mins: 10
    %          spot_instance_policy: COST_OPTIMIZED
    %                  num_clusters: 1
    %              min_num_clusters: 1
    %              max_num_clusters: 1
    %           num_active_sessions: 0
    %                         state: RUNNING
    %                  creator_name: "user@company.com"
    %                    creator_id: "3141592653589793"
    %                      jdbc_url: "jdbc:spark://adb-42424242424242.1.azuredatabricks.net:443/default;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/qfufxboufejuuibuxbz;"
    %                   odbc_params: [1×1 databricks.datastructures.ODBCParams]
    %                          tags: [1×1 databricks.datastructures.WarehouseTags]
    %                        health: [1×1 databricks.datastructures.WarehouseHealth]
    %                 enable_photon: 1
    %     enable_serverless_compute: 0
    %                       channel: [1×1 databricks.datastructures.Channel]
    %
    % Or this can be used to create a new warehouse:
    %
    %   % Create an empty SQLWarehouse
    %   warehouse = databricks.SQLWarehouse();
    %   % Set all required properties for creating a new instance
    %   warehouse.name = "myNewInstance"
    %   warehouse.cluster_size = "Small";
    %   warehouse.min_num_clusters = 1;
    %   warehouse.max_num_clusters = 2;
    %   % Create the new warehouse
    %   warehouse.create();
    %
    % If an SQLWarehouse instance has a valid id set (either manually or
    % obtained through the list() method), the SQLWarehouse can be started,
    % stopped or deleted:
    %
    %   warehouse.start()
    %   warehouse.stop()
    %   warehouse.remove()
    %
    % And if Database Toolbox as well as the Databricks JDBC Driver have
    % been installed a Database Toolbox connection to the Warehouse can be
    % made:
    %
    %   conn = warehouse.connect();
    %
    % The refresh, start, stop and remove methods can also be used
    % on an array of SQLWarehouse to perform these operations on multiple
    % SQLWarehouses in a single call.
    %
    % The Databricks JDBC driver v2.6.36 or greater is required.
    %
    % See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf

    % Copyright 2022-2025 The MathWorks, Inc.

    properties
        % SQL Warehouse ID.
        id string
        % Name of the SQL warehouse.
        name string
        % The size of the clusters allocated to the warehouse: "2X-Small",
        % "X-Small", "Small", "Medium", "Large", "X-Large", "2X-Large",
        % "3X-Large", "4X-Large". For the mapping from cluster to instance
        % size, see https://docs.databricks.com/sql/admin/sql-endpoints.html#cluster-size.
        cluster_size string
        % Time until an idle SQL warehouse terminates all clusters and stops.
        auto_stop_mins int32
        % The spot policy to use for allocating instances to clusters.
        spot_instance_policy databricks.datastructures.WarehouseSpotInstancePolicy
        % Number of clusters allocated to the warehouse.
        num_clusters int32
        % Minimum number of clusters available when a SQL warehouse is
        % running.
        min_num_clusters int32
        % Maximum number of clusters available when a SQL warehouse is
        % running.
        max_num_clusters int32
        % Number of active JDBC and ODBC sessions running on the SQL
        % warehouse.
        num_active_sessions int32
        % State of the SQL warehouse.
        state databricks.datastructures.WarehouseState
        % Email address of the user that created the warehouse.
        creator_name string
        % Databricks ID of the user that created the warehouse.
        creator_id string
        % The URL used to submit SQL commands to the SQL warehouse using
        % JDBC.
        jdbc_url string
        % The host, path, protocol, and port information required to submit
        % SQL commands to the SQL warehouse using ODBC.
        odbc_params databricks.datastructures.ODBCParams
        % Key-value pairs that describe the warehouse.
        tags databricks.datastructures.WarehouseTags
        % The health of the warehouse.
        health databricks.datastructures.WarehouseHealth
        % Whether queries are executed on a native vectorized engine that
        % speeds up query execution.
        enable_photon logical
        % Whether this SQL warehouse is a Serverless warehouse.
        enable_serverless_compute logical
        % Whether the SQL warehouse uses the current SQL warehouse compute
        % version or the preview version.
        channel databricks.datastructures.Channel
        % Warehouse type: PRO or CLASSIC. If you want to use serverless compute,
        % you must set to PRO and also set the field enable_serverless_compute to true.
        warehouse_type databricks.datastructures.WarehouseType
    end

    methods

        function obj = SQLWarehouse(varargin)
            % SQLWarehouse Constructor

            % If called through list()
            if nargin == 1 && (isstruct(varargin{1}) || iscell(varargin{1}))
                % Authenticate using default parameters
                obj.getAuth();
                % And fill-in object properties based on structure or cell
                % array passed along by list()
                obj = obj.fromStructOrCell(varargin{1});
            else % Called manually
                obj.getAuth(varargin{:});
            end

        end

        function stop(obj)
            % STOP stops the SQL warehouse
            for arrayIndex = 1:length(obj)
                obj(arrayIndex).performAction('stop');
            end
        end

        function start(obj)
            % START starts the SQL warehouse
            for arrayIndex = 1:length(obj)
                obj(arrayIndex).performAction('start');
            end
        end

        function remove(obj)
            % REMOVE deletes the SQL warehouse entirely
            %
            % This method in the Databricks API is called delete. It's called
            % remove here, to avoid confusion with the built-in MATLAB delete
            % method.
            for arrayIndex = 1:length(obj)
                if isempty(obj(arrayIndex).id)
                    error('DATABRICKS:ERROR', 'SQL warehouse "id" must be set.');
                end
                % Get URI
                clusterURI = obj(arrayIndex).getURI('sql', ['warehouses/' char(obj(arrayIndex).id)]);

                % Start a DELETE request
                request = obj(arrayIndex).getRequestMessage('DELETE');

                % Perform the actual call
                resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

                if resp.StatusCode ~= matlab.net.http.StatusCode.OK
                    throw(matlab.databricks.ResponseException(resp,sprintf('Failed to refresh SQL warehouse for id "%s"',obj(arrayIndex).id)));
                end
            end
        end

        function create(obj)
            % CREATE creates a new SQL warehouse based on the configured
            % properties. The following properties are required:
            %     "name"
            %     "cluster_size"
            %     "min_num_clusters"
            %     "max_num_clusters"
            % The following properties are optional:
            %     "auto_stop_mins"
            %     "tags"
            %     "spot_instance_policy"
            %     "enable_photon"
            %     "enable_serverless_compute"
            %     "channel"
            % Any other properties which might have been set will be
            % ignored.

            if length(obj) > 1
                error('DATABRICKS:ERROR','Please start SQL warehouses one at a time.');
            end

            % Verify properties. Ensure that required parameters are in
            % fact set, add optional parameters if they are set and warn if
            % other irrelevant properties were set
            requiredProperties = [
                "name"
                "cluster_size"
                "min_num_clusters"
                "max_num_clusters"
                ];
            optionalProperties = [
                "auto_stop_mins"
                "tags"
                "spot_instance_policy"
                "enable_photon"
                "enable_serverless_compute"
                "channel"
                "warehouse_type"
                ];

            % Go through all properties
            props = properties(obj);
            for i=1:length(props)
                prop = props{i};
                if ismember(prop,requiredProperties)
                    if isempty(obj.(prop))
                        % If required but not set throw an error
                        error('DATABRICKS:ERROR','Property "%s" must be set',prop)
                    else
                        % If required and set, add to request body
                        reqstruct.(prop) = obj.(prop);
                    end
                elseif ismember(prop,optionalProperties)
                    if ~isempty(obj.(prop))
                        % If optional and set, add to request body
                        reqstruct.(prop) = obj.(prop);
                    end
                else
                    if ~isempty(obj.(prop))
                        % If not used but set, warn
                        warning('DATABRICKS:IGNOREDPROPERTYSET','Property "%s" has explicitly been set but will be ignored when creating a new SQL warehouse',prop)
                    end
                end
            end

            % Obtain the URL
            clusterURI = obj.getURI('sql', 'warehouses');
            % Start a POST request
            request = obj.getRequestMessage('POST');
            % Set the body to the configured parameters
            request.Body = matlab.net.http.MessageBody();
            request.Body.Payload = jsonencode(reqstruct);
            % Perform the actual POST
            resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

            % Check the response
            if resp.StatusCode == matlab.net.http.StatusCode.OK
                % Read the ID of the newly created warehouse
                obj.id = resp.Body.Data.id;
                % Refresh the object to reflect new status
                obj.refresh();
            else
                throw(matlab.databricks.ResponseException(resp,sprintf('Failed to create SQL warehouse"')));
            end
        end


        function refresh(obj)
            for arrayIndex=1:length(obj)
                % REFRESH update the object instance by querying Databricks
                if isempty(obj(arrayIndex).id)
                    error('DATABRICKS:ERROR', 'SQL warehouse "id" must be set.');
                end

                % Get URI
                clusterURI = obj(arrayIndex).getURI('sql', ['warehouses/' char(obj(arrayIndex).id)]);

                % Start a GET request
                request = obj(arrayIndex).getRequestMessage('GET');

                % Perform the actual call
                resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

                if resp.StatusCode == matlab.net.http.StatusCode.OK
                    obj(arrayIndex).fromStructOrCell(resp.Body.Data);

                else
                    throw(matlab.databricks.ResponseException(resp,sprintf('Failed to refresh SQL warehouse for id "%s"',obj(arrayIndex).id)));
                end

            end
        end


        function edit(obj)
            % EDIT Change settings of the SQL warehouse

            if length(obj) > 1
                error('DATABRICKS:ERROR','Please update SQL warehouses one at a time.');
            end

            % Similar to create create a struct with the required and
            % optional parameters.
            requiredProperties = [
                "id"
                ]; %#ok

            optionalProperties = [
                "name"
                "cluster_size"
                "min_num_clusters"
                "max_num_clusters"
                "auto_stop_mins"
                "tags"
                "spot_instance_policy"
                "enable_photon"
                "enable_serverless_compute"
                "channel"
                ];

            % Go through all properties and form the request body
            props = properties(obj);
            for i=1:length(props)
                prop = props{i};
                if ismember(prop,requiredProperties)
                    if isempty(obj.(prop))
                        % If required but not set throw an error
                        error('DATABRICKS:ERROR','Property "%s" must be set',prop)
                    else
                        % If required and set, add to request body
                        reqstruct.(prop) = obj.(prop);
                    end
                elseif ismember(prop,optionalProperties)
                    if ~isempty(obj.(prop))
                        % If optional and set, add to request body
                        reqstruct.(prop) = obj.(prop);
                    end
                end
            end

            % Obtain the URL
            clusterURI = obj.getURI('sql', ['warehouses/' char(obj.id) '/edit']);
            % Start a POST request
            request = obj.getRequestMessage('POST');
            % Set the body to the configured parameters
            request.Body = matlab.net.http.MessageBody();
            request.Body.Payload = jsonencode(reqstruct);
            % Perform the actual POST
            resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

            % Check the response
            if resp.StatusCode == matlab.net.http.StatusCode.OK
                % Refresh the object to reflect new status
                obj.refresh();
            else
                throw(matlab.databricks.ResponseException(resp,'Failed to update the SQL warehouse"'));
            end

        end

        function [conn, xDBCConnection] = connect(obj,databaseName,options)
            % CONNECT Create a Database Toolbox connection using the
            % Databricks JDBC Driver for the specified SQL warehouse.
            % 
            % Positional argument:
            % The database name can be provided as the first (excl. warehouse
            % object) positional argument, if not provided a default value
            % of "default" is used.
            %
            % Named arguments:
            % The following optional named arguments can be used to override the values
            % obtained from settings & configuration files and defaults.
            %
            %  Name                    Type    Default
            %  ---------------------------------------
            %  mode                    string  "JDBC"
            %  port                    string  "443"
            %  ssl                     logical true
            %  thriftTransport         int32
            %  catalog                 string
            %  httpPath                string
            %  authMethod              matlab.databricks.AuthMethod  Settings file authMethod value
            %  profileName             string  Configuration file profileName value
            %  passthroughAccessToken  string
            %  scope                   string
            %  OauthService            matlab.databricks.OauthService  matlab.databricks.OauthService.Databricks
            %  logLevel                string  "0"
            %  verbose                 logical true
            %
            %  JDBC specific:
            %  jarFilePath             string  databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
            %  driverClass             string  "com.databricks.client.jdbc.Driver"
            %  connectionURL           string
            %  connectionURLAppend     string
            %  useNativeQuery          logical true
            %  enableNativeParameterizedQuery logical false
            %
            %  ODBC specific:
            %  dsnless                 string
            %  driver                  string
            %  dsnlessAppend           string
            %
            %
            %  mode set the connection type to "JDBC" or "ODBC".
            %
            %  catalog set the unity catalog catalog.
            %
            %  httpPath overrides the httpPAth portion of the connection URL.
            %
            %  authMethod a matlab.databricks.AuthMethod
            %  to force a given authentication method default preferred method
            %  is not used. See: Documentation/Authentication.md
            % 
            %  profileName a scalar text name for a profile to be source
            %  from a .databrickscfg file. See: Documentation/Authentication.md
            %
            %  passthroughAccessToken value for a token that is passed opaquely.
            %  
            %  scope set the scope used with Oauth flows.
            %
            %  OauthService specify an Oauth service provider.
            %
            %  logLevel a string text logging level, the default value is: "0"
            %
            %  verbose a logical flag to enable more or less feedback,
            %  default is true
            %
            %  JDBC specific:
            %  connectionURL overrides the complete connection URL value.
            %
            %  connectionURLAppend a value appended to the connection URL.
            %
            %
            %  ODBC specific:
            %
            %  dsnless overrides the complete connection string value.
            %
            %  driver path for the driver file or dsn identifier.
            %
            %  dsnlessAppend a value appended to the connection string.
            %
            %
            % Previous (prior to release 4.0.0) support for the AUTHMECH arguments
            % should be updated as follows:
            %
            %   PersonalAccessToken argument use should be adapted to use
            %   authMethod=matlab.databricks.AuthMethod.PAT
            %   where the token is sourced from a .databrickcfg file or
            %   environment variable inline with the unified authentication
            %   approach. See Documentation/Authentication.md for more
            %   details. Generally the preferred authentication method is
            %   defined in the databricks-settings.json file. See:
            %   Documentation/setup.md for details.
            %
            %   AzureADToken argument use should be adapted to use OauthU2M
            %   or OauthM2M flows or if necessary the passthroughAccessToken
            %   named argument. Use a OauthService argument set to:
            %   matlab.databricks.OauthService.Databricks.
            %   Again see Documentation/Authentication.md &
            %   Documentation/setup.md for details.
            %   
            % For further details on alternative SQL connection approaches
            % see:
            %   Documentation/JDBCWorkflow.md
            %   Documentation/SQLWarehousesAPI.md
            %   Documentation/StatementExecution.md
            %
            % Examples:
            %
            %   % Specify warehouse settings
            %   warehouse = databricks.SQLWarehouse;
            %   warehouse.id = "qfufxboufejuuibuxbz";
            %   
            %   % Connect to database "default" using the default
            %   % authentication method
            %   conn = warehouse.connect()
            %
            %   % Or, to connect to database "other" using
            %   % Machine-to-Machine auth detailed in a profile myM2MProfile
            %   conn = warehouse.connect("other",authMethod=matlab.databricks.AuthMethod.OauthM2M, profileName="myM2MProfile");

            arguments
                obj databricks.SQLWarehouse
                databaseName string = "default"
                options.mode string {mustBeTextScalar, mustBeMember(options.mode, {'JDBC', 'ODBC', 'jdbc', 'odbc'})} = 'JDBC'
                
                options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.port string {mustBeTextScalar, mustBeNonzeroLengthText} = "443"
                options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                % Authentication
                options.useDriverAuth (1,1) logical = true;
                options.authMethod = databricks.internal.settings.Settings.getSettingsField("authMethod")
                options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            
                % Oauth2
                options.OauthService matlab.databricks.OauthService = matlab.databricks.OauthService.Databricks
                options.Oauth2ClientId string {mustBeTextScalar, mustBeNonzeroLengthText} = "databricks-sql-jdbc"
                options.passthroughAccessToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.passthroughRefreshToken string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.scope string {mustBeTextScalar}
            
                options.tokenCachePassPhrase string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.settings.Settings.getSettingsField("username");
                options.enableTokenCache (1,1) logical
                options.cacheFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
            
                options.httpPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ssl (1,1) logical = true
                options.thriftTransport (1,1) int32
                options.defaultStringColumnLength (1,1) int32 {mustBePositive, mustBeReal, mustBeFinite}
               
                % Misc
                options.logLevel string {mustBeTextScalar, mustBeNonzeroLengthText} = "0"
                options.verbose (1,1) logical = true;
                
                % ODBC specific
                options.driver string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.dsnless string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.dsnlessAppend string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                % JDBC specific
                options.driverClass string {mustBeTextScalar, mustBeNonzeroLengthText}= "com.databricks.client.jdbc.Driver"
                options.jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText} = databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
                options.useDriverType char {mustBeMember(options.useDriverType,{'simba','oss'})}
                options.connectionURL string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.connectionURLAppend string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.disableSourceCreation (1,1) logical = false
                options.dataSourceName string {mustBeTextScalar, mustBeNonzeroLengthText}
                % Write optimization
                options.useNativeQuery (1,1) logical
                options.enableNativeParameterizedQuery (1,1) logical
            end

            if length(obj)>1
                error('DATABRICKS:ERROR', 'While it is possible to have multiple Database Toolbox connections to different warehouses at a time, please connect to each instance one-by-one.');
            end

            % ID must be set
            if isempty(obj.id)
                error('DATABRICKS:ERROR', 'SQL warehouse "id" must be set.');
            end

            if isempty(options.authMethod)
                options.authMethod = matlab.databricks.AuthMethod.Chain;
            elseif isa(options.authMethod, 'matlab.internal.databricks.AuthMethod')
                options.authMethod = matlab.databricks.AuthMethod.(string(options.authMethod));
            end

            % Refresh to ensure properties are up to date
            obj.refresh();

            % If somehow no odbc_params are available, error
            if isempty(obj.odbc_params)
                error('DATABRICKS:ERROR','Unable to determine JDBC URL for SQL warehouse with id "%s"',obj.id);
            end

            % TODO sending a start command or otherwise not blocking...
            % Verify STATE
            if obj.state ~= databricks.datastructures.WarehouseState.RUNNING
                fprintf(['Specified SQL warehouse is not currently RUNNING.\n' ...
                    'Connecting to this warehouse will start it first.\n' ...
                    'Depending on the exact configuration this may take several minutes.\n' ...
                    'MATLAB will be blocked during this operation.\n'])
            end

            % Build URL based on ODBC properties rather than using jdbc_url
            % as this allows building URL for different authentication
            % mechanisms and different driver versions, etc.

            % Common arguments
            cArgs = {};
            cArgs{end+1} = "schema";
            cArgs{end+1} = databaseName;

            cArgs{end+1} = "host";
            if isfield(options, "host")
                cArgs{end+1} = options.host;
            else
                cArgs{end+1} = obj.odbc_params.hostname;
            end
            cArgs{end+1} = "port";
            if isfield(options, "port")
                cArgs{end+1} = options.port;
            else
                cArgs{end+1} = obj.odbc_params.port; % Applies to JDBC too
            end
            cArgs = matlab.utils.addArgs(options, "catalog", cArgs);

            % Authentication
            cArgs = matlab.utils.addArgs(options, ["useDriverAuth", "authMethod", "profileName"], cArgs);

            % Oauth2
            cArgs{end+1} = "httpPath";
            if isfield(options, 'httpPath')
                cArgs{end+1} = options.httpPath;
            else
                cArgs{end+1} = obj.odbc_params.path;
            end
            if isfield(options, 'Oauth2ClientId')
                if strcmpi(options.mode, "jdbc")
                    cArgs{end+1} = "oauth2ClientId";
                else
                    cArgs{end+1} = "OAuth2ClientId";
                end
            else
                cArgs{end+1} = options.Oauth2ClientId;
            end
            if isfield(options, 'tokenCachePassPhrase')
                if strcmpi(options.mode, "jdbc")
                    cArgs{end+1} = "TokenCachePassPhrase";
                else
                    cArgs{end+1} = "tokenCachePassPhrase";
                end
            else
                cArgs{end+1} = options.tokenCachePassPhrase;
            end
            cArgs = matlab.utils.addArgs(options, ["OauthService", "passthroughAccessToken",...
                "passthroughRefreshToken", "scope", "enableTokenCache", "cacheFilePath",...
                "ssl", "thriftTransport", "defaultStringColumnLength"], cArgs);

            % Misc
            cArgs = matlab.utils.addArgs(options, ["logLevel", "verbose"], cArgs);

            if strcmpi(options.mode, "jdbc")
                jArgs = {};
                jArgs{end+1} = "dataSourceName";
                if isfield(options, "dataSourceName")
                    jArgs{end+1} = options.dataSourceName;
                else
                    jArgs{end+1} = "Databricks-" + string(obj.id);
                end
                jArgs = matlab.utils.addArgs(options, ["driverClass", "jarFilePath", "useDriverType",...
                    "connectionURL", "connectionURLAppend", "disableSourceCreation",...
                    "useNativeQuery", "enableNativeParameterizedQuery"], jArgs);
            else
                oArgs = {};
                oArgs = matlab.utils.addArgs(options, ["driver", "dsnless", "dsnlessAppend"], oArgs);
            end

            if strcmpi(options.mode, "jdbc")
                xDBCConnection = databricks.JDBCConnection(cArgs{:}, jArgs{:});
                conn = xDBCConnection.Connection;
            else
                xDBCConnection = databricks.ODBCConnection(cArgs{:}, oArgs{:});
                conn = xDBCConnection.Connection;
            end
        end


        function set.cluster_size(obj,val)
            arguments
                obj databricks.SQLWarehouse
                val string {mustBeMember(val,["2X-Small","X-Small",...
                    "Small", "Medium", "Large", "X-Large", "2X-Large",...
                    "3X-Large", "4X-Large"])}
            end
            % Ideally cluster_size could have been an enum but since the
            % actual string values are not valid MATLAB Variable names and
            % hence not valid enum values, use a setter instead to ensure
            % valid cluster_sizes are set
            obj.cluster_size = val;
        end

    end %public methods

    methods (Access=private)

        function performAction(obj,action)
            % PERFORMACTION Shared code for start and stop
            arguments
                obj databricks.SQLWarehouse
                action char
            end
            % These operations require a valid ID, validate that it has
            % been set
            if isempty(obj.id)
                error('DATABRICKS:ERROR', 'SQL warehouse "id" must be set.');
            end

            % Form the correct URL for the requested action
            clusterURI = obj.getURI('sql', ['warehouses/' char(obj.id) '/' action]);

            % Start a POST request
            request = obj.getRequestMessage('POST');

            % Disable "expected POST to have a Body" warning
            warnState = warning('off','MATLAB:http:BodyExpectedFor');

            % Perform the actual call
            resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

            % Restore warning state
            warning(warnState)

            % Verify whether the operation was a success
            if resp.StatusCode ~= matlab.net.http.StatusCode.OK
                throw(matlab.databricks.ResponseException(resp,sprintf('Failed to %s SQL warehouse with id "%s"',action,obj.id)));
            end

            % Refresh the object such that it will reflect its new status
            obj.refresh();

        end
    end % private methods

    methods(Static)
        function objs = list(options)
            % LIST Queries Databricks for a list of known SQL warehouses.
            % Returns an array of SQLWarehouse
            
            arguments
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            % Create a SQLWarehouse instance such that we can authenticate
            % and use getURI, etc.
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            obj = databricks.SQLWarehouse(args{:});

            % Configure the URL
            clusterURI = obj.getURI('sql', 'warehouses');
            % Start a GET request
            request = obj.getRequestMessage('GET');

            % Perform the GET request
            resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

            % Check response
            if resp.StatusCode == matlab.net.http.StatusCode.OK
                % Check there are indeed any warehouses
                if isfield(resp.Body.Data,'warehouses')
                    % If so, return them as an array of SQLWarehouse
                    objs = databricks.SQLWarehouse(resp.Body.Data.warehouses);
                else
                    % If no warehouses found return an empty
                    objs = databricks.SQLWarehouse.empty;
                end
            else
                % Request failed
                throw(matlab.databricks.ResponseException(resp, 'Failed to list SQL warehouses'));
            end
        end
    end % static methods

end %class
