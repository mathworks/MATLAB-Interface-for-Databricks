classdef Cluster < databricks.Object
    % CLUSTER Databricks Cluster API
    % The Clusters API allows you to create, start, edit, list, terminate, and
    % delete clusters. The maximum allowed size of a request to the Clusters
    % API is 10MB.
    %
    % Cluster life-cycle methods require a cluster ID, which is returned from
    % Create. To obtain a list of clusters, invoke List.
    %
    % Databricks maps cluster node instance types to compute units known as
    % DBUs. See the Databricks instance type pricing page for a list of the
    % supported instance types and their corresponding DBUs.
    %
    %   cl = databricks.Cluster;
    %
    % Will use the standard configuration file for initialization.
    % Alternatively, to specify host and token:
    %
    %   cl = databricks.Cluster('Host','https://databrickshost.abc.com', 'Token', 'abc123');
    %
    % Or, with a specific authentication method and or profile name:
    %
    %   cl = databricks.Cluster('authMethod', matlab.databricks.AuthMethod.PAT, 'profileName', 'DEV');

    % Copyright (c) 2019-2025 MathWorks, Inc.

    properties
        cluster_name = '';
        node_type_id = '';
        spark_version = '';
    end
    
    properties (SetAccess=private)
        spark_conf;
    end
    
    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        % Constructor
        function obj = Cluster(options)
            % databricks.Cluster
            %
            %  Create cluster object using default configuration file.
            %   obj = databricks.Cluster()
            %
            %  Create cluster object using named values.
            %   obj = databricks.Cluster('Host', 'https://databrickshost.abc.com', 'Token', '123abc')
            
            arguments
                % Backward compatibility, arguments
                % Does not support Basic auth mode or account-level REST API
                options.Host string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.Token string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.Org_id string {mustBeTextScalar}
                % Profile based auth
                options.authMethod matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.cfgFile string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = false
                options.spark_version (1,1) string 
            end

            args = matlab.utils.addArgs(struct(options), ...
                ["Host", "Token", "Org_id", "authMethod", "profileName", "cfgFile", "verbose"]);

            obj.getAuth(args{:});

            % Check settings exists and extract the values
            % Set cloud specific properties

            settings = databricks.internal.settings.Settings.getSettingsStruct();

            % Node-type
            % Vendor is checked in Object.getSettings()
            if isfield(settings.(settings.vendor), 'node_type_id')
                obj.node_type_id = settings.(settings.vendor).node_type_id;
            else
                if strcmpi(settings.vendor, 'aws')
                    warning('DATABRICKS:CLUSTER', 'node_type_id value not defined in databricks-settings.json, defaulting to: i3.xlarge');
                    obj.node_type_id = "i3.xlarge";
                elseif strcmpi(settings.vendor, 'azure')
                    warning('DATABRICKS:CLUSTER', 'node_type_id value not defined in databricks-settings.json, defaulting to: Standard_D4ds_v5');
                    obj.node_type_id = "Standard_D4ds_v5";
                else
                    error('DATABRICKS:CLUSTER', 'Unexpected vendor value: %s', settings.vendor);
                end
            end

            % Spark Version
            if isfield(options, 'spark_version')
                spark_version = options.spark_version;
            else
                args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                spark_version = databricks.internal.cluster.getDefaultSparkVersion(args{:}, 'ML', false, 'GPU', false, 'photon', false);
            end
            if strlength(spark_version) > 0
                obj.spark_version = spark_version;
            else
                warning('DATABRICKS:CLUSTER', 'Unable to automatically determine a spark_version value, property not set');
            end

            % Autotermination
            if isfield(settings, 'autotermination_minutes')
                obj.setAutoterminationMinutes(settings.autotermination_minutes);
            else
                % Not set default to 0
                warning('DATABRICKS:CLUSTER', 'autotermination_minutes value not defined in databricks-settings.json, defaulting to: 120');
                obj.setAutoterminationMinutes(120);
            end

            % Policy ID
            if isfield(settings, 'policy_id')
                obj.setPolicyId(settings.policy_id);
            end

            % Set the ISV strings for telemetry
            scp = databricks.SparkConfPair('spark.databricks.isv.product',char(databricks.Object.getUserAgent()));
            obj.setSparkConf(scp);

            % This variable is set to comply with how Databricks creates
            % clusters in their Workspace.
            pythonEnvVar = databricks.SparkEnvPair('PYSPARK_PYTHON', '/databricks/python3/bin/python3');
            obj.setSparkEnvVars(pythonEnvVar);

            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
        end
    end


    methods(Hidden)
        function version = getClusterVersionSemVer(obj)
            % GETCLUSTERVERSIONSEMVER Get the runtime version of the cluster as a semantic version
            % If the version cannot be determined an empty SemVer is returned.
            arguments (Input)
                obj databricks.Cluster
            end
            arguments (Output)
                version matlab.utils.SemVer
            end

            if ~isempty(obj) && isprop(obj, "spark_version") && ~isempty(obj.spark_version) && strlength(obj.spark_version) > 0
                version = matlab.utils.SemVer(getClusterVersionString(obj));
            else
                version = matlab.utils.SemVer.empty;
            end
        end

        function version = getClusterVersionString(obj)
            % GETCLUSTERRUNTIMEVERSION Returns the numeric form of a cluster runtime e.g. 16.4
            % Errors if the cluster is empty.
            % Errors if the cluster spark_version property is missing or not set.
            arguments (Input)
                obj databricks.Cluster
            end
            arguments (Output)
                version string
            end
            
            if ~isempty(obj) && isprop(obj, "spark_version") && ~isempty(obj.spark_version) && strlength(obj.spark_version) > 0
                % Go from "16.4.x-scala2.12" to "16.4"
                version = string(strip(extractBefore(obj.spark_version, lettersPattern), "right", "."));
            else
                version = string.empty;
            end
        end
    end

    methods(Static)
        % Static Methods
        clusters = list(options);
        cluster = findByName(name, options);
        cluster = findById(id, options);
        sparkVersions = getSparkVersions(options)
        nodeList = getNodeTypes(options)
    end
end %class
