classdef Job < JSONMapper
    % Job
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        id string { JSONMapper.fieldName(id, "id")}
        permission databricks.datastructures.apps.JobPermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = Job(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Job
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
