function downloadLogs(options)
    % DOWNLOADLOGS Helper function to download certain log files
    %
    % This is a function for internal use, but may be useful as a tool
    % while debugging outputs of a specific run.
    %
    % This function will download logs recursively from the current cluster
    % in the settings file, and save it to a local folder with
    % the same name as the cluster_id.
    % To save time, it will ignore all gzipped files.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %   databricks.internal.cluster.downloadLogs()

    % Copyright 2022-2024, The MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if ~isfield(options, "cluster")
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        cluster = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
        if isempty(cluster) || strlength(cluster) == 0
            % No cluster in options struct or cfg file
            if options.verbose
                fprintf(2, "Cluster not set in configuration file.\n");
            end
            return;
        end
    else
        cluster = options.cluster;
    end

    if isa(cluster, "databricks.Cluster")
        if ~isprop(cluster, "cluster_id")
            if options.verbose
                fprintf(2, "Cluster does not have a cluster_id property.\n");
            end
            return;
        end
        clusterId = string(cluster.cluster_id);
    else
        clusterId = string(cluster);
    end

    if isempty(clusterId) || strlength(clusterId) == 0
        if options.verbose
            fprintf(2, "Cluster Id value not set.\n");
        end
        return;
    end

    if isa(cluster, "databricks.Cluster")
        clusterObj = cluster;
    else
        args = matlab.utils.addArgs(options, ["profileName", "authMethod"]);
        clusterObj = databricks.Cluster.findById(clusterId, args{:});
        if isempty(clusterObj)
            if options.verbose
                fprintf(2, "Cluster: %s not found.\n", clusterId);
            end
            return;
        end
    end
   
    if ~isprop(clusterObj, "cluster_log_conf")
        if options.verbose
            fprintf(2, "cluster_log_conf property not found.\n");
        end
        return;
    end

    % Logs only supported on DBFS currently
    if ~isfield(clusterObj.cluster_log_conf, "dbfs")
        if options.verbose
            fprintf(2, "cluster_log_conf.dbfs field not found.\n");
        end
        return;
    end
    if ~isfield(clusterObj.cluster_log_conf.dbfs, "destination")
        if options.verbose
            fprintf(2, "cluster_log_conf.dbfs.destination field not found.\n");
        end
        return;
    end

    logBase = strrep(clusterObj.cluster_log_conf.dbfs.destination, 'dbfs:', '');

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    db = databricks.DBFS(args{:});
    dlRec(logBase, clusterId, db);
end


function dlRec(logBase, curFolder, db)
    goBack = goDown(curFolder); %#ok<NASGU> 

    logBase = strcat(logBase, '/', curFolder);
    fprintf('Checking %s\n', logBase);
    files = db.listFiles(logBase);

    for k=1:length(files)
        F = files(k);
        Fname = getName(F.path);
        if F.is_dir
            dlRec(logBase, Fname, db);
        else
            if endsWith(F.path, '.gz')
                % Go to next
                continue;
            end
            fprintf('     Downloading %s\n', F.path);
            db.download(F.path);
        end
    end
end


function name = getName(fullName)
    toks = split(string(fullName), '/');
    name = toks(end);
end


function goBack = goDown(dirName)
    if ~isfolder(dirName)
        mkdir(dirName);
    end
    oldDir = cd(dirName);
    goBack = onCleanup(@() cd(oldDir));
end