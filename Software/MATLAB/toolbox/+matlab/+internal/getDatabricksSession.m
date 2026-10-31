function spark = getDatabricksSession(options)
    % GETDATABRICKSSESSION Returns a Databricks Connect Spark Session.
    %
    % Optional named arguments:
    %   cluster - A cluster id, or an instance of a databricks.Cluster
    %       object. If a cluster Id argument is not provided, the default or
    %       provided profile will be checked for a cluster Id. This is required
    %       if not using serverless.
    %
    %   serverless - Set to true to use serverless. If set to true, any
    %       cluster argument will be ignored. Default: false.
    %
    %   skipVersionChecks - Set to true to skip version checks for:
    %           * Client Python version support.
    %           * Client Python serverless support.
    %           * MATLAB Python version support.
    %           * Client Python version matches the cluster Python version.
    %           * Databricks Connect service disabled.
    %       The use of this argument is not recommended and is likely to result
    %       in errors. However, it may sometimes be useful for testing purposes.
    %       Default: false.
    %
    %   dependencies - Used to provided a list of Python packages that should be
    %       installed in the Python environment before creating the Spark session.
    %       This is useful when additional libraries are required.
    %
    %   profileName - Used to optionally specify a profile name.
    %
    %   authMethod - Used to optionally specify an authentication method.
    %
    %   logging - set this to a different logging level for Spark. The
    %       logging argument can be one of the following:
    %       "debug", "error", "fatal", "info", "warn". The function
    %       tries to reset the value after returning from this function, but
    %       the value seems to be cached by the underlying Spark library. In
    %       these cases, it may be necessary to either restart the Python
    %       environment if using the 'OutOfProcess' configuration, or
    %       restart MATLAB if using the 'InProcess' configuration.
    %
    %   verbose - Set to true will output more information. Default: true.
    %
    %   forceNewSession - If set to true, this will create a new Spark
    %        Session. If set to false or omitted, it will reuse an existing
    %        Spark Session, if available.
    %        This is especially useful in development workflows, where a
    %        new version of an artifact is uploaded with the addArtifact
    %        method. If an old session is reused, the artifact cannot be
    %        replaced. Default: false.
    %
    % A serverless compute session times out after 10 minutes of inactivity.
    % Connection creation failures time out after 5 minutes.
    %
    % Serverless compute will be used if:
    %   * The serverless argument is set to true.
    %   * The environment variable DATABRICKS_SERVERLESS_COMPUTE_ID is set to auto.
    %   * The configuration profile has serverless_compute_id set to auto.
    %   * The configuration profile should not contain a cluster_id field.
    %
    %
    % Example:
    %   % Use default cluster Id from profile
    %   spark = getDatabricksSession()
    %
    %   % Use a specific cluster Id
    %   spark = getDatabricksSession(cluster='my-cluster-id')
    %
    % See also: https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements
    %
    % This function only supports Databricks Connect v2, v1 is not supported.

    % TODO consider adding cfg file name support.

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrIdImpl}
        options.serverless (1,1) logical = false
        options.skipVersionChecks (1,1) logical = false
        options.dependencies string {mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.authMethod (1,1) matlab.internal.databricks.AuthMethod
        options.logging (1,1) string
        options.verbose (1,1) logical = true
        options.forceNewSession (1,1) logical = false
    end
    arguments (Output)
        spark (1,1) databricks.internal.PySparkSession
    end

    errBase = "DATABRICKS:GETDATABRICKSSESSION";

    % Intel macOS is not supported, errors if so
    checkForIntelMac();

    % Must be serverless or not
    if options.serverless && isfield(options, 'cluster')
        error(errBase+":CLUSTER_AND_SERVERLESS_INCOMPATIBLE", ...
            "A cluster argument and serverless=true cannot be specified at the same time.");
    end

    % Must be first call to Python environment to ensure it's configured
    clientPythonVersion = getClientPythonVersion();

    if options.serverless
        mode = "serverless";
        if options.verbose
            cfg = databricks.internal.configurationprofile.ConfigFile();
            profile = cfg.getProfile(options.profileName);
            if profile.isKey("cluster_id")
                fprintf("Using Serverless mode, the configured default cluster Id is ignored.\n")
                fprintf("To choose Serverless mode by default call: updateClusterId(""serverless"")\n");
            else
                fprintf("To choose Serverless mode by default call: updateClusterId(""serverless"")\n");
            end
        end
    elseif isServerlessComputeIdAuto(profileName=options.profileName)
        % isServerlessComputeIdAuto also checks the DATABRICKS_SERVERLESS_COMPUTE_ID environment variable
        mode = "serverless";
    else
        mode = "classic";
        checkServerlessComputeIdSet(profileName=options.profileName);

        % Get a cluster object from the start
        args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
        if isfield(options, "cluster")
            [clusterId, clusterObj] = databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(options.cluster, args{:});
        else
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
            if isempty(clusterId) || strlength(clusterId) == 0
                error(errBase+":CLUSTERID", ...
                    "cluster_id not set in arguments or profile: %s, use: updateClusterId('cluster-id-value')", ...
                    options.profileName);
            else
                [clusterId, clusterObj] = databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(clusterId, args{:});
            end
        end

        if isempty(clusterObj)
            error(errBase+":NOCLUSTEROBJ",...
                "Failed to retrieve a cluster object for cluster Id: %s", clusterId);
        end

        % Check for Spark Conf property that turns off Databricks Connect, errors if so
        if ~options.skipVersionChecks
            checkServiceEnabled(clusterObj);
        end

        % Get the numeric form of a cluster runtime e.g. 16.4
        clusterRuntimeVersion = databricks.internal.cluster.getClusterRuntimeVersionImpl(clusterObj);

        % Check if this MATLAB supports the required Python version of the Databricks runtime
        clusterPythonVersion = matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion(clusterRuntimeVersion);
        if ~options.skipVersionChecks && ~matlab.internal.utils.isPythonVersionSupported(clusterPythonVersion)
            error(errBase+":NOPYSUPPORT", ...
                "MATLAB %s does not support the version of Python used on the cluster: %s\n" + ...
                "See: %s\n" + ...
                "To skip this check use the argument: skipVersionChecks=true", ...
                matlabRelease().Release, clusterPythonVersion, ...
                matlab.internal.utils.URL2Link("https://mathworks.com/support/requirements/python-compatibility.html"));
        end

        if ~options.skipVersionChecks && ~startsWith(clientPythonVersion, clusterPythonVersion)
            error(errBase+":NOPYMATCH", ...
                "The configured Python environment: %s, must match the cluster Python version: %s\n" + ...
                "To configure an alternative Python environment use pyenv.\n" + ...
                "See: %s\n" + ...
                "To skip this check use the argument: skipVersionChecks=true", ...
                clientPythonVersion, clusterPythonVersion);
        end
    end

    % Get the version of the installed Databricks Client, throws an error if the package is not installed
    DBCClientVersion = databricks.internal.databricksConnect.getDBCClientVersionImpl();

    % Validate Databricks Connect client version compatibility
    if ~options.skipVersionChecks && ~checkClientVersionSupport(mode, DBCClientVersion, clientPythonVersion)
        error(errBase+":CLIENTVER", ...
            "The combination of Databricks Connect client: %s, mode: %s and Python version: %s, are not supported.\n" + ...
            "See: %s\n" + ...
            "To skip this check use the argument: skipVersionChecks=true", ...
            DBCClientVersion, mode, clientPythonVersion, ...
            matlab.internal.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements"));
    end

    % Validate runtime and client as per databricks/connect/validation.py
    if mode == "classic" % Should apply to serverless too but do not have a cluster version to check
        if ~options.skipVersionChecks && ~checkClientAndRuntimeSupport(DBCClientVersion, clusterRuntimeVersion)
            error(errBase+":CLIENTRTVER", ...
                "Databricks Connect client: %s and cluster runtime versions: %s, are not compatible.\n" + ...
                "To skip this check use the argument: skipVersionChecks=true", ...
                DBCClientVersion, clusterRuntimeVersion);
        end
    end

    % Check the SDK support OauthU2M if needed
    authMethod = checkAuthMethodRequirements(options, options.skipVersionChecks); %#ok<NASGU>

    % The following variable is needed for cleanup, as the function returns
    cleanupLogging = setupLogging(options); %#ok<NASGU>

    % Create the Spark Session object
    if mode == "classic"
        args = matlab.internal.utils.addArgs(options, ["profileName", "authMethod"]);
        startedClusterObj = databricks.internal.cluster.startClusterImpl(clusterObj, args{:});
        baseArgs = {"mode", mode, "clusterRuntimeVersion", clusterRuntimeVersion,"platform", "databricks", "cluster", startedClusterObj};
    else
        baseArgs = {"mode", mode, "platform", "databricks"};
    end
    args = matlab.internal.utils.addArgs(options, ["dependencies", "profileName", "authMethod", "verbose", "skipVersionChecks", "forceNewSession"], baseArgs);
    spark = databricks.internal.PySparkSession(args{:});
end


function authMethod = checkAuthMethodRequirements(options, skipVersionChecks)
    % CHECKAUTHMETHODREQUIREMENTS Validates auth method requirements
    arguments
        options struct
        skipVersionChecks (1,1) logical
    end

    obj = databricks.internal.Object();
    authObjectArgs = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
    obj.getAuth("verbose", true, authObjectArgs{:}, "enableAuthenticate", false, "verbose", false);

    authMethod = obj.AuthMethod;
    if authMethod == "OauthU2M"
        sdkVersion = getDataBricksSDKVersion();
        if ~skipVersionChecks && matlab.internal.utils.SemVer(sdkVersion) < "0.1.9"
            error("DATABRICKS:GETDATABRICKSSESSION:CHECKAUTHMETHODREQUIREMENTS:SDKVER", ...
                "Databricks Connect SDK version 0.1.9 or greater is required for OAuthU2M authentication\n." + ...
                "Current version: %s\n" + ...
                "To skip this check use the argument: skipVersionChecks=true", ...
                sdkVersion);
        end
    end
end

function cleanupLogging = setupLogging(options)
    % SETUPLOGGING Configures Python environment logging level for Spark Connect
    cleanupLogging = [];
    try
        if isfield(options, 'logging')
            oldVal = pyrun(["import os", "old = os.environ.get('SPARK_CONNECT_LOG_LEVEL')"], "old");
            if isa(oldVal, 'py.str') && (string(oldVal) == options.logging)
                return; % Already set, no need for changes or cleanup
            else
                pyrun(sprintf("os.environ['SPARK_CONNECT_LOG_LEVEL'] = '%s'", options.logging));
                cleanupLogging = onCleanup(@() revertLogLevel(oldVal));
            end
        end
    catch ME
        warning("DATABRICKS:GETDATABRICKSSESSION:SETUPLOGGING", ...
            "Failed to setup logging using SPARK_CONNECT_LOG_LEVEL: %s", ME.message);
    end
end


function revertLogLevel(oldVal)
    % REVERTLOGLEVEL Reverts the SPARK_CONNECT_LOG_LEVEL environment variable to its previous state
    try
        if isa(oldVal, 'py.str')
            pyrun(sprintf("os.environ['SPARK_CONNECT_LOG_LEVEL'] = '%s'", string(oldVal)));
        elseif isa(oldVal, 'py.NoneType')
            py.os.environ().pop('SPARK_CONNECT_LOG_LEVEL');
        end
    catch ME
        warning("DATABRICKS:GETDATABRICKSSESSION:SETUPLOGGING", ...
            "Failed to revert logging setup using SPARK_CONNECT_LOG_LEVEL: %s", ME.message);
    end
end


function checkForIntelMac()
    % CHECKFORINTELMAC Checks if running on Apple Intel architecture and errors if so
    arch = string(computer('arch'));
    if strcmp(arch, "maci64")
        msg = sprintf("Databricks Connect is not supported on the Apple Intel architecture: %s\n", arch);
        msg = msg + "A native Apple silicon release of MATLAB is available for R2023b and later.";
        error('DATABRICKS:GETDATABRICKSSESSION:MACI64SUPPORT', msg);
    end
end


function clientPythonVersion = getClientPythonVersion()
    % GETCLIENTPYTHONVERSION Returns the version string of the Python environment
    pe = pyenv();
    if isempty(pe)
        error("DATABRICKS:GETDATABRICKSSESSION:GETCLIENTPYTHONVERSION:NOPYENV", ...
            "No Python environment configured.\n" + ...
            "Please configure a Python environment before using Databricks Connect.\n" + ...
            "To configure a Python environment use: pyenv() %s", ...
            matlab.internal.utils.URL2Link("https://mathworks.com/help/matlab/ref/pyenv.html"));
    else
        clientPythonVersion = pe.Version;
    end
end



function sdkVersion = getDataBricksSDKVersion()
    % GETDATABRICKSSDKVERSION Returns the version string of the Databricks Connect Python package
    pkgName = 'databricks.sdk';
    try
        sdkVersion = string(py.importlib.metadata.version(pkgName));
    catch ME
        if isprop(ME, "message") && strcmpi(ME.message, sprintf("Python Error: PackageNotFoundError: No package metadata was found for %s", pkgName))
            error("DATABRICKS:GETDATABRICKSSESSION:GETDATABRICKSSDKVERSION", ...
                "The %s package is not installed in the current Python environment.\n", pkgName);
        else
            rethrow(ME);
        end
    end
end


function tf = checkClientAndRuntimeSupport(DBCClientVersion, runtimeVersion)
    % CHECKCLIENTANDRUNTIMESUPPORT Check if the Client and Runtime version are compatible
    % See also: site-packages/databricks/connect/validation.py _is_compat()
    arguments (Input)
        DBCClientVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        runtimeVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    clientSV = matlab.internal.utils.SemVer(DBCClientVersion);
    rtSV = matlab.internal.utils.SemVer(runtimeVersion);

    tf = true;
    if rtSV.major < clientSV.major
        tf  = false;
        return;
    end
    if rtSV.major == clientSV.major && rtSV.minor < clientSV.minor
        tf = false;
        return;
    end
end


function tf = checkClientVersionSupport(mode, DBCClientVersion, clientPythonVersion)
    % CHECKCLIENTVERSIONSUPPORT Validates Databricks Connect client version compatibility
    % See also: https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements
    arguments (Input)
        mode string {mustBeTextScalar, mustBeNonzeroLengthText}
        DBCClientVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        clientPythonVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;

    clientVersionSV = matlab.internal.utils.SemVer(DBCClientVersion);
    pyVersionSV = matlab.internal.utils.SemVer(clientPythonVersion);

    % testing values for v18 non LTS
    if mode == "serverless" && clientVersionSV > "18" && clientVersionSV < "18.1" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "18" && clientVersionSV < "18.2" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "serverless" && clientVersionSV >= "17.2" && clientVersionSV < "17.4" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "17.2" && clientVersionSV < "17.4" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "serverless" && clientVersionSV >= "16.4.1" && clientVersionSV < "17" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "16.4.0" && clientVersionSV < "16.5" && pyVersionSV == "3.12"
        tf = true;
        return;
    end

    if mode == "serverless" && clientVersionSV >= "15.4.10" && clientVersionSV < "16.0" && pyVersionSV == "3.11"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "15.4" && clientVersionSV < "15.5" && pyVersionSV == "3.11"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "14.3" && clientVersionSV < "14.4" && pyVersionSV == "3.10"
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "13.3" && clientVersionSV < "13.4" && pyVersionSV == "3.10"
        tf = true;
        return;
    end

    % End of support versions

    if mode == "serverless" && clientVersionSV >= "17.0" && clientVersionSV < "17.2" && pyVersionSV == "3.12"
        dbEndOfSupportMsg()
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "16.0" && clientVersionSV < "16.4" && pyVersionSV == "3.12"
        dbEndOfSupportMsg()
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "15.1" && clientVersionSV < "15.4" && pyVersionSV == "3.11"
        dbEndOfSupportMsg()
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "14.0" && clientVersionSV < "14.3" && pyVersionSV == "3.10"
        dbEndOfSupportMsg()
        tf = true;
        return;
    end

    if mode == "classic" && clientVersionSV >= "13.0" && clientVersionSV < "13.2" && pyVersionSV == "3.10"
        dbEndOfSupportMsg()
        tf = true;
        return;
    end
end


function dbEndOfSupportMsg()
    fprintf(2, "This version of Databricks Connect has reached end-of-support, plan to upgrade to a supported version.\n");
    fprintf(2, "See: %s\n", matlab.internal.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements"));
end


function checkServiceEnabled(cluster)
    % CHECKSERVICEENABLED Validates that Databricks Connect service is enabled on the cluster
    arguments
        cluster (1,1) databricks.internal.Cluster
    end

    if isprop(cluster, "spark_conf")
        if cluster.spark_conf.isKey("spark.databricks.service.server.enabled")
            if strcmpi(cluster.spark_conf("spark.databricks.service.server.enabled"), "false")
                error("Databricks Connect is disabled using spark.databricks.service.server.enabled on cluster: %s\n" + ...
                    "See: %s\n" + ...
                    "To skip this check use the argument: skipVersionChecks=true", ...
                    cluster.cluster_id, ...
                    matlab.internal.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/cluster-config"));
            end
        end
    end
end


function checkServerlessSupportedPythonVersion(clientPythonVersion)
    arguments
        clientPythonVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    pyVersionSV = matlab.internal.utils.SemVer(clientPythonVersion);
    if ~(pyVersionSV >= "3.11" && pyVersionSV <= "3.12")
        error("DATABRICKS:GETDATABRICKSSESSION:CHECKSERVERLESSSUPPORTEDPYTHONVERSION", ...
            "Python version: %s, is not supported for serverless Databricks Connect.\n", + ...
            "See: %s\n" + ...
            "To configure an alternative Python environment use pyenv.\n" + ...
            "See: %s\n" + ...
            "To skip this check use the argument: skipVersionChecks=true", ...
            clientPythonVersion, ...
            matlab.internal.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements"), ...
            matlab.internal.utils.URL2Link("https://mathworks.com/help/matlab/ref/pyenv.html"));
    end
end


function tf = isServerlessComputeIdAuto(options)
    arguments (Input)
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    arguments (Output)
        tf (1,1) logical
    end

    serverlessComputeId = databricks.internal.configurationprofile.ConfigFile.getProfileField("serverless_compute_id", profileName=options.profileName);
    if isempty(serverlessComputeId) || strlength(serverlessComputeId) == 0
        tf = false;
    else
        if strcmpi(strtrim(serverlessComputeId), "auto")
            tf = true;
        else
            tf = false;
        end
    end
end


function checkClusterIdSet(options)
    arguments
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    cfg = databricks.internal.configurationprofile.ConfigFile();
    profile = cfg.getProfile(options.profileName);

    if profile.isKey("cluster_id")
        fprintf("\n");
        fprintf("The .databrickscfg configuration file has a classic mode cluster_id field set.\n");
        fprintf("To update your configuration file for Serverless mode use:\n");
        fprintf("  updateClusterId(""serverless"")\n\n");
        error("DATABRICKS:GETDATABRICKSSESSION:checkClusterIdSet", ...
            "cluster_id configuration field set in serverless mode.");
    end
end


function checkServerlessComputeIdSet(options)
    arguments
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    cfg = databricks.internal.configurationprofile.ConfigFile();
    profile = cfg.getProfile(options.profileName);

    if profile.isKey("serverless_compute_id")
        fprintf("\n");
        fprintf("The .databrickscfg configuration file has a serverless mode serverless_compute_id field set.\n");
        fprintf("To update your configuration file for Serverless mode use:\n");
        fprintf(2, "  updateClusterId(""clusterId value"") or updateClusterId(clusterObject)\n\n");
        error("DATABRICKS:GETDATABRICKSSESSION:checkServerlessComputeIdSet", ...
            "serverless_compute_id configuration field set in classic mode.");
    end
end
