function poolId = cloneFromCluster(cluster, options)
    % CLONEFROMCLUSTER Creates an instance pool based on an existing cluster
    % A Databricks user may not have the rights to create an instance pool, in
    % which case this function will fail to create a pool.
    %
    % The cluster's autotermination time is applied to the pool's idleInstanceAutoterminationMinutes
    % property if set.
    %
    % The followings optional named arguments may be specified:
    %   minIdleInstances : int32, default: 1
    %        maxCapacity : int32
    %   idleInstanceAutoterminationMinutes : int32 cluster
    %               name : string, default "Cloned from cluster: <clusterId>"
    %         authMethod : matlab.databricks.AuthMethod
    %        profileName : string, default profile name
    %
    % Example:
    %   c = datarbicks.Cluster.findByName("myDesktopCluster");
    %   [poolId, errorResponse] = databricks.internal.instancepool.cloneFromCluster(c);
    %
    % Note: Unneeded pools should be removed to reduce costs.
    % Example:
    %   ip = databricks.InstancePools;
    %   [result, errorResponse] = ip.remove('0826-134312-fops10-pool-qndpush3');

    % Copyright 2025 The MathWorks, Inc.
    
    arguments
        cluster (1,1) databricks.Cluster
        options.minIdleInstances (1,1) int32 {mustBeNonnegative, mustBeFinite, mustBeReal} = 1
        options.maxCapacity (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal}
        options.idleInstanceAutoterminationMinutes (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal}
        options.name string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    errBase = "INSTANCEPOOL:CLONEFROMCLUSTER";

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    ip = databricks.InstancePools(args{:});

    cr = databricks.datastructures.instancepools.CreateRequest();

    % Reduce the chance that the cluster state is invalid
    fprintf("Updating Cluster state.");
    pause(2);
    cluster.refresh;

    if isfield(options, "name")
        cr.instancePoolName = options.name;
    else
        if isprop(cluster, "cluster_id") && ~isempty(cluster.cluster_id) && strlength(cluster.cluster_id) > 0
            cr.instancePoolName = "Cloned from cluster: " + string(cluster.cluster_id);
        else
            error(errBase+":CLUSTERID", "cluster Id not set.");
        end
    end

    if isprop(cluster, "node_type_id") && ~isempty(cluster.node_type_id) && strlength(cluster.node_type_id) > 0
        cr.nodeTypeId = string(cluster.node_type_id);
    else
        error(errBase+":NODETYPE", "cluster node type not set.");
    end
    
    if isprop(cluster, "spark_version") && ~isempty(cluster.spark_version) && strlength(cluster.spark_version) > 0
        cr.preloadedSparkVersions = string(cluster.spark_version);
    else
        error(errBase+":SPARKVERSION", "cluster spark version not set.");
    end

    if isfield(options, "minIdleInstances")
        cr.minIdleInstances = options.minIdleInstances;
    end

    if isfield(options, "maxCapacity")
        cr.maxCapacity = options.maxCapacity;
    end

    if isprop(cluster, "enable_elastic_disk") && ~isempty(cluster.enable_elastic_disk)
        cr.enableElasticDisk = cluster.enable_elastic_disk;
    end

    % Update when Cluster API support JSONMapper to remove jsonencode step
    if isprop(cluster, "azure_attributes") && ~isempty(cluster.azure_attributes)
        cr.azureAttributes = databricks.datastructures.instancepools.AzureAttributes(jsonencode(cluster.azure_attributes));
    end

    % Update when Cluster API support JSONMapper to remove jsonencode step
    if isprop(cluster, "aws_attributes") && ~isempty(cluster.aws_attributes)
        cr.awsAttributes = databricks.datastructures.instancepools.AWSAttributes(jsonencode(cluster.aws_attributes));
    end

    if isprop(cluster, "disk_spec") && ~isempty(cluster.disk_spec)
        fprintf(2, "Cloning a disk spec is not currently supported, defaults will apply.\n");
    end

    if isprop(cluster, "custom_tags") && ~isempty(cluster.custom_tags)
        tagsCell = {};
        fNames = fieldnames(cluster.custom_tags);
        for n = 1:numel(fNames)
            tagsCell{end+1} = fNames{n}; %#ok<AGROW>
            tagsCell{end+1} = cluster.custom_tags.(fNames{n}); %#ok<AGROW>
        end
        cTags = JSONMapperMap(tagsCell{:});
        cr.customTags = cTags;
    end

    % Update when Cluster API support JSONMapper to remove jsonencode step
    if isprop(cluster, "docker_image") && ~isempty(cluster.docker_image)
        cr.preloadedDockerImages = databricks.datastructures.instancepools.DockerImage(jsonencode(cluster.docker_image));
    end
    
    if isfield(options, "idleInstanceAutoterminationMinutes")
        cr.idleInstanceAutoterminationMinutes = options.idleInstanceAutoterminationMinutes;
    else
        if isprop(cluster, "autotermination_minutes") && ~isempty(cluster.autotermination_minutes)
            cr.idleInstanceAutoterminationMinutes = int32(cluster.autotermination_minutes());
        end
    end

    poolId = ip.create(cr);
end
