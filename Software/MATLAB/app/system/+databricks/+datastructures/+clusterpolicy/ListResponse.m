classdef ListResponse < JSONMapper
    % LISTRESPONSE Represents a Databricks Cluster Policy List Response
    %
    % See: https://docs.databricks.com/api/workspace/clusterpolicies/get
    %      https://docs.databricks.com/en/admin/clusters/policy-definition.html

    % Copyright 2024 The MathWorks, Inc.

    properties
        % List of policies
        policies databricks.datastructures.clusterpolicy.Policy {JSONMapper.JSONArray}
        totalCount int32 {JSONMapper.fieldName(totalCount, "total_count")}
    end

    methods
        function obj = ListResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.ListResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
