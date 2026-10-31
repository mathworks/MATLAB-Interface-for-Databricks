function cluster = startCluster(clusterArg, options)
    % STARTCLUSTER Start an existing cluster and optionally wait for it to reach RUNNING state
    % If the waitForRunning option is enabled (default) then a RUNNING databricks.Cluster
    % should be returned. Otherwise or in the case of error an empty databricks.Cluster
    % is returned and its state should be handled upstream.
    % A timeout of 12 minutes is applied.
    %
    % Example:
    %   cluster = databricks.internal.cluster.startCluster(clusterId);

    %  Copyright 2024-2026 MathWorks, Inc.

    arguments
        clusterArg {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.waitForRunning (1,1) logical = true
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    cluster = databricks.Cluster.empty;

    if isa(clusterArg, "databricks.Cluster")
        clusterObj = clusterArg;
        clusterId = clusterObj.cluster_id;
    else
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        clusterObj = databricks.Cluster.findById(clusterArg, args{:});
        clusterId = clusterArg;
    end
    
    if isempty(clusterObj)
        fprintf(2, "Cluster: %s, not found.\n", clusterArg);
        return;
    end

    if ~isprop(clusterObj, "state")
        fprintf(2, "Cluster: %s, does not have a state property.\n", clusterArg);
        return;
    end

    initState = string(clusterObj.state);
    switch initState
        case "RUNNING"
            % Nothing to do cluster is running
            cluster = clusterObj;
        
        case {"PENDING", "RESTARTING", "RESIZING"}
            cluster = doWaiting(options, clusterId, clusterObj);

        case {"TERMINATING", "TERMINATED", "ERROR"}
            fprintf("Starting cluster: %s\n", clusterId);
            clusterObj.start;
            cluster = doWaiting(options, clusterId, clusterObj);

        case "UNKNOWN"
            fprintf(2, "Cluster in 'UNKNOWN' state\n.")
            fprintf("Attempting to start cluster: %s\n", clusterArg);
            clusterObj.start;
            cluster = doWaiting(options, clusterId, clusterObj);

        otherwise
            fprintf(2, 'Unexpected cluster: %s, state: %s\n', clusterId, initState);

    end
end


function cluster = doWaiting(options, clusterId, clusterObj)
    if options.waitForRunning
        args = {"cluster", clusterId, "timeout", 60*12, "verbose", false};
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"], args);
        databricks.internal.cluster.waitForClusterToStart(args{:});
        clusterObj.refresh;
        if strcmp(clusterObj.state, "RUNNING")
            cluster = clusterObj;
        else
            fprintf(2, "Cluster: %s, failed to start.\n", clusterId);
            cluster = databricks.Cluster.empty;
        end
     else
        fprintf(2, "Cluster: %s, not running, state: %s\n", clusterId, clusterObj.state);
        cluster = databricks.Cluster.empty;
     end
end