function result = setPyenvForCluster(options)
    % SETPYENVFORCLUSTER Set a pyenv based on the Spark version of a cluster
    % In the case of an error an empty double is returned.
    % If successful a matlab.pyclient.PythonEnvironment is returned, this
    % should be checked before use.
    %
    % If a Software/MATLAB/Connect/<Spark version> directory exists it will
    % be used, if a configured venv exists therein.
    %
    % If an exact major.minor match is not found the latest major number match
    % will be used if that exists.
    %
    % The cluster can be provided as a clusterId string/character vector or
    % as a databricks.Cluster object. If a cluster value is not provided
    % the value in the .databrickscfg file will be used if set.
    %
    % Example:
    %   result = matlab.databricks.cluster.setPyenvForCluster(cluster="1006-200022-cv9r8lwc")
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
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.pythonPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    args = matlab.utils.addArgs(options, ["cluster", "pythonPath", "profileName", "authMethod", "verbose"]);
    result = matlab.databricks.connect.setPyenv(args{:});

    runningRelease = matlabRelease().Release;

    args = matlab.utils.addArgs(options, ["profileName", "authMethod", "verbose", "cluster"]);
    clusterRelease = matlab.databricks.cluster.getClusterMATLABRelease(args{:});

    if isempty(clusterRelease)
        if options.verbose
            fprintf("\nThe MW_RUNTIME_RELEASE environment variable is not set on cluster: %s\n", clusterId);
            fprintf("As of v5.x this indicates the MATLAB runtime is not installed on that cluster.\n");
            fprintf("A cluster requires the MATLAB runtime to execute compiled MATLAB code.\n");
            fprintf("However, Databricks Connect does not require a MATLAB runtime, unless using UDFs.\n\n");
        end
    else
        if ~strcmp(runningRelease, clusterRelease)
            if options.verbose
                fprintf("\nThe cluster: %s, supports the MATLAB runtime release: %s\n", clusterId, clusterRelease);
                fprintf("Therefore it cannot execute MATLAB code compiled with this release: %s\n", runningRelease);
                fprintf("However, Databricks Connect does not require a matching MATLAB runtime unless using UDFs.\n\n");
            end
        end
    end
end
