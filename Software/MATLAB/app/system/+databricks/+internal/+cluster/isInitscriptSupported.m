function tf = isInitscriptSupported(path, options)
    % ISINITSCRIPTSUPPORTED Checks of if a cluster scoped init script is supported
    % The destination path should be the full path including the init script filename.
    % Returns a logical.
    % This function errs on the side of returning true when specific
    % failure modes are not known.
    %
    % Access mode and databricks.datastructures.DataSecurityMode correspondence:
    %
    %   Shared access mode = USER_ISOLATION
    %   Single user access mode = SINGLE_USER
    %   No isolation shared access mode (Legacy) = NONE
    %
    % Use of a Databricks runtime v13.3 or greater is assumed.
    %
    % Example:
    %   tf = databricks.internal.cluster.isInitscriptSupported("/Volumes/default/main/mydir/myInitscript.sh", clusterOrId=myCluster)
    %
    % See also: https://docs.databricks.com/en/init-scripts/index.html
    %           https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html

    % (c) MathWorks Inc 2024-2026

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.accessMode (1,1) databricks.datastructures.DataSecurityMode
        options.sparkVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if ~endsWith(lower(path), ".sh") && options.verbose
        fprintf(2, "path argument does not have the expected .sh extension: %s\n", path);
    end

    % Assume the initscript is supported
    tf = true;

    dbDocURL = matlab.utils.URL2Link("https://docs.databricks.com/en/init-scripts/index.html");

     % Check version, access mode & id
    if ~isfield(options, "clusterOrId")
        if isfield(options, "accessMode")
            accessMode = options.accessMode;
        else
            error("DATABRICKS:ISINITSCRIPTSUPPORTED",...
                "If a clusterId or cluster object is not provided as a named argument then the accessMode named argument must be provided.")
        end
        if isfield(options, "sparkVersion")
            sparkVersion = databricks.internal.cluster.getSparkBaseVersion(options.sparkVersion);
        else
            error("DATABRICKS:ISINITSCRIPTSUPPORTED",...
                "If a clusterId or cluster object is not provided as a named argument then the sparkVersion named argument must be provided.")
        end
    else
        if isa(options.clusterOrId, "databricks.Cluster")
            cluster = options.clusterOrId;
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            cluster = databricks.Cluster.findById(options.clusterOrId, args{:});
            if isempty(cluster)
                error("DATABRICKS:ISINITSCRIPTSUPPORTED", "Cluster not found: %s", options.clusterOrId);
            end
        end
        if isprop(cluster, "data_security_mode")
            accessMode = databricks.datastructures.DataSecurityMode(cluster.data_security_mode);
        else
            error("DATABRICKS:ISINITSCRIPTSUPPORTED",...
                "Cluster does not have a data_security_mode property as required to set the access mode.");
        end
        if isprop(cluster, "spark_version")
            sparkVersion = databricks.internal.cluster.getSparkBaseVersion(cluster.spark_version);
        else
            error("DATABRICKS:ISINITSCRIPTSUPPORTED",...
                "Cluster does not have a spark_version property as required to set the Spark version.");
        end
    end

    % Get base version as a SemVer object
    semSparkVersion = matlab.utils.SemVer(sparkVersion);

    % 13.3 is a minimum requirement for the package
    if semSparkVersion.lt("13.3")
        if options.verbose
            fprintf(2, "Init Script use with Spark versions less than 13.3 is not supported.\n");
        end
        tf = false;
        return;
    end

    if semSparkVersion.ge("17")
        if options.verbose
            fprintf(2, "Init Script use with Spark versions 17 or greater is not supported.\n");
        end
        tf = false;
        return;
    end

    % If LEGACY_ don't check it may or may not work
    if ~(accessMode=="NONE" || accessMode=="SINGLE_USER" || accessMode=="USER_ISOLATION")
        if options.verbose
            fprintf(2, "Access Mode is set to a legacy type: %s\nSkipping checks and assuming support.\nSee: %s\n",accessMode, dbDocURL);
        end
        tf = true;
        return;
    end

    % Check for file: path and skip checks, it may or may not work
    % file: is not supported by databricks.internal.io.IO.getType, so check first
    if startsWith(path, "file:")
        if options.verbose
            failMessage('Init scripts are not supported on "file:" paths', dbDocURL, options.verbose);
        end
        tf = false;
        return;
    end

    pathType = databricks.internal.io.IO.getType(path);
    if isempty(pathType)
        if options.verbose
            fprintf(2, "Init script uses an unexpected path type: %s\nSkipping checks and assuming it is supported.\n", path);
        end
        tf = true;
        return;
    end

    % Java/Scala library support
    switch pathType
        case "WORKSPACE"
            if accessMode == "USER_ISOLATION"
                failMessage('"Shared access mode" clusters do not support workspace hosted init scripts', dbDocURL, options.verbose);
                tf = false;
            end

        case "VOLUMES"
            if accessMode == "NONE"
                failMessage('"No isolation shared access mode" clusters do not support volume hosted init scripts', dbDocURL, options.verbose);
                tf = false;
            end

        case "DBFS"
            failMessage('DBFS hosted init scripts are not supported', dbDocURL, options.verbose);
            tf = false;
        otherwise
            % All other path types are supported
    end
end


function failMessage(msg, dbDocURL, verbose)
    arguments
        msg string {mustBeTextScalar, mustBeNonzeroLengthText}
        dbDocURL string {mustBeTextScalar, mustBeNonzeroLengthText}
        verbose (1,1) logical = true
    end

    if verbose
        if isempty(dbDocURL) || strlength(dbDocURL) == 0
            fprintf(2, "%s\n", msg);
        else
            fprintf(2, "%s.\nSee: %s\n", msg, dbDocURL);
        end
    end
end
