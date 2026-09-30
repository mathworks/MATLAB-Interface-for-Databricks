classdef GetMyGroupsResp < JSONMapper
    % GetMyGroupsResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.GetMyGroupsResp Properties:
    %   group_names - List of group names

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of group names
        group_names string {JSONMapper.JSONArray}
    end

    methods
        function obj = GetMyGroupsResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.GetMyGroupsResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end