classdef CreateRequest < JSONMapper
    % CREATEREQUEST Request object to create an instance pool

    % Copyright 2025 The MathWorks, Inc.

    properties
        awsAttributes databricks.datastructures.instancepools.AWSAttributes { JSONMapper.fieldName(awsAttributes, "aws_attributes") }
        azureAttributes databricks.datastructures.instancepools.AzureAttributes { JSONMapper.fieldName(azureAttributes, "azure_attributes") }
        customTags JSONMapperMap { JSONMapper.fieldName(customTags, "custom_tags") }
        diskSpec databricks.datastructures.instancepools.DiskSpec { JSONMapper.fieldName(diskSpec, "disk_spec") }
        enableElasticDisk logical { JSONMapper.fieldName(enableElasticDisk, "enable_elastic_disk") }
        idleInstanceAutoterminationMinutes int32 { JSONMapper.fieldName(idleInstanceAutoterminationMinutes, "idle_instance_autotermination_minutes") }
        instancePoolName string { JSONMapper.fieldName(instancePoolName, "instance_pool_name") }
        maxCapacity int32 { JSONMapper.fieldName(maxCapacity, "max_capacity") }
        minIdleInstances int32 { JSONMapper.fieldName(minIdleInstances, "min_idle_instances") }
        nodeTypeId string { JSONMapper.fieldName(nodeTypeId, "node_type_id") }
        preloadedDockerImages databricks.datastructures.instancepools.DockerImage { JSONMapper.fieldName(preloadedDockerImages, "preloaded_docker_images"), JSONMapper.JSONArray }
        preloadedSparkVersions string { JSONMapper.fieldName(preloadedSparkVersions, "preloaded_spark_versions"), JSONMapper.JSONArray }
    end

    methods
        function obj = CreateRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.CreateRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end