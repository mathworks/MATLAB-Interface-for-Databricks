classdef AllowlistRequest < JSONMapper
    % AllowlistRequest Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.AllowlistRequest Properties:
    %   artifact_matchers - The artifact matchers array

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        % The artifact path or maven coordinate
        artifact_matchers databricks.datastructures.unitycatalog.ArtifactMatchers {JSONMapper.JSONArray}
    end

    methods
        function obj = AllowlistRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AllowlistRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods (Static)
        function obj = fromInputs(fields)
            % FROMINPUTS creates an instance of the class with specific
            % properties set to specific values. For each property that is
            % to be set, provide the property name and desired value as 
            % Name-Value pairs.
            arguments
                fields.?databricks.datastructures.unitycatalog.AllowlistRequest
            end
            obj = databricks.datastructures.unitycatalog.AllowlistRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end