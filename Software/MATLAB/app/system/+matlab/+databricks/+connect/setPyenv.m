function result = setPyenv(options)
    % SETPYENV Set a pyenv based on a Databricks runtime version, Python path or Cluster
    % In the case of an error an empty double is returned.
    % If successful a matlab.pyclient.PythonEnvironment is returned, this
    % should be checked before use.
    %
    % If a Software/MATLAB/Connect/<Major version>.<minor version > directory exists, 
    % it will be used, provided a configured venv exists therein.
    %
    % If an exact major & minor match is not found, the latest major number match
    % will be used if that exists.
    %
    % If the current pyenv is InProcess, it cannot be changed with restarting MATLAB.
    %
    % If neither a version python path or cluster object/id is provided a check is
    % made for a preconfigured default clusterId in the configuration file.
    %
    % Examples:
    %   result = matlab.databricks.connect.setPyenv();
    %
    %   result = matlab.databricks.connect.setPyenv("cluster","0507-105823-i0lkd9gn");
    %
    %   result = matlab.databricks.connect.setPyenv("pythonPath","/home/someuser/databricks/Software/MATLAB/Connect/15.4/venv/bin/python3");
    %
    %   result = matlab.databricks.connect.setPyenv("version","15.4")
    %   result = 
    % PythonEnvironment with properties:
    % 
    %         Version: "3.11"
    %      Executable: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv/bin/python3"
    %         Library: "/home/username/.pyenv/versions/3.11.10/lib/libpython3.11.so"
    %            Home: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv"
    %          Status: NotLoaded
    %   ExecutionMode: OutOfProcess

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        options.pythonPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    result = [];

    if sum([isfield(options, "pythonPath"), isfield(options, "cluster"), isfield(options, "version")]) > 1
        if options.verbose
            fprintf(2, "Only one of pythonPath, cluster or version, should be specified, using: pythonPath.");
        end
    end

    if isfield(options, "pythonPath")
        pyPath = options.pythonPath;
    elseif isfield(options, "version")
        if ~databricks.internal.databricksConnect.isDatabricksConnectv2Version(options.version)
            fprintf(2, "Spark version: %s does not support Databricks Connect v2, use 13.3 or higher.\n", options.version);
            return;
        end
        args = matlab.utils.addArgs(options, "verbose");
        pyPath = matlab.databricks.connect.getVenvPythonPath(options.version, args{:});
    else
        args = matlab.utils.addArgs(options, ["cluster", "authMethod", "profileName" "verbose"]);
        version = getClusterVersion(args{:});
        if isempty(version)
            pyPath = string.empty;
        else
            if ~databricks.internal.databricksConnect.isDatabricksConnectv2Version(version)
                fprintf(2, "Spark version: %s does not support Databricks Connect v2, use 13.3 or higher.\n", version);
                return;
            end
            args = matlab.utils.addArgs(options, "verbose");
            pyPath = matlab.databricks.connect.getVenvPythonPath(version, args{:});
        end
    end
    
    if isempty(pyPath) || strlength(pyPath) == 0
        fprintf(2, "Could not determine a Python path. The Python environment configuration has not been changed.\n");
        return;
    end

    % Now have a Python path check if it is already in use and if not try to configure it
    try
        existingPe = pyenv(ExecutionMode="OutOfProcess");
    catch ME
        fprintf(2, "Checking default/existing pyenv failed.\n");
        fprintf(2, "Message: %s\n", ME.message);
        return;
    end

    % Return the current Pyenv if no change is to be made
    if strcmp(existingPe.Executable, pyPath)
        % No need to create a new pyenv just return existing
        if options.verbose
            fprintf("Python environment is already set to: %s\n", pyPath);
        end
        result = existingPe;
        return;
    end
    
    % Check if the pyenv can be changed
    if existingPe.ExecutionMode == matlab.pyclient.ExecutionMode.InProcess
        fprintf(2, "The current Python environment Execution mode is: InProcess.\n");
        fprintf(2, "This cannot be reconfigured dynamically, restart MATLAB to configure an alternative Python environment using:\n");
        fprintf(2, "    pyenv(Version='%s')\n", pyPath);
        fprintf(2, "For more information see: %s\n.", matlab.databricks.internal.docLink("DBConnect"));
    elseif existingPe.ExecutionMode == matlab.pyclient.ExecutionMode.OutOfProcess
        if existingPe.Status == matlab.pyclient.Status.Loaded
            try
                if options.verbose
                    fprintf("Terminating existing Python environment to change Python environment.\n");
                end
                existingPe.terminate;
                result = pyenv(Version=pyPath);
            catch ME
                fprintf(2, "Termination of existing Python environment or creation of new environment failed.\n");
                fprintf(2, "Message: %s\n", ME.message);
            end
        elseif existingPe.Status == matlab.pyclient.Status.Terminated
            try
                if options.verbose
                    fprintf("Existing Python environment terminated, creating a new environment.\n");
                end
                result = pyenv(Version=pyPath);
            catch ME
                fprintf(2, "Creation of Python environment failed.\n");
                fprintf(2, "Message: %s\n", ME.message);
            end
        elseif existingPe.Status == matlab.pyclient.Status.NotLoaded
            try
                if options.verbose
                    fprintf("Terminating an unloaded Python environment to create a new environment.\n");
                end
                existingPe.terminate;
                result = pyenv(Version=pyPath);
            catch ME
                fprintf(2, "Creation of Python environment failed.\n");
                fprintf(2, "Message: %s\n", ME.message);
            end
        else
            fprintf(2, "Unexpected Python Environment Status: %s\n.", existingPe.Status);
        end
    else
        fprintf(2, "Unexpected Python Environment ExecutionMode: %s\n.", existingPe.ExecutionMode);
    end
end


function version = getClusterVersion(options)
    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    %% The argument is a cluster object, use as is
    if isfield(options, "cluster") && isa(options.cluster, "databricks.Cluster")
        version = string(options.cluster.spark_version);
        return;
    end

    %% An Id is provided first get the object
    if isfield(options, "cluster") && (isStringScalar(options.cluster) || ischar(options.cluster))
        clusterId = string(options.cluster);
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        clusterObj = databricks.Cluster.findById(clusterId, args{:});
        if isempty(clusterObj)
            fprintf(2, "Cluster: %s, not found.\n", clusterId);
            version = string.empty;
        else
            version = string(clusterObj.spark_version);
        end
        return;
    end

    %% No object or id is provided, check cfg file
    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
    if isempty(clusterId) || strlength(clusterId) == 0
        % No cluster in options struct or cfg file
        if options.verbose
            fprintf(2, "Cluster not set in configuration file.\n");
        end
        version = string.empty;
    else
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        clusterObj = databricks.Cluster.findById(clusterId, args{:});
        if isempty(clusterObj)
            fprintf(2, "Cluster: %s, not found.\n", clusterId);
            version = string.empty;
        else
            version = string(clusterObj.spark_version);
        end
    end
end
