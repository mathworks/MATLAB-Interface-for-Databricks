function tf = isInitScriptOnAllowlist(path, options)
    % ISINITSCRIPTONALLOWLIST Checks if a given init script file is on an allowlist
    % Returns a logical.
    % A prefix match is performed on the path.
    % The check is only performed if the cluster has an accessMode/data_security_mode
    % of type "USER_ISOLATION", if not true is returned.
    % Either an access mode, cluster object or cluster Id argument is required.
    %
    % Example:
    %   tf = databricks.internal.cluster.isInitScripOnAllowlist("/Volumes/default/main/mydir/myscript.sh", clusterOrId=myCluster);
    %
    % Use of a Databricks runtime v13.3 or greater is assumed.
    %
    % See also: https://docs.databricks.com/en/init-scripts/index.html
    %           https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html

    % (c) MathWorks Inc 2024

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.accessMode (1,1) databricks.datastructures.DataSecurityMode
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if ~endsWith(lower(path), ".sh")  && options.verbose
        fprintf(2, "path argument does not have the expected .sh extension: %s\n", path);
    end

    if ~isfield(options, "accessMode") && ~isfield(options, "clusterOrId")
        error("DATABRICKS:ISINITSCRIPTONALLOWLIST", "One of the clusterOrId or accessMode named arguments must be set.");
    end

    if isfield(options, "accessMode")
        accessMode = options.accessMode;
    else
        if isa(options.clusterOrId, "databricks.Cluster")
            cluster = options.clusterOrId;
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            cluster = databricks.Cluster.findById(options.clusterOrId, args{:});
            if isempty(cluster)
                error("DATABRICKS:ISINITSCRIPTONALLOWLIST", "Cluster not found: %s", options.clusterOrId);
            end
        end
        if isprop(cluster, 'data_security_mode')
            accessMode = databricks.datastructures.DataSecurityMode(cluster.data_security_mode);
        else
            error("DATABRICKS:ISINITSCRIPTONALLOWLIST", "Cannot determine access mode. Cluster does not have a data_security_mode property.");
        end
    end

    if accessMode ~= databricks.datastructures.DataSecurityMode.USER_ISOLATION
        tf = true; % Only matter in the USER_ISOLATION case
    else
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        artifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT", args{:});
        allowlistEntry = matlab.databricks.unitycatalog.findArtifactInAllowlist(artifacts.artifact_matchers, path, "PREFIX_MATCH");
        if isempty(allowlistEntry)
            if options.verbose
                fprintf(2,"Init script: %s is not on the allowlist.\nThis is required in Shared Access Mode / USER_ISOLATION mode.\nSee: %s\n",...
                        path, matlab.utils.internal.editOrURLLink("InitScripts"));
                fprintf(2,"and: %s\n", matlab.utils.internal.editOrURLLink("Isolation"));
            end
            tf = false;
        else
            tf = true;
        end
    end
end