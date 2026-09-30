function cl = createDatabricksCluster(name, numWorkers, options)
    % CREATEDATABRICKSCLUSTER Helper function to create a cluster
    %
    % This function is an easy way to create a cluster in a Databricks
    % subscription. It relies on the databricks.Cluster class, and its
    % methods and helper functions. It's an easy way to create a cluster,
    % and it offers a few options. If there's a need for more fine grained
    % control of the cluster creation options, please use the underlying
    % class and its APIs directly.
    %
    % Arguments:
    %             name : The name of the cluster.
    %
    %       numWorkers : The number of workers in the cluster. This can be a
    %                    single number or an array of lower and upper bound,
    %                    e.g. for a cluster between 2 and 10 workers the value
    %                    should be [2, 10]. If 0 is used then a single node cluster
    %                    will be created, as distinct from a cluster of size 1.
    %
    %        useMATLAB : Optional argument to install MATLAB runtime on the
    %                    cluster. Default is true. If a Docker Image URL is
    %                    provided this option is ignored.
    %
    %           create : Optional argument to set to true if the cluster should
    %                    be created immediately. If set to false, the function
    %                    will only return an object that can be used for
    %                    creating a cluster. This is useful for creating Spark
    %                    jobs. Default is true.
    %
    %   dockerAuthFile : The name of a file containing docker information,
    %                    image URL, user name, and password. This can be
    %                    used to easily use docker settings when creating a
    %                    cluster. The filename can be an absolute path or
    %                    relative path. Currently, only no password or
    %                    basic_auth is supported.
    %                    The "spark_version" field is optional, but is
    %                    helpful for determining spark_version. It's
    %                    required if the image tag doesn't reflect the
    %                    Databricks runtime version.
    %
    %                     {
    %                       "url": "some.repo.com/matlab/databricks/desktop:r2025a-dbx15.4",
    %                       "basic_auth": {
    %                         "username": "b304<REDACTED>40",
    %                         "password": "ol_8<REDACTED>qr"
    %                       },
    %                       "spark_version": "15.4.x-scala2.12"
    %                     }
    %
    %                    If the repository doesn't need authentication, the
    %                    file may consist of only the url.
    %                    The file path may be a local or remote path e.g.
    %                    Workspace or Volumes.
    %
    %        dockerURL : Optional argument to specify the URL of a Docker Image.
    %                    When using Docker the spark conf spark.databricks.unityCatalog.volumes.enabled
    %                    property will be set to "true".
    %
    %   dockerUsername : Optional argument to specify the container registry username.
    %
    %   dockerPassword : Optional argument to specify the container registry password.
    %
    % instanceProfileARN : Optional argument to specify an instance profile ARN.
    %                    This is a feature that only has effect on AWS
    %                    clusters. It can be used to provide access to the
    %                    docker repository used for the image.
    %
    %     sparkVersion : Set this to set a given spark_version otherwise
    %                    a version based on the current default Databricks Runtime
    %                    will be used. This value is the Databricks Cluster API
    %                    spark_version field and is not strictly the version of Spark
    %                    used. It has the form: 17.3.x-scala2.13. The specific value
    %                    for a given Databricks runtime can be verified in the
    %                    Databricks UI.
    %
    %       nodeTypeId : Set this to pick a different node type than what
    %                    is set in the users default settings.
    %
    %   initScriptPath : Specify a non default init script path.
    %                    If not specified and the default script is not present
    %                    the local script will be uploaded to the user's workspace.
    %                    % By default the init script is stored in:
    %                    <settings: interfaceDirectory>/runtimes/runtime_install.sh
    %
    % interfaceDirectory : /Volumes path under which MathWorks files can be stored.
    %
    %          release : MATLAB release of the form R2024b for the runtime to install.
    %                    By default the release of MATLAB in use is used.
    %
    %      runtimePath : Specify a path to to a MATLAB runtime .zip file.
    %                    /Volumes, DBFS and http paths are supported.
    %
    %       policyName : Set the name of the cluster policy used to create the cluster.
    %
    %         policyId : Set the ID of the cluster policy used to create the cluster.
    %
    %               ML : Selects a Databricks Runtime version with ML functionality
    %                    enabled.
    %
    %              GPU : Selects a Databricks Runtime version with GPU functionality
    %                    enabled.
    %
    %           photon : Selects a Databricks Runtime version with Photon functionality
    %                    enabled.
    %
    %       accessMode : Data security mode decides what data governance model to
    %                    use when accessing data from a cluster.
    %                    Default: databricks.datastructures.DataSecurityMode.SINGLE_USER
    %
    %      sparkConfig : Additional Spark Conf pair settings to apply to a cluster
    %                    e.g. databricks.SparkConfPair({'mykey', 'myvalue'})
    %
    %     sparkEnvPair : Additional environment variable(s) to apply to a cluster
    %                    e.g. databricks.SparkEnvPair('MyVariable','MyValue')
    %                    To set multiple values:
    %                    databricks.SparkEnvPair({'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'})
    %
    %       clusterTag : Additional ClusterTags to apply to a cluster
    %                    e.g. databricks.ClusterTag('myKey', 'myValue');
    %
    % autoterminationMinutes : Specifies the number of minutes of idle time after
    %                          which the cluster will be stopped.
    %
    %   instancePoolId : The optional ID of the instance pool to which the cluster belongs.
    %
    %       authMethod : A matlab.databricks.AuthMethod.
    %
    %      profileName : A configuration file profileName value.
    %
    %    enableLogging : Enables logging of the initscript and other steps.
    %                    The default is false.
    %
    %           logDir : The location to which logs are written, the default is:
    %                    dbfs:/cluster-logs
    %                    If using /Volumes (Public Preview) additional restrictions
    %                    apply. See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
    %
    %  updateClusterId : Update the cluster Id value stored in the default
    %                    or specified cluster. The default is false.
    %                    If the create argument is false the updateClusterId argument
    %                    is ignored.
    %
    %   waitForCluster : Waits for the cluster to reach a RUNNING state before returning.
    %                    The default is false.
    %                    A timeout of 12 minutes is applied.
    %
    %          verbose : Enable additional feedback. Default is true.
    %
    % Examples:
    % Create a cluster with 4 workers that installs the MATLAB runtime
    %   cl = createDatabricksCluster('my-cluster', 4);
    %
    % Create a cluster without a MATLAB runtime installed. This cluster
    % can still be used for interactively handling a Databricks session
    % from within MATLAB, but no compiled MATLAB code can run on the
    % cluster.
    %   cl = createDatabricksCluster('plain-cluster', 4, useMATLAB = false);
    %
    % Unity Catalog requires that an access mode mode is specified and set to
    % SINGLE_USER or USER_ISOLATION. Be default clusters are created with using
    % SINGLE_USER. The accessMode is set using an enumeration of type:
    % databricks.datastructures.DataSecurityMode.
    %
    % Details of the other modes can be found in the databricks.datastructures.DataSecurityMode
    % help.
    %
    % Create a USER_ISOLATION (Shared) cluster using an init script stored in
    % Azure Data Lake Storage (ABFSS). This requires a Databricks runtime version
    % 13.3 or greater.
    %
    % Add an ABFSS scope
    %   scope.scope = 'ABFSS_Scope';
    %   scope.initial_manage_principal = 'users';
    %   scope.create
    %
    % Read in the sensitive value
    %   s = jsondecode(fileread("abfsskey.json"));
    %
    % Create a secret in the scope using the secret
    %   secret = databricks.Secret;
    %   secret.scope = 'ABFSS_Scope';
    %   secret.key = 'ABFSS_Key';
    %   secret.setValue(s.abfsskey);
    %   secret.put
    %
    % The Scope and Secret are persistent and do not need to be recreated unless deleted.
    %
    % Create a Spark Conf Pair that uses the secret
    %   scps = databricks.SparkConfPair({'spark.hadoop.fs.azure.account.key.mystorageaccount.dfs.core.windows.net', '{{secrets/ABFSS_Scope/ABFSS_Key}}'});
    %
    % Add a custom init script to the allow list - requires administrative privileges
    %   matlab.databricks.unitycatalog.addArtifactAllowlistItem('INIT_SCRIPT', "abfss://mycontainer@mystorageaccount.dfs.core.windows.net/package_version/runtime_install.sh");
    %
    % Create the cluster
    %   c = createDatabricksCluster("myCluster", 1, sparkConfig=scps, initScriptPath=initScriptPath, sparkVersion="17.3.x-scala2.13");

    % Copyright 2021-2026 The MathWorks, Inc.

    arguments
        name (1,1) string
        numWorkers (1,:) {mustBeNumeric,mustBeInteger,mustBeNonnegative,mustBeReal,validateNumWorkers} = 4
        options.useMATLAB (1,1) logical = true
        options.create (1,1) logical = true

        options.dockerAuthFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.dockerURL string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.dockerUsername string {mustBeTextScalar}
        options.dockerPassword string {mustBeTextScalar}
        options.instanceProfileARN (1,1) string  {mustBeTextScalar, mustBeNonzeroLengthText} % AWS specific

        options.javabuilderLoc string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.sparkVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.nodeTypeId string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.initScriptPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.runtimePath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.policyName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.policyId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.ML (1,1) logical = false
        options.GPU (1,1) logical = false
        options.photon (1,1) logical = false
        options.accessMode (1,1) databricks.datastructures.DataSecurityMode = databricks.datastructures.DataSecurityMode.SINGLE_USER
        options.sparkConfig databricks.SparkConfPair
        options.sparkEnvPair databricks.SparkEnvPair
        options.clusterTag databricks.ClusterTag
        options.autoterminationMinutes int32 {mustBeNonnegative}
        options.instancePoolId string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

        options.enableLogging (1,1) logical = false
        % /Volume based logging is recommended for improved security
        options.logDir string {mustBeTextScalar, mustBeNonzeroLengthText} = "dbfs:/cluster-logs"
        % Update the cluster_id field in the .databrickscfg file
        options.updateClusterId (1,1) logical = false;
        % Wait for the cluster to reach a running state
        options.waitForCluster (1,1) logical = false;
        options.verbose (1,1) logical = true
    end

    % The actual spark version is set later
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"], {"spark_version", "interim_invalid_spark_version"});
    cl = databricks.Cluster(args{:});
    cl.cluster_name = name;

    % Default useMATLAB to true without setting it in options
    if isfield(options, "useMATLAB")
        useMATLAB = options.useMATLAB;
    else
        useMATLAB = true;
    end

    if ~options.create && options.updateClusterId
        fprintf(2, "When a cluster creation is disabled the updateClusterId argument is ignored.\n");
    end
    
    if isfield(options, "policyName") || isfield(options, "policyId")
        cl = configurePolicy(cl, options);
        if options.create
            cl.create();
            args = matlab.utils.addArgs(options, ["updateClusterId", "verbose", "profileName"]);
            updateClusterIdHandler(cl, args{:});
            waitForClusterToStartHandler(cl, options);
        end
        return;
    end

    if isfield(options, "accessMode")
        cl = configureAccessMode(cl, options);
    end

    if isfield(options, "sparkConfig")
        cl.setSparkConf(options.sparkConfig);
    end

    if isfield(options, "sparkEnvPair")
        cl.setSparkEnvVars(options.sparkEnvPair);
    end

    % setSingleNode below will set a tag also
    if isfield(options, "clusterTag")
        cl.setCustomTags(options.clusterTag);
    end

    if isfield(options, "autoterminationMinutes")
        cl.setAutoterminationMinutes(options.autoterminationMinutes);
    end

    if isfield(options, "instancePoolId")
        cl.setInstancePoolId(options.instancePoolId);
        % cl.getpayload will remove the node type id property as is
        % required.
    else
        if isfield(options, "nodeTypeId")
            cl.node_type_id = options.nodeTypeId;
        end
    end

    if isscalar(numWorkers) && numWorkers == 0
        % Create single node
        cl.setSingleNode();
    else
        cl.setNumWorkers(numWorkers);
    end

    if options.enableLogging
        cl = configureLogging(cl, options.logDir);
    end

    % Caveat
    if isscalar(numWorkers)
        if numWorkers == 0 && options.accessMode == "USER_ISOLATION"
            error("DATABRICKS:CREATEDATABRICKSCLUSTER", ...
                "Shared Access Mode cannot be used with single node mode.");
        end
    end

    % Do enableMATLABRuntime or configureDocker or neither but not both
    if isfield(options, 'dockerURL') || isfield(options, 'dockerAuthFile')
        if isfield(options, "useMATLAB") && options.useMATLAB
            fprintf(2, "When a dockerURL is provided, if a MATLAB runtime is required it should be included in the image, the useMATLAB argument is ignored.\n");
        end
        cl = configureDockerAndSparkVersion(cl, options);
        if options.create
            cl.create();
            args = matlab.utils.addArgs(options, ["updateClusterId", "verbose", "profileName"]);
            updateClusterIdHandler(cl, args{:});
            waitForClusterToStartHandler(cl, options);
        end
    else
        % If the sparkVersion options string is set just use that
        if isfield(options, "sparkVersion")
            cl.spark_version = options.sparkVersion;
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            cl.spark_version = databricks.internal.cluster.getDefaultSparkVersion(args{:}, 'ML', options.ML, 'GPU', options.GPU, 'photon', options.photon);
        end
        if useMATLAB
            % Caveat
            if options.accessMode == "USER_ISOLATION"
                fprintf(2, "\nShared clusters currently do not propagate environment variables to worker nodes.\n");
                fprintf(2, "Thus preventing the MATLAB Runtime from functioning.\n");
                fprintf(2, "This issue is currently under investigation.\n\n");
            end

            if cl.getClusterVersionSemVer().ge(17)
                error("DATABRICKS:CREATEDATABRICKSCLUSTER:INIT17",...
                    "The MATLAB runtime init script is not supported on cluster runtimes 17.0 and later.\nUse Databricks Container Services (Docker) instead.");
            end

            args = matlab.utils.addArgs(options, ["interfaceDirectory", "initScriptPath", "release", "runtimePath", "authMethod", "profileName"]);
            cl.enableMATLABRuntime(args{:});
            if options.create
                cl = nonDockerMATLABCfgCreate(cl, options);
                args = matlab.utils.addArgs(options, ["updateClusterId", "verbose", "profileName"]);
                updateClusterIdHandler(cl, args{:});
                waitForClusterToStartHandler(cl, options);
            end
        else
            % Could be a non MATLAB related init script so check it is supported and allowed
            if isfield(options, "initscriptPath")
                % Set the init script property
                is = databricks.InitScriptInfo;
                is.setDestination(options.initscriptPath);
                cl.setInitScriptInfo(is);
            end
            if options.create
                cl.create();
                args = matlab.utils.addArgs(options, ["updateClusterId", "verbose", "profileName"]);
                updateClusterIdHandler(cl, args{:});
                waitForClusterToStartHandler(cl, options);
            end
        end
    end
end


function updateClusterIdHandler(cluster, options)
    % UPDATECLUSTERIDHANDLER Updates cluster ID in named or default configuration profile
    arguments
        cluster databricks.Cluster
        options.updateClusterId (1,1) logical = false
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if options.updateClusterId
        if isprop(cluster, "cluster_id")
            fprintf("Updating clusterId in configuration profile: %s to: %s\n", options.profileName, cluster.cluster_id);
            updateClusterId(cluster, profileName=options.profileName);
        else
            fprintf(2, "A cluster_id property is expected for a created cluster.\n");
            fprintf("Once properly created, to make a cluster the default use: updateClusterId(<returned databricks.Cluster object>) or updateClusterId(<cluster ID>)\n");
        end
    else
        if options.verbose
            if isprop(cluster, "cluster_id")
                fprintf("To make this cluster the default use:\n   updateClusterId(<returned databricks.Cluster object>) or updateClusterId('%s') or the named argument: updateClusterId=true\n", cluster.cluster_id);
            else
                fprintf(2, "A cluster_id property is expected for a created cluster.\n");
                fprintf("Once properly created, to make a cluster the default use: updateClusterId(<returned databricks.Cluster object>) or updateClusterId(<cluster ID>)\n");
            end
        end
    end
end


function cl = configureLogging(cl, logDir)
    %% CONFIGURELOGGING Configures cluster log delivery location
    % Turn on logging of the init scripts including the runtime install by
    % configuring the cluster log delivery location
    % Default is "dbfs:/cluster-logs"
    % See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery

    ioEnumType = databricks.internal.io.IO.getType(logDir);
    if ioEnumType ~= "VOLUMES" && ioEnumType ~= "DBFS"
        fprintf(2, "Expected logDir of the form dbfs:<PATH> or /Volumes/catalog_name/schema_name/volume_name/path\n");
        fprintf(2, "Skipping logging configuration.\n");
        return;
    end

    if ioEnumType == "VOLUMES"
        if isprop(cl, "data_security_mode")
            if cl.data_security_mode ~= databricks.datastructures.DataSecurityMode.SINGLE_USER &&...
                    cl.data_security_mode ~= databricks.datastructures.DataSecurityMode.USER_ISOLATION
                fprintf(2, "/Volumes logging is only support on Standard & Dedicated security access mode clusters.\n");
                fprintf(2, "Skipping logging configuration.\n");
                return;
            end
        else
            fprintf("Cluster data security mode not configured, configuring /Volumes logging with validating data security mode.\n");
        end
    end

    % If the destination directory does not already exist it will be
    % created automatically
    % Convert a logDir scalar string to a char
    conf = databricks.ClusterLogConf;
    conf.setDestination(char(logDir));
    cl.setClusterLogConf(conf);
end


function cl = configureAccessMode(cl, options)
    % CONFIGUREACCESSMODE Configures cluster access mode, aka Data Security Mode
    if isfield(options, 'accessMode')
        if options.accessMode == databricks.datastructures.DataSecurityMode.SINGLE_USER
            % Add the single_user_name property and then set it
            if ~isprop(cl,'single_user_name')
                cl.addprop('single_user_name');
            end
            settings = databricks.internal.settings.Settings.getSettingsStruct();
            cl.single_user_name = settings.username;
        end
        cl.setDataSecurityMode(options.accessMode);
    else
        fprintf(2, 'accessMode field not set, data_security_mode property not configured');
    end
end


function cl = configurePolicy(cl, options) %#ok<DEFNU>
    %CONFIGUREPOLICY Configures cluster policy

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    cp = databricks.ClusterPolicy(args{:});
    policyList = cp.list();

    if ~isprop(policyList, 'totalCount')
        error('DATABRICKS:ERROR', 'Policy totalCount field not found');
    end
    if policyList.totalCount < 1
        error('DATABRICKS:ERROR', 'Policy totalCount = %d', policyList.totalCount);
    end
    if ~isprop(policyList, 'policies')
        error('DATABRICKS:ERROR', 'Policy polices field not found');
    end

    if isfield(options, 'policyId') && strlength(options.policyId) > 0
        if ~isprop(policyList.policies, 'policyId')
            warning('DATABRICKS:WARNING', 'Policy polices.policyId field not found');
            return;
        end
        idMatches = matches(vertcat(policyList.policies.policyId), options.policyId);
        idx = find(idMatches, 1, 'first');
        if sum(idMatches) < 1
            error('DATABRICKS:ERROR', 'No matching policy found for ID: %s', options.policyId);
        elseif sum(idMatches) > 1
            % Should never happen
            idx = idx(1);
            warning('DATABRICKS:WARNING', 'More than one policy_id match found using first value');
        end
        if isempty(idx)
            error('DATABRICKS:ERROR', 'policyId index empty');
        else
            cl.setPolicyId(policyList.policies(idx).policyId);
        end
    elseif isfield(options, 'policyName') && strlength(options.policyName) > 0
        if ~isprop(policyList.policies, 'name')
            warning('DATABRICKS:WARNING', 'Policy polices.name field not found');
            return;
        end
        idMatches = matches(vertcat(policyList.policies.name), options.policyName, IgnoreCase=true);
        idx = find(idMatches, 1, 'first');
        if sum(idMatches) < 1
            error('DATABRICKS:ERROR', 'No matching policy found for name: %s', options.name);
        elseif sum(idMatches) > 1
            idx = idx(1);
            warning('DATABRICKS:WARNING', 'More than one name match found for: %s, using first value, ID: ', options.name, policyList.policies(idx).policyId);
        end
        if isempty(idx)
            error('DATABRICKS:ERROR', 'policyId index empty');
        else
            cl.setPolicyId(policyList.policies(idx).policyId);
        end
    else
        warning('DATABRICKS:WARNING', 'Neither policyId or policyName set');
    end
    if options.verbose
        fprintf("Cluster configured using a policy, non policy specification arguments and default values are ignored.\n");
    end
end

function s = getDockerAuthStruct(path, options)
    % GETDOCKERAUTHSTRUCT Reads and parses Docker authentication configuration from file
    arguments (Input)
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    arguments (Output)
        s struct
    end

    ioEnumType = databricks.internal.io.IO.getType(path, "verbose", false);
    if isempty(ioEnumType)
        if isfile(path)
            if ~endsWith(lower(path), ".json")
                fprintf(2, "Expected path to end with .json extension: %s\n", path);
            end
            s = jsondecode(fileread(path));
        else
            error('DATABRICKS:GETDOCKERAUTHSTRUCT:NOFILE', 'Docker auth file not found: %s', path);
        end
    else
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        io = databricks.internal.io.IO(args{:});
        [result, localTempFile] = io.download(path, destination=tempdir, verbose=false);
        if result
            deleteAfter = onCleanup(@() delete(localTempFile));
            s = jsondecode(fileread(localTempFile));
        else
            error('DATABRICKS:GETDOCKERAUTHSTRUCT:DOWNLOAD', 'Failed to download Docker auth file from: %s', path);
        end
    end
end

function cl = configureDockerAndSparkVersion(cl, options)
    % CONFIGUREDOCKERANDSPARKVERSION Configures Docker image settings for the cluster
    if isfield(options, 'dockerAuthFile')
        S = getDockerAuthStruct(options.dockerAuthFile);
        assert(isfield(S, 'url'), 'The JSON file with Docker auth information needs a url field.')
        if isfield(options, "instanceProfileARN")
            diStruct = struct('url', S.url);
            cl.setInstanceProfileARN(options.instanceProfileARN);
        elseif isfield(S, 'basic_auth')
            assert(isfield(S.basic_auth, 'username'), 'The JSON file with Docker basic_auth information needs a username field.')
            assert(isfield(S.basic_auth, 'password'), 'The JSON file with Docker basic_auth information needs a password field.')
            dbaStruct = struct(...
                'username', S.basic_auth.username, ...
                'password', S.basic_auth.password);
            diStruct = struct( ...
                'url', S.url, ...
                'basic_auth', databricks.datastructures.DockerBasicAuth(dbaStruct));
        else
            diStruct = struct('url', S.url);
        end
        di = databricks.datastructures.DockerImage(diStruct);
        cl.setDockerImage(di);

        % Set the spark_version if provided in Docker auth file
        % If not warn and use the optional argument else error
        if isfield(S, "spark_version")
            cl.spark_version = S.spark_version;
            if isfield(options, "spark_version")
                fprintf(2, "When using a docker auth file with a spark_version field the optional sparkVersion argument is ignored\n");
            end
        else
            if isfield(options, "sparkVersion")
                fprintf(2, 'spark_version field not found in Docker auth file, please update the file: %s', options.dockerAuthFile);
                fprintf(2, 'Using sparkVersion argument: %s\n', options.sparkVersion);
                cl.spark_version = options.sparkVersion;
            else
                error("DATABRICKS:CONFIGUREDOCKER:SPARKVER1",...
                    "A sparkVersion argument is not provided and the spark_version field was not found in Docker auth file: %s\n" + ...
                    "The cluster cannot be created.", options.dockerAuthFile);
            end
        end
    elseif strlength(options.dockerURL) > 0
        diStruct = struct;
        diStruct.url = options.dockerURL;
        if isfield(options, 'dockerUsername') && strlength(options.dockerUsername) > 0
            dbaStruct = struct;
            dbaStruct.username = options.dockerUsername;
            if isfield(options, 'dockerPassword') && strlength(options.dockerPassword) > 0
                dbaStruct.password = options.dockerPassword;
            else
                dbaStruct.password = "";
            end
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
            diStruct.basic_auth = dba;
        end
        di = databricks.datastructures.DockerImage(diStruct);
        cl.setDockerImage(di);
        if isfield(options, "instanceProfileARN")
            cl.setInstanceProfileARN(options.instanceProfileARN);
        end

        if isfield(options, "sparkVersion")
            cl.spark_version = options.sparkVersion;
        else
            error("DATABRICKS:CONFIGUREDOCKER:SPARKVER1",...
                "A sparkVersion argument must be provided. The cluster cannot be created.");
        end
    else
        error('DATABRICKS:CONFIGUREDOCKER:NODOCKER',...
            "When using docker either a dockerAuthFile or dockerURL and authentication values must be provided, the cluster cannot be created.");
    end

    if isprop(cl, "spark_conf") && ~isempty(cl.spark_conf)
        if ~isKey(cl.spark_conf, "spark.databricks.unityCatalog.volumes.enabled")
            cl.spark_conf("spark.databricks.unityCatalog.volumes.enabled") = "true";
        end
    else
        fprintf(2, "Cluster Spark Conf not found, spark.databricks.unityCatalog.volumes.enabled=""true"" not set.\n" +...
            "The cluster will not be able to access /Volumes based storage.\n");
    end
end


function cl = nonDockerMATLABCfgCreate(cl, options)
    % NONDOCKERMATLABCFGCREATE Library installation *has* to follow create as it requires a cluster id
    if isfield(options, 'javabuilderLoc')
        javabuilderPath = options.javabuilderLoc;
        fprintf(2, "The javabuilderLoc option is deprecated and will be removed in a future release.\n");
    else
        if isfield(options, 'dockerURL') || isfield(options, 'dockerAuthFile')
            % Not documented functionality may be problematic in USER_ISOLATION
            %javabuilderPath = "file:///MATLAB_Runtime/toolbox/javabuilder/jar/javabuilder.jar";
            error("nonDockerMATLABCfgCreate not supported when using docker.");
        else
            if isfield(options, "release")
                release = options.release;
            else
                release = matlabRelease().Release;
            end
            if isfield(options, "interfaceDirectory")
                interfaceDirectory = options.interfaceDirectory;
            else
                interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
            end
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            javabuilderPath = databricks.internal.mlRuntime.getLatestJavabuilder(interfaceDirectory, release, args{:});
        end
    end

    % If using file we cannot check if the file is there prior to
    % boot so assume it is and set create to true
    % Similar for docker we must assume the container is okay
    if isempty(javabuilderPath) || strlength(javabuilderPath) == 0
        % fprintf(2, "No javabuilder jar found.\n");
        haveJavabuilder = false;
    else
        if isfield(options, 'dockerURL') || startsWith(javabuilderPath, "file:")
            haveJavabuilder = true;
        else
            pathType = databricks.internal.io.IO.getType(javabuilderPath);
            if ismember(pathType, ["VOLUMES", "WORKSPACE", "DBFS"])
                args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                io = databricks.internal.io.IO(args{:});
                if ~io.isfile(javabuilderPath, verbose=false)
                    fprintf(2, "javabuilder library jar file not found: %s\n", javabuilderPath);
                    haveJavabuilder = false;
                else
                    haveJavabuilder = true;
                end
            else
                % cloud types so assume it exists
                haveJavabuilder = true;
            end
        end
    end

    if haveJavabuilder
        cl.create();
        try
            % Java builder support is deprecated and will be removed in a future release
            pause(1); % Short pause to let create happen
            cl.refresh;
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            javaBuilderLibrary = databricks.Library(args{:});
            javaBuilderLibrary.setType('jar');
            javaBuilderLibrary.jar = javabuilderPath;
            args = matlab.utils.addArgs(options, "profileName");
            if ~isprop(cl, "cluster_id")
                error("DATABRICKS:ERROR", "Cluster does not have the required cluster_id property.");
            end
            javaBuilderLibrary.install(cl.cluster_id, false, args{:});
            waitForClusterToStartHandler(cl, options);
        catch ME
            fprintf(2, "javabuilder library installation failed: %s\n", javabuilderPath);
            fprintf(2, "Message: %s\n", ME.message);
            fprintf("Attempting to delete the newly created cluster: %s\n", cl.cluster_id);
            cl.permanentDelete();
            error("DATABRICKS:ERROR", "Could not create a cluster with javabuilder library: %s", javabuilderPath);
        end
    else
        % fprintf(2, "Not installing javabuilder library.\n");
        cl.create();
        waitForClusterToStartHandler(cl, options);
    end
end


function validateNumWorkers(numWorkers)
    if ~isscalar(numWorkers)
        if ~all(size(numWorkers) == [1, 2]) || numWorkers(1) >= numWorkers(2)
            eidType = 'Databricks:Error:validateNumWorkers';
            msgType = "The numWorkers arguments must be either a scalar, e.g. 3,\n" + ...
                "or a vector of 2 elements where the second element is larger than the first, e.g. [2,10]";
            throwAsCaller(MException(eidType, msgType));
        end
    end
end


function waitForClusterToStartHandler(cluster, options)
    arguments(Input)
        cluster databricks.Cluster
        options struct
    end
    
    if options.waitForCluster
        % 12 minutes - A bit longer than typical docker based timeout
        timeout = int32(12*60);
        args = matlab.utils.addArgs(options, ["authMethod", "verbose", "profileName"]);
        databricks.internal.cluster.waitForClusterToStart("cluster", cluster, "timeout", timeout, args{:});
        cluster.refresh;
    end
end