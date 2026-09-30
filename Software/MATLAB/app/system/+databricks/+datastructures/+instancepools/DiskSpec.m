classdef DiskSpec < JSONMapper
    % DISKSPEC Defines the specification of the disks that will be attached to all spark containers

    % Copyright 2025 The MathWorks, Inc.

    properties
        diskCount int32 { JSONMapper.fieldName(diskCount, "disk_count") } = 1
        diskIOPs int32 { JSONMapper.fieldName(diskIOPs, "disk_iops") }
        diskSize int32 { JSONMapper.fieldName(diskSize, "disk_size") }
        diskThroughput int32 { JSONMapper.fieldName(diskThroughput, "disk_throughput") }
        diskType { JSONMapper.fieldName(diskType, "disk_type") }
    end

    methods
        function obj = DiskSpec(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.DiskSpec
            end
            obj@JSONMapper(s, inputs);
        end
    end
end