classdef Experiment < JSONMapper
    % EXPERIMENT
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        experimentId string { JSONMapper.fieldName(experimentId, "experiment_id")}
        permission databricks.datastructures.apps.ExperimentPermission { JSONMapper.fieldName(permission, "permission")}
    end

    methods
        function obj = Experiment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Experiment
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
