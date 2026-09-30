function cluster = MATLABEnableExistingCluster(existingCluster, options)
    % MATLABENABLEEXISTINGCLUSTER Updates the configuration of a cluster to support MATLAB
    %
    % This method uses the databricks.Cluster.edit method to update aspects of
    % a cluster's configuration. Calls to edit can *restart* a cluster potentially
    % disrupting service for other users, see the Databricks documentation linked
    % below for further details
    %
    % The updates enable the cluster to run deployed MATLAB workloads similarly
    % to if the cluster was create using the createDatabricksCluster function.
    %
    % Supported parameters:
    %
    %   existingCluster : An existing databricks.Cluster object use Cluster.findById
    %                     or Cluster.findByName to get a cluster object if required.
    %                     This is a required value.
    %                     
    %    initscriptPath : An optional name-value parameter to set a non default
    %                     init script path.
    %
    %     enableLogging : Set to true to turn on logging of the init scripts
    %                     including the runtime install. Default is false.
    %
    %            logDir : An optional name-value parameter to set log file destination.
    %                     The default value is: "dbfs:/cluster_logs"
    %                     If using /Volumes (Public Preview) additional restrictions apply.
    %                     See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
    %
    %
    %      cluster_name : An optional name-value parameter to set the new name for the
    %                     cluster, the cluster's ID remains the same.
    %
    %        authMethod : A matlab.databricks.AuthMethod
    %
    %       profileName : A configuration file profileName value
    % 
    % An updated databricks.Cluster object is returned.
    %
    % For more information see: https://docs.databricks.com/api/workspace/clusters/edit
    %
    % This function does not currently support enabling an existing cluster to use Docker.
    % Only init scripts are supported.
    %
    % Example:
    %   existingCluster = databricks.Cluster.findById("0708-093802-38njgrhw"); % Or use findByName()
    %   updatedCluster = matlab.databricks.cluster.MATLABEnableExistingCluster(existingCluster);
    % 
    % See Also: databricks.Cluster.create
    
    % Copyright 2023-2025 The MathWorks, Inc.

    arguments
        existingCluster (1,1) databricks.Cluster

        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscriptPath string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.enableLogging (1,1) logical = false
        options.logDir (1,1) string =  "dbfs:/cluster_logs"
        options.cluster_name (1,1) string
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if isprop(existingCluster, 'cluster_source') && strcmp(existingCluster.cluster_source, 'JOB')
        error('DATABRICKS:ENABLEEXISTINGCLUSTER','Clusters created by the Databricks Jobs service cannot be edited');
    end

    if isprop(existingCluster, 'num_workers') && existingCluster.num_workers == 0 && ...
        ((isprop(existingCluster, 'data_security_mode') && existingCluster.data_security_mode == "USER_ISOLATION") || ...
        options.accessMode == "USER_ISOLATION")
        error("DATABRICKS:CREATEDATABRICKSCLUSTER", "Shared Access Mode/USER_ISOLATION cannot be used with single node mode.");
    end

    if isprop(existingCluster, 'data_security_mode') && strcmp(existingCluster.data_security_mode, "USER_ISOLATION")
        fprintf(2, "\nShared clusters currently do not propagate environment variables to worker nodes.\n");
        fprintf(2, "Thus preventing the MATLAB Runtime from functioning.\n");
        fprintf(2, "This issue is currently under investigation.\n\n");
    end

    editArguments = {};
    if isfield(options, 'cluster_name')
        editArguments{end+1} = 'cluster_name';
        editArguments{end+1} = options.cluster_name;
    elseif isprop(existingCluster, 'cluster_name')
        editArguments{end+1} = 'cluster_name';
        editArguments{end+1} =  existingCluster.cluster_name;
    else
        error('DATABRICKS:ENABLEEXISTINGCLUSTER','cluster_name not defined');
    end

    % %%%%%%%%%%%%%%%%%%%%%%%%%%
    % % initscript
    % %%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(options, "initscriptPath")
        initscriptPath = options.initscriptPath;
    else
        if isfield(options, "interfaceDirectory")
            interfaceDirectory = options.interfaceDirectory;
        else
            interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
        end
        initscriptPath = interfaceDirectory + "/runtimes/runtime_install.sh";
    end


    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});
    is = databricks.InitScriptInfo;
    if io.isfile(initscriptPath)
        is.setDestination(initscriptPath); % /Volumes path
    else
        error("DATABRICKS:ENABLEEXISTINGCLUSTER", "Init script not found: %s", initscriptPath);
    end


    if isprop(existingCluster, 'data_security_mode') && ...
       strcmp(existingCluster.data_security_mode, "NONE") && ...
       databricks.internal.io.IO.getType(initscriptPath) == databricks.internal.FileSystemType.VOLUMES
        error("DATABRICKS:ENABLEEXISTINGCLUSTER", "Init scripts that use Unity Catalog Volumes are only supported on Unity Catalog Shared or Assigned access mode clusters.");
    end

    if isprop(existingCluster, 'init_scripts')
        % Get any existing init scripts on the existing cluster
        initScriptInfo = existingCluster.init_scripts;
        if iscell(initScriptInfo)
            initScriptInfo{end+1} = is;
        else
            initScriptInfo(end+1) = is;
        end
    else
        initScriptInfo = is;
    end

    editArguments{end+1} = 'init_scripts';
    editArguments{end+1} = initScriptInfo;


    % %%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Configure spark_env_vars
    % %%%%%%%%%%%%%%%%%%%%%%%%%%
    if isprop(existingCluster, 'spark_env_vars')
        if isa(existingCluster.spark_env_vars, 'containers.Map')
            existingSparkEnvVars = existingCluster.spark_env_vars;
        elseif isstruct(existingCluster.spark_env_vars)
            existingSparkEnvVars = sevStruct2CM(existingCluster.spark_env_vars);
        else
            error("DATABRICKS:ENABLEEXISTINGCLUSTER", "Expected spark_env_vars as a struct or containers.map, found: %s", class(existingCluster.spark_env_vars));
        end
    else
        existingSparkEnvVars = containers.Map();
        % Unexpected and probably an indication of a problem with the cluster configuration
        warning('DATABRICKS:ENABLEEXISTINGCLUSTER','Cluster does not have an existing spark_env_vars property');
    end
    % merge maps overwriting those coming from the cluster
    newVars = existingSparkEnvVars;
    MCRROOT = '/MATLAB_Runtime';
    LD_LIBRARY_PATH = [...
        MCRROOT,'/runtime/glnxa64:',...
        MCRROOT,'/bin/glnxa64:',...
        MCRROOT,'/sys/os/glnxa64:',...
        MCRROOT,'/extern/bin/glnxa64:', ...
        MCRROOT,'/sys/opengl/lib/glnxa64' ...
        ];

    varCell = {"LD_LIBRARY_PATH",LD_LIBRARY_PATH;...
              "MW_CONNECTOR_CONNECTION_PROFILES","noop";...
              "PYSPARK_PYTHON", "/databricks/python3/bin/python3"};

    requiredEnvVars = databricks.SparkEnvPair(varCell);
    requiredKeys = keys(requiredEnvVars.envVarPairs);
    for n = 1:length(requiredKeys)
        newVars(requiredKeys{n}) = requiredEnvVars.envVarPairs(requiredKeys{n});
    end
    editArguments{end+1} = 'spark_env_vars';
    editArguments{end+1} = newVars;

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Configure cluster_log_conf
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isprop(existingCluster, 'cluster_log_conf')
        if isfield(options, 'logDir')
            conf = databricks.ClusterLogConf;
            conf.setDestination(char(options.logDir));
            editArguments{end+1} = 'cluster_log_conf';
            editArguments{end+1} = conf;
        end
    end

    scp = databricks.SparkConfPair('spark.databricks.isv.product', char(databricks.Object.getUserAgent()));
    editArguments{end+1} = 'spark_conf';
    editArguments{end+1} = scp;

    % Make cluster changes
    existingCluster.edit(editArguments{:});
    % Wait here until the cluster has been partially created.
    pause(5); % TODO add a status check

    % Add libraries to the cluster
    args = matlab.utils.addArgs(options, ["interfaceDirectory", "authMethod", "profileName"]);
    addLibraries(existingCluster, release, args{:});

    % Get updated meta data to return to the user
    existingCluster.refresh;
    cluster = existingCluster;
end


function sevCM = sevStruct2CM(sevStruct)
    arguments
        sevStruct (1,1) struct
    end

    structFieldsCell = cell(fieldnames(sevStruct));
    structValsCell = {};
    for n = 1:numel(structFieldsCell)
        structValsCell{end+1} = sevStruct.(structFieldsCell{n}); %#ok<AGROW>
    end

    sevCM = containers.Map(structFieldsCell, structValsCell);
end


function addLibraries(cluster, release, options)
    arguments
        cluster (1,1) databricks.Cluster
        release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Add Javabuilder
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    JB = databricks.Library(args{:});
    JB.setType('jar');
    javabuilderPath = databricks.internal.mlRuntime.getLatestJavabuilder(interfaceDirectory, release, args{:});
    JB.jar = javabuilderPath;
    verbose = false;
    JB.install(cluster.cluster_id, verbose);
end

