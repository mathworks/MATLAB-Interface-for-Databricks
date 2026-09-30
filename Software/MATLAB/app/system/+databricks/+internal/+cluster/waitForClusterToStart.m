function waitForClusterToStart(options)
    % waitForClusterToStart Wait for a cluster to go to a RUNNING state
    %   Returns if already RUNNING.
    %   Waits if PENDING, RESTARTING, RESIZING or UNKNOWN.
    %   Errors if TERMINATING, TERMINATED ERROR or otherwise.
    %
    %  Optional arguments:
    %       cluster: Cluster Id or CLuster object, otherwise credentials are used if available
    %       timeout: Errors if timeout is exceeded, default 12 minutes, specified and an int32 seconds value
    %    authMethod: A matlab.databricks.AuthMethod
    %   profileName: A configuration file profileName value
    %       verbose: Logical to enable additional logging, default false
    %
    % Example:
    %   databricks.internal.cluster.waitForClusterToStart(cluster=clusterId)

    %  Copyright 2022-2026 MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 60*12
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = false
    end

    errBase = "DATABRICKS:WAITFORCLUSTERTOSTART";

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if isfield(options, "cluster")
        [clusterId, clusterObj] = databricks.internal.cluster.getClusterIdFromClusterOrId(options.cluster, args{:});
    else
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
        if isempty(clusterId) || strlength(clusterId) == 0
            error(errBase+":CLUSTERID1", ...
                "cluster_id not set is arguments or profile: %s, use: updateClusterId('cluster-id-value')", ...
                options.profileName);
        else
            [clusterId, clusterObj] = databricks.internal.cluster.getClusterIdFromClusterOrId(clusterId, args{:});
        end
    end

    if ~strlength(clusterId) > 0
        error(errBase + ":CLUSTERID2",...
         "Cluster ID value is not defined. It must be provided either as an argument or via credentials as an environment variable or the .databrickscfg file.");
    end

    if isempty(clusterObj)
        error(errBase + ":CLUSTERNOTFOUND", 'Cluster not found: %s', clusterId);
    end

    % Increase chance that clusterObj is populated with state
    pause(1);
    clusterObj.refresh;

    if ~isprop(clusterObj, 'state') || isempty(clusterObj.state)
        error(errBase + ":NOSTATE", 'Cluster not found: %s', clusterId);
    end

    % If already running just return
    if upper(clusterObj.state) == "RUNNING"
        return;
    end

    startTime = datetime("now");
    counter = 0;
    while startTime <= datetime("now") + seconds(options.timeout)
        switch upper(clusterObj.state)
            case "RUNNING"
                if options.verbose && counter > 0
                    fprintf("\n"); % Truncate the ......
                end
                return;

            case {"PENDING", "RESTARTING", "RESIZING"}
                % Do nothing go around the while again
                
            case {"TERMINATING", "TERMINATED", "ERROR"}
                if options.verbose && counter > 0
                    fprintf("\n"); % Truncate the ......
                end
                error(errBase + ":TERM", ...
                    "Cluster: %s, in a state from which it will not run without being started/restarted: %s", clusterId, clusterObj.state);
                
            case "UNKNOWN"
                if options.verbose
                    fprintf('\n#%03d %s %d %s %s %s\n', counter, startTime, options.timeout, clusterObj.cluster_name, clusterId, clusterObj.state);
                end
                
            otherwise
                error(errBase + ":STATEOTHER", '\nUnexpected cluster: %s, state: %s', clusterId, clusterObj.state);
        end
        
        if options.verbose
            if counter > 0 && rem(counter, 40)==0
                fprintf("\n");
            end
            fprintf(".");
        end
        counter = counter + 1;
        pause(5);
        clusterObj.refresh();
    end

    % Can only get here if the timeout elapsed
    error(errBase + ":TIMEOUT", 'Exceeded timeout (%ds), for cluster: %s', options.timeout, clusterId);
end

