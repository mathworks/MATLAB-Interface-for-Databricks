function tf = isLibrarySupported(path, options)
    % ISLIBRARYSUPPORTED Checks of if a Cluster scoped Library is supported
    % Checks .jar and .whl paths only, returns true otherwise.
    % The destination path should be the full path including the library filename.
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
    %   tf = databricks.internal.cluster.isLibrarySupported("/Volumes/default/main/mydir/mylib.whl", clusterOrId=myCluster)
    %
    % See also: https://docs.databricks.com/en/libraries/index.html

    % (c) MathWorks Inc 2024

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.accessMode (1,1) databricks.datastructures.DataSecurityMode
        options.sparkVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.libraryType string {mustBeTextScalar, mustBeNonzeroLengthText, mustBeMember(options.libraryType, {'jar', 'whl'})}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    % Assume the library is supported
    tf = true;

    dbDocURL = matlab.utils.URL2Link("https://docs.databricks.com/en/libraries/index.html");

    % Check the library type
    if isfield(options, "libraryType")
        libraryType = options.libraryType;
    else
        libraryType = getLibraryType(path);
    end
    if strcmp(libraryType, "unsupported")
        error("DATABRICKS:ISLIBRARYSUPPORTED", "Library type not supported for path: %s\nSee libraryType argument to explicitly set a type.\n", path);
    end

    % Check version, access mode & id
    if ~isfield(options, "clusterOrId")
        if isfield(options, "accessMode")
            accessMode = options.accessMode;
        else
            error("DATABRICKS:ISLIBRARYSUPPORTED",...
                "If a clusterId or cluster object is not provided as a named argument then the accessMode named argument must be provided.")
        end
        if isfield(options, "sparkVersion")
            sparkVersion = databricks.internal.cluster.getSparkBaseVersion(options.sparkVersion);
        else
            error("DATABRICKS:ISLIBRARYSUPPORTED",...
                "If a clusterId or cluster object is not provided as a named argument then the sparkVersion named argument must be provided.")
        end
    else
        if isa(options.clusterOrId, "databricks.Cluster")
            cluster = options.clusterOrId;
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            cluster = databricks.Cluster.findById(options.clusterOrId, args{:});
            if isempty(cluster)
                error("DATABRICKS:ISLIBRARYSUPPORTED", "Cluster not found: %s", options.clusterOrId);
            end
        end
        if isprop(cluster, "data_security_mode")
            accessMode = databricks.datastructures.DataSecurityMode(cluster.data_security_mode);
        else
            error("DATABRICKS:ISLIBRARYSUPPORTED",...
                "Cluster does not have a data_security_mode property as required to set the access mode.");
        end
        if isprop(cluster, "spark_version")
            sparkVersion = databricks.internal.cluster.getSparkBaseVersion(cluster.spark_version);
        else
            error("DATABRICKS:ISLIBRARYSUPPORTED",...
                "Cluster does not have a spark_version property as required to set the Spark version.");
        end
    end

    % Get base version as a SemVer object
    semSparkVersion = matlab.utils.SemVer(sparkVersion);

    % 13.3 is a minimum requirement for the package
    if semSparkVersion.lt("13.3")
        if options.verbose
            fprintf(2, "Spark versions less than 13.3 are not supported.\n");
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
    if startsWith(path, "file:")
        if options.verbose
            fprintf(2, 'Library uses a "file:" path, skipping checks and assuming it is supported.\n');
        end
        tf = true;
        return;
    end

    pathType = databricks.internal.io.IO.getType(path);
    if isempty(pathType)
        if options.verbose
            fprintf(2, "Library uses an unexpected path type: %s\nSkipping checks and assuming it is supported.\n", path);
        end
        tf = true;
        return;
    end

    if strcmp(libraryType, "jar")
        % Java/Scala library support
        switch pathType
            case "VOLUMES"
                if accessMode == "NONE"
                    failMessage('"No isolation shared access mode" clusters do not support volume hosted .jar libraries', dbDocURL, options.verbose);
                    tf = false;
                end

            case "DBFS"
                if accessMode == "USER_ISOLATION"
                    failMessage('"Shared access mode" clusters do not support DBFS hosted .jar libraries', dbDocURL, options.verbose);
                    tf = false;
                end
                if semSparkVersion.gt("14.3")
                    failMessage('"Single user access mode" & "Shared access mode" clusters do not support DBFS hosted .jar libraries for versions greater than 14.3', dbDocURL, options.verbose);
                    tf = false;
                end

            case "WORKSPACE"
                if accessMode == "USER_ISOLATION"
                    failMessage('"Shared access mode" clusters do not support workspace hosted .jar libraries', dbDocURL, options.verbose);
                    tf = false;
                end
                if accessMode == "SINGLE_USER"
                    failMessage('"Single user access mode" clusters do not support workspace hosted .jar libraries', dbDocURL, options.verbose);
                    tf = false;
                end
                if accessMode == "NONE" && semSparkVersion.lt("14.1")
                    failMessage('"No isolation shared access mode" clusters do not support workspace hosted .jar libraries for versions less than 14.1', dbDocURL, options.verbose);
                    tf = false;
                end

            otherwise
                % All other path types are supported
        end
    elseif strcmp(libraryType, "whl")
        % Python library support
        switch pathType
            case "VOLUMES"
                if accessMode == "NONE"
                    failMessage('"No isolation shared access mode" clusters do not support volume hosted .whl libraries', dbDocURL, options.verbose);
                    tf = false;
                end

            case "DBFS"
                if accessMode == "USER_ISOLATION"
                    failMessage('"Shared access mode" clusters do not support DBFS hosted .whl libraries', dbDocURL, options.verbose);
                    tf = false;
                end
                if semSparkVersion.gt("14.3")
                    failMessage('"Single user access mode" & "Shared access mode" clusters do not support DBFS hosted .whl libraries for versions greater than 14.3', dbDocURL, options.verbose);
                    tf = false;
                end

            case "WORKSPACE"
                if accessMode == "NONE" && semSparkVersion.lt("14.1")
                    failMessage('"No isolation shared access mode" clusters do not support workspace hosted .whl libraries for versions less than 14.1', dbDocURL, options.verbose);
                    tf = false;
                end

            otherwise
                % All other path types are supported
        end
    else
        % Assume other library types are supported
        if options.verbose
            fprintf(2, "Checking of Library type is not supported for path: %s\nSee libraryType argument to explicitly set a type.\n", path);
        end
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


function type = getLibraryType(path)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    lowerPath = lower(path);

    if endsWith(lowerPath, ".jar")
        type = "jar";
    elseif endsWith(lowerPath, ".whl")
        type = "whl";
    else
        type = "unsupported";
    end
end
