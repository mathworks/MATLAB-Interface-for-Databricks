classdef ArtifactMatchers < JSONMapper
    % ArtifactMatchers Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ArtifactMatchers Properties:
    %   artifact - The artifact path or maven coordinate
    %   match_type - The pattern matching type of the artifact

    % Copyright 2023 The MathWorks, Inc.

    properties
        % The artifact path or maven coordinate
        artifact string
        % The pattern matching type of the artifact
        match_type string
    end

    methods
        function obj = ArtifactMatchers(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ArtifactMatchers
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
                fields.?databricks.datastructures.unitycatalog.ArtifactMatchers
            end
            obj = databricks.datastructures.unitycatalog.ArtifactMatchers;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end