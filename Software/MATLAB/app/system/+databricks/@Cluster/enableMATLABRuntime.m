function enableMATLABRuntime(obj, options)
    % ENABLEMATLABRUNTIME Configures usage of the MATLAB runtime
    %
    % Init scripts are not supported on Databricks runtimes 17.0 and later,
    % an error will be returned. Use Databricks Container Services (Docker)
    % instead.
    % 
    % This method supports a number of optional name value pair parameters.
    %
    %          enableLogging: Set to true to turn on logging of the init scripts
    %                         including the runtime install. Default is
    %                         false.
    %
    %                logDir : The location to which logs are written, the default is:
    %                         dbfs:/cluster-logs
    %                         If using /Volumes (Public Preview) additional
    %                         restrictions apply.
    %                         See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
    %
    %     interfaceDirectory: /Volumes path under which MathWorks files are stored.
    %
    %         initscriptPath: An init script path, path may begin with /Volumes,
    %                         /Users, /Shared, s3:// or abfss://.
    %                         If an initscriptPath is given and the file is not found,
    %                         an attempt will be made to upload the local copy script
    %                         included in the package to the specified
    %                         path. Uploads are only supported to /Volumes,
    %                         /Users & /Shared.
    %
    %                release: MATLAB release of the form R2024b for the runtime to install.
    %                         By default the release of MATLAB in use is used.
    %
    %            runtimePath: Specify a path to a MATLAB runtime .zip file.
    %                         /Volumes and http paths are supported.
    %                         Example:
    %                           /Volumes/main/default/myvolume/MathWorks/runtimes/MATLAB_Runtime_R2024b_glnxa64.zip
    %
    %                mcrRoot: Path to the installed MATLAB runtime root, default
    %                         is "/MATLAB_Runtime".
    %
    %             authMethod: A matlab.databricks.AuthMethod
    %
    %            profileName: A configuration file profileName value
    %
    %                verbose: Enable additional feedback. Default is true.
    %
    %
    % Examples
    %    % Typical values, enable the runtime init script, enable logging & configure
    %    % Spark environment variables
    %    cl = databricks.Cluster;
    %    cl.enableMATLABRuntime('enableLogging', true);
    %
    %    % Create and install script and upload it, not using default directory to
    %    % avoid trampling on a production script e.g. if testing a new runtime
    %    cl = databricks.Cluster;
    %    cl.enableMATLABRuntime('initscriptPath', '/Users/username@example.com/MathWorks/runtime_install.sh');

    %   (c) 2019-2025 The MathWorks, Inc.

    arguments
        obj databricks.Cluster

        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscriptPath string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.release string {mustBeTextScalar, mustBeNonzeroLengthText} = matlabRelease().Release
        options.runtimePath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.mcrRoot string {mustBeTextScalar, mustBeNonzeroLengthText} = "/MATLAB_Runtime"

        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

        options.enableLogging (1,1) logical = false
        options.logDir string {mustBeTextScalar, mustBeNonzeroLengthText} = "dbfs:/cluster-logs"

        options.verbose (1,1) logical = true
    end

    if obj.getClusterVersionSemVer().ge(17)
        error("DATABRICKS:NOININTDOCKER", "The MATLAB runtime init script is not supported on cluster runtimes 17.0 and later.\nUse Databricks Container Services (Docker) instead.");
    end

    %% interfaceDirectory
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
    end
    
    if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
        error("DATABRICKS:NOINTERFACEDIRECTORY", "interfaceDirectory is not defined as an argument or a settings file field.");
    end

    %% initscript
    if isfield(options, "initscriptPath")
        initscriptPath = options.initscriptPath;
    else
        initscriptPath = interfaceDirectory + "/runtimes/runtime_install.sh";
    end

    if isempty(initscriptPath) || strlength(initscriptPath) == 0
        error("DATABRICKS:NOINITSCRIPTPATH", "initscriptPath is not defined.");
    end

    % Check if the init script exists and potentially upload it
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"], {"verbose",false});
    if ~isInitScriptFound(initscriptPath, args{:})
        error("DATABRICKS:ENABLEMATLABRUNTIME", ...
            "Init script not found on the path: %s.\nSee: %s", initscriptPath, matlab.utils.internal.editOrURLLink("InitScripts"));
    end

    % Check NONE and /Volumes
    if checkVolumesAndNone(obj, initscriptPath)
        error("DATABRICKS:ENABLEMATLABRUNTIME", ...
              "Init scripts using /Volumes are not supported on No isolation shared access mode (Legacy) / NONE clusters.");
    end

    if options.verbose && ~isMATLABReleaseOlderThan("R2024b") && obj.getClusterVersionSemVer().eq(16)
        fprintf("Init scripts for MATLAB Runtimes for R2025a and later and Databricks runtime 16 require Internet access at boot time.\n");
    end

    % Set the init script property
    is = databricks.InitScriptInfo;
    is.setDestination(initscriptPath);
    obj.setInitScriptInfo(is);

    if options.enableLogging
        obj = configureLogging(obj, options.logDir);
    end

    % Set the runtime related properties
    args = matlab.utils.addArgs(options, ["runtimePath", "mcrRoot", "authMethod", "profileName"]);
    configureRuntimeProperties(obj, interfaceDirectory, options.release, args{:})
end


function tf = checkVolumesAndNone(obj, initscriptPath)
    % CHECKVOLUMESANDNONE Check if access mode is NONE and init script is on a /Volumes
    % Check is only preformed if the data_security_mode property exists
    % Returns true if the following Databricks error is expected to arise:
    % "INVALID_PARAMETER_VALUE","message":"Init scripts that use Unity Catalog
    % Volumes are only supported on Unity Catalog Shared or Assigned access mode clusters."
    arguments
        obj databricks.Cluster
        initscriptPath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    
    if isprop(obj, "data_security_mode")
        pathType = databricks.internal.io.IO.getType(initscriptPath);
        if pathType == "VOLUMES" && strcmp(obj.data_security_mode, "NONE")
            tf = true;
        else
            tf = false;
        end
    else
        tf = false;
    end
end


function configureRuntimeProperties(obj, interfaceDirectory, release, options)
    arguments
        obj databricks.Cluster
        interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.runtimePath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.mcrRoot string {mustBeTextScalar, mustBeNonzeroLengthText} = "/MATLAB_Runtime"
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    %% runtimePath
    if isfield(options, "runtimePath")
        runtimePath = options.runtimePath;
    else
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        runtimesDirectory = string(strip(interfaceDirectory, "right", "/")) + "/runtimes";
        runtimePath = databricks.internal.mlRuntime.getLatestRuntime("directory", runtimesDirectory, "release", release, args{:});
    end
    
    if isempty(runtimePath)
        runtimeLink = matlab.utils.URL2Link("https://www.mathworks.com/products/compiler/matlab-runtime.html");
        error("DATABRICKS:ENABLEMATLABRUNTIME:NOLATEST",...
              "No MATLAB runtime for release: %s, found in: %s\nDownload a Linux runtime .zip from: %s",...
              release, runtimesDirectory, runtimeLink);
    end

    % Check the type we to catch failure early
    pathType = databricks.internal.io.IO.getType(runtimePath);
    if ismember(pathType, ["VOLUMES", "WORKSPACE", "DBFS"])
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        io = databricks.internal.io.IO(args{:});
        if ~io.isfile(runtimePath, verbose=false)
            error("DATABRICKS:ENABLEMATLABRUNTIME", "MATLAB runtime not found: %s", runtimePath);
        end
    end

    if isfield(options, "mcrRoot")
        MCRROOT = char(options.mcrRoot);
    else
        MCRROOT = '/MATLAB_Runtime';
    end

    %% Environment variables
    LD_LIBRARY_PATH = [...
        MCRROOT,'/runtime/glnxa64:',...
        MCRROOT,'/bin/glnxa64:',...
        MCRROOT,'/sys/os/glnxa64:',...
        MCRROOT,'/extern/bin/glnxa64:', ...
        MCRROOT,'/sys/opengl/lib/glnxa64'];

    varCell = {'LD_LIBRARY_PATH',LD_LIBRARY_PATH; 'MW_CONNECTOR_CONNECTION_PROFILES','noop'; 'MW_RUNTIME_ZIP', char(runtimePath); 'MW_RUNTIME_RELEASE', char(release)};
    if ~isprop(obj,'spark_env_vars')
        addprop(obj,'spark_env_vars');
    end
    SEP = databricks.SparkEnvPair(varCell);
    obj.setSparkEnvVars(SEP);
end


function tf = isInitScriptFound(initscriptPath, options)
    arguments
        initscriptPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});
    initscriptPathType = databricks.internal.io.IO.getType(initscriptPath);

    switch initscriptPathType
        case {"ABFSS", "S3"}
            % Cannot attempt to upload for cloud types
            if options.verbose
                fprintf(2, "Not checking for existence of init script on path type: %s, assuming it exists.\n", initscriptPathType);
            end
            tf = true;
        case {"WORKSPACE", "VOLUMES"}
            % Actually check it exists and attempt to upload if not
            if ~io.isfile(initscriptPath, verbose=false)
                % The local script should exist
                localInitScript = databricksRoot("script", "runtime_install.sh");
                if ~isfile(localInitScript)
                    error("DATABRICKS:ENABLEMATLABRUNTIME", "Local runtime_install.sh file not found: %s", localInitScript);
                end
                if options.verbose
                    fprintf("Attempting to upload: %s to: %s\n", localInitScript, initscriptPath);
                end
                io.upload(localInitScript, initscriptPath);
                % Check if that worked
                if ~io.isfile(initscriptPath)
                    fprintf(2, "Init script upload to: %s, failed.", initscriptPath);
                    tf = false;
                else
                    tf = true;
                end
            else
                tf = true;
            end

        otherwise
            fprintf(2, "Unexpected path type: %s\n", initscriptPathType);
            tf = false;
    end
end


function cl = configureLogging(cl, logDir)
    % Turn on logging of the init scripts including the runtime install by
    % configuring the cluster log delivery location
    % Default is "dbfs:/cluster-logs"
    % See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery

    ioEnumType = databricks.internal.io.IO.getType(logDir);
    if ioEnumType ~= "VOLUMES" && ioEnumType ~= "DBFS"
        fprintf(2, "Expected logDir of the form dbfs:<PATH> or /Volumes/\n");
        fprintf(2, "Skipping logging configuration.\n");
        return;
    end
    
    if ioEnumType == "VOLUMES"
        if isprop(cl, "data_security_mode")
            if cl.data_security_mode ~= databricks.datastructures.DataSecurityMode.SINGLE_USER &&...
                cl.data_security_mode ~= databricks.datastructures.DataSecurityMode.USER_ISOLATION
                 fprintf(2, "/Volumes logging is only support on Standard (User Isolation) & Dedicated (Single User) security access mode clusters.\n");
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