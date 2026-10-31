function edit(obj, varargin)
    % EDIT Updates the configuration of a cluster to match the provided attributes
    %
    % A cluster can be updated if it is in a RUNNING or TERMINATED state.
    % If a cluster is updated while in a RUNNING state, it will be restarted so
    % that the new attributes can take effect.
    % If a cluster is updated while in a TERMINATED state, it will remain
    % TERMINATED. The next time it is started using the clusters/start API, the
    % new attributes will take effect. Any attempt to update a cluster in any
    % other state will be rejected with an INVALID_STATE error code.
    % Clusters created by the Databricks Jobs service cannot be edited.
    % 
    % Examples:
    %   
    %   % Change a cluster name
    %   c = databricks.Cluster.findByName('myOldName');
    %   c.edit('cluster_name', 'myNewName');
    %
    %   % Configure an init script on a cluster
    %   c = databricks.Cluster.findById('0707-134216-f5g3rsp8');
    %   installScriptPath = '/Users/username@example.com/MathWorks/1.4.1/runtime/runtime_install_r2023a.sh';
    %   wsi = databricks.datastructures.WorkspaceStorageInfo(installScriptPath);
    %   is = databricks.InitScriptInfo;
    %   is.setDestination(wsi);
    %   c.edit('init_scripts', is);
    %
    %
    % Supported parameters:
    %
    %             num_workers : Number of worker nodes that this cluster should have
    %                           Type: int32
    %
    %               autoscale : Automatically scale clusters up and down based on load
    %                           Type: [min_workers, max_workers], where both values are int32
    %
    %            cluster_name : Cluster name requested by the user
    %                           Type: char or scalar string
    %          
    %           spark_version : The Spark version of the cluster, e.g. 3.3.x-scala2.11
    %                           Type: char or scalar string
    %
    %              spark_conf : An object containing a set of optional, user-specified Spark configuration key-value pairs
    %                           Type: databricks.SparkConfPair
    %
    %            node_type_id : VM sku
    %                           Type: char or scalar string
    %           
    %      driver_node_type_id: VM sku
    %                           Type: char or scalar string
    %       
    %        cluster_log_conf : The configuration for delivering spark logs to a long-term storage destination
    %                           Type: databricks.ClusterLogConf
    %
    %             init_scripts: Array of init script destinations
    %                           Type: databricks.InitScriptInfo
    %     
    % autotermination_minutes : Terminates the cluster after it is inactive, in minutes
    %                           Type: int32
    %
    %     enable_elastic_disk : Autoscaling Local Storage
    %                           Type: logical
    %
    %          cluster_source : Determines how the cluster was created
    %                           Valid values: "UI" "JOB" "API" "SQL" "MODELS" "PIPELINE" "PIPELINE_MAINTENANCE"
    %                           Type: char or scalar string
    %
    %        instance_pool_id : The optional ID of the instance pool to which the cluster belongs
    %                           Type: char or scalar string
    %
    %               policy_id : The ID of the cluster policy used to create the cluster if applicable
    %                           Type: char or scalar string
    %
    % enable_local_disk_encryption : Whether to enable LUKS on cluster VMs' local disks
    %                                Type: logical
    %
    % driver_instance_pool_id : The optional ID of the instance pool for the driver of the cluster belongs
    %                           Type: char or scalar string
    %
    %          runtime_engine : Decides which runtime engine to be use, e.g. Standard vs. Photon
    %                           Type: char or scalar string, valid values: "NULL" "STANDARD" "PHOTON"
    %                                 or databricks.datastructures.DataSecurityMode
    %
    %      data_security_mode : Valid values databricks.datastructures.DataSecurityMode.[NONE | SINGLE_USER
    %                           | USER_ISOLATION | LEGACY_TABLE_ACL | LEGACY_PASSTHROUGH | LEGACY_SINGLE_USER]
    %                           Type: databricks.datastructures.DataSecurityMode
    %
    %        single_user_name : Single user name if data_security_mode is SINGLE_USER
    %                           Type: char or scalar string
    %
    %              cluster_id : Required string, ID of the cluster
    %                           Type: char or scalar string
    %
    %  apply_policy_default_values : This field won't be true for webapp requests
    %                                Only API users will check this field
    %                                Type: logical
    %
    %
    % Currently unsupported parameters:
    %    aws_attributes
    %    ssh_public_keys
    %    custom_tags
    %    workload_type
    %    docker_image
    %
    % An updated databricks.Cluster object is returned.
    %
    % For more information see: https://docs.databricks.com/api/workspace/clusters/edit
    %
    % See Also: databricks.Cluster.create
    %

    % TODO arguments block and JSONMapper conversion, validate enum strings
    
    % Copyright 2023-2026 The MathWorks, Inc.

    validString = @(x) (ischar(x) || isStringScalar(x));
    validAutoscale = @(x) (isa(x, 'int32') &&  isequal(size(x), [1,2]) && x(1) < x(2)) && x(1)>=0 && x(2)>0;
    validSparkEnvVars = @(x) (isa(x, 'containers.Map'));
    validRuntimeEngine = @(x) (ischar(x) || isStringScalar(x) || isa(x, databricks.datastructures.RuntimeEngine));

    caseSensitive = true;
    p = inputParser;
    p.CaseSensitive = caseSensitive;
    p.FunctionName = mfilename;
    p.addParameter('num_workers', 0, @(x) isa(x, 'int32'));
    p.addParameter('autoscale', [int32(4), int32(8)], validAutoscale);
    p.addParameter('cluster_name', '', validString);
    p.addParameter('spark_conf', databricks.SparkConfPair('default', 'default'), @(x) isa(x, 'databricks.SparkConfPair'));
    p.addParameter('spark_version', '', validString);
    p.addParameter('node_type_id', '', validString);
    p.addParameter('driver_node_type_id', '', validString);
    p.addParameter('cluster_log_conf', databricks.ClusterLogConf(), @(x) isa(x, 'databricks.ClusterLogConf'));
    p.addParameter('init_scripts', databricks.InitScriptInfo(), @(x) isa(x, 'databricks.InitScriptInfo'));
    p.addParameter('spark_env_vars', false, validSparkEnvVars);
    p.addParameter('autotermination_minutes', 120, @(x) isa(x, 'int32'));
    p.addParameter('enable_elastic_disk', false, @(x) islogical(x));
    p.addParameter('cluster_source', '', validString);
    p.addParameter('instance_pool_id', '', validString);
    p.addParameter('policy_id', '', validString);
    p.addParameter('enable_local_disk_encryption', false, @(x) islogical(x));
    p.addParameter('driver_instance_pool_id', '', validString);
    p.addParameter('runtime_engine', '', validRuntimeEngine);
    p.addParameter('data_security_mode', databricks.datastructures.DataSecurityMode.empty, @(x) isa(x, 'databricks.datastructures.DataSecurityMode'));
    p.addParameter('single_user_name', '', validString);
    p.addParameter('apply_policy_default_values', false, @(x) islogical(x));
    p.parse(varargin{:});
    
    % s is the struct that becomes the body of the edit message when encoded to JSON
    s = struct;
    % Build a struct args to hold all the values that have been set via parameters from which to build up s
    args = struct;
    for n = 1:numel(p.Parameters)
        if ~contains(p.UsingDefaults, p.Parameters{n},'IgnoreCase', ~caseSensitive)
            args.(p.Parameters{n}) = p.Results.(p.Parameters{n});
        end
    end

    % REQUIRED Use the existing cluster_id, this can't be changes, if it does not exist there is a problem
    if isprop(obj, 'cluster_id')
        s.cluster_id = obj.cluster_id; % Required field
    else
        error('DATABRICKS:ERROR:CLUSTEREDITID','Cluster cluster_id property is not defined');
    end


    % REQUIRED num_workers or autoscale must be set
    % Try num_workers arg, autoscale arg, existing num_workers, existing autoscale in that order
    if isfield(args,'num_workers')
        s.num_workers = args.num_workers;
    elseif isfield(args,'autoscale')
        s.autoscale.min_workers = args.autoscale.min_workers;
        s.autoscale.max_workers = args.autoscale.max_workers;
        if isfield(args.autoscale, 'target_workers')
            s.autoscale.target_workers = args.autoscale.target_workers;
        end
    elseif isprop(obj, 'num_workers')
        s.num_workers = obj.num_workers;
    elseif isprop(obj, 'autoscale')
        s.autoscale.min_workers = obj.autoscale.min_workers;
        s.autoscale.max_workers = obj.autoscale.max_workers;
        if isfield(obj.autoscale, 'target_workers')
            s.autoscale.target_workers = obj.autoscale.target_workers;
        end
    else
        error('DATABRICKS:ERROR','num_workers or autoscale must be defined');
    end

    % cluster_name
    % While not documented as required if this is not set the original
    % cluster name will be lost.
    if isfield(args,'cluster_name')
        s.cluster_name = args.cluster_name;
    else
        if isprop(obj, 'cluster_name')
            s.cluster_name = obj.cluster_name;
        else
            error('DATABRICKS:ERROR:CLUSTEREDITNAME','Cluster cluster_name property is not defined');
        end
    end

    % REQUIRED spark_version
    if isfield(args,'spark_version')
        s.spark_version = args.spark_version;
    elseif isprop(obj, 'spark_version')
        s.spark_version = obj.spark_version;
    else
        error('DATABRICKS:ERROR','spark_version must be defined');
    end

    % spark_conf
    if isfield(args,'spark_conf')
        argKeys = keys(args.spark_conf.pairs);
        for n = 1:length(argKeys)
            keyName = argKeys{n};
            validKeyName = matlab.lang.makeValidName(keyName);
            s.spark_conf.(validKeyName) = args.spark_conf.pairs(keyName);
            if ~strcmp(validKeyName, keyName)
                if ~strcmp('spark.databricks.isv.product', keyName)
                    warning('DATABRICKS:EDIT:SPARK_CONF', 'Renaming: %s to: %s\n', keyName, validKeyName);
                end
            end
        end
    end

    % REQUIRED node_type_id
    % TODO APIS seems to require this though docs say it is not required...
    if isfield(args,'node_type_id')
        s.node_type_id = args.node_type_id;
    elseif isprop(obj, 'node_type_id')
        s.node_type_id = obj.node_type_id;
    else
        % Expected to be defined
        error('DATABRICKS:ERROR','node_type_id must be defined');
    end

    % driver_node_type_id
    if isfield(args,'driver_node_type_id')
        s.driver_node_type_id = args.driver_node_type_id;
    end

    % init_scripts
    if isfield(args,'init_scripts')
       s.init_scripts = args.init_scripts;
    end

    % cluster_log_conf
    if isfield(args, 'cluster_log_conf')
        if isprop(args.cluster_log_conf, 'dbfs')
            s.cluster_log_conf.dbfs.destination = args.cluster_log_conf.dbfs.destination;
        else
            error('DATABRICKS:ERROR','cluster_log_conf destintion type not supported');
        end
    end

    % spark_env_vars
    if isfield(args,'spark_env_vars')
        argKeys = keys(args.spark_env_vars);
        for n = 1:length(argKeys)
            keyName = argKeys{n};
            validKeyName = matlab.lang.makeValidName(keyName);
            s.spark_env_vars.(validKeyName) = args.spark_env_vars(keyName);
            if ~strcmp(validKeyName, keyName)
                warning('DATABRICKS:EDIT:SPARK_CONF', 'Renaming: %s to: %s\n', keyName, validKeyName);
            end
        end
    end

    % autotermination_minutes 
    if isfield(args,'autotermination_minutes')
        s.autotermination_minutes = args.autotermination_minutes;
    end

    % enable_elastic_disk 
    if isfield(args,'enable_elastic_disk')
        s.enable_elastic_disk = args.enable_elastic_disk;
    end

    % cluster_source
    if isfield(args,'cluster_source')
        e = ["UI" "JOB" "API" "SQL" "MODELS" "PIPELINE" "PIPELINE_MAINTENANCE"];
        if ~any(matches(e, args.cluster_source))
            warning('DATABRICKS:EDIT','Unexpected value for cluster_source: %s', args.cluster_source);
        end
        s.cluster_source = args.cluster_source;
    end

    % instance_pool_id
    if isfield(args,'instance_pool_id')
        s.instance_pool_id = args.instance_pool_id;
    end

    % policy_id
    if isfield(args,'policy_id')
        s.policy_id = args.policy_id;
    end

    % enable_local_disk_encryption
    if isfield(args,'enable_local_disk_encryption')
        s.enable_local_disk_encryption = args.enable_local_disk_encryption;
    end
    
    % driver_instance_pool_id
    if isfield(args,'driver_instance_pool_id')
        s.driver_instance_pool_id = args.driver_instance_pool_id;
    end

    % runtime_engine
    if isfield(args,'runtime_engine')
        e = ["NULL" "STANDARD" "PHOTON"];
        if ~any(matches(e, args.runtime_engine))
            warning('DATABRICKS:EDIT','Unexpected value for runtime_engine: %s', args.runtime_engine);
        end
        s.runtime_engine = args.runtime_engine;
    end

    % data_security_mode
    if isfield(args,'data_security_mode')
        if isa(args.data_security_mode, 'databricks.datastructures.DataSecurityMode')
            s.data_security_mode = string(args.data_security_mode);
        else
            e = ["NONE" "SINGLE_USER" "USER_ISOLATION" "LEGACY_TABLE_ACL" "LEGACY_PASSTHROUGH" "LEGACY_SINGLE_USER"];
            if ~any(matches(e, args.data_security_mode))
                warning('DATABRICKS:EDIT','Unexpected value for data_security_mode: %s', args.data_security_mode);
            end
            s.data_security_mode = args.data_security_mode;
        end
    end

    % single_user_name
    if isfield(args,'single_user_name')
        if ~(strcmp(args.data_security_mode, 'SINGLE_USER') || strcmp(obj.data_security_mode, 'SINGLE_USER'))
            warning('DATABRICKS:EDIT','Setting single_user_name is only supported when data_security_mode equals "SINGLE_USER"');
        end
        s.single_user_name = args.single_user_name;
    end

    % apply_policy_default_values
    if isfield(args,'apply_policy_default_values')
        s.apply_policy_default_values = args.apply_policy_default_values;
    end

    % Make the request
    % Tweak the JSON
    jsonStr = jsonencode(s, PrettyPrint=true);
    jsonStr = strrep(jsonStr, '"spark_databricks_isv_product"', '"spark.databricks.isv.product"');


    % Get URI
    URI = obj.getURI('clusters', 'edit');
    % Start a POST request
    request = obj.getRequestMessage('POST');
    % Assign the body data
    request.Body = matlab.net.http.MessageBody(jsonStr);

    % Perform the actual call
    [resp, request, history] = request.send(URI, databricks.internal.getHTTPOptions(convertResponse=true)); %#ok<ASGLU> 

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % no result is returned
    elseif resp.StatusCode == matlab.net.http.StatusCode.BadRequest
        error('DATABRICKS:ERROR','Request is invalid\n  error_code: %s\n  message: %s', resp.Body.Data.error_code, resp.Body.Data.message);
    elseif resp.StatusCode == matlab.net.http.StatusCode.Unauthorized
        error('DATABRICKS:ERROR','The request does not have valid authentication credentials for the operation');
    elseif resp.StatusCode == matlab.net.http.StatusCode.Forbidden
        error('DATABRICKS:ERROR','Caller does not have permission to execute the specified operation');
    elseif resp.StatusCode == matlab.net.http.StatusCode.NotFound
        error('DATABRICKS:ERROR','Operation was performed on a resource that does not exist');
    elseif resp.StatusCode == matlab.net.http.StatusCode.InternalServerError
        error('DATABRICKS:ERROR','Internal error');
    else
        error('DATABRICKS:ERROR','Unexpected error: %s', char(resp));
    end
end
