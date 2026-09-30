classdef Requirements < JSONMapper
    % REQUIREMENTS URI of the requirements.txt file to install.
    % Only Workspace paths and Unity Catalog Volumes paths are supported.
    %
    % Example: 
    %   "/Workspace/path/to/requirements.txt"
    %   "/Volumes/path/to/requirements.txt"
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % URI of the requirements.txt file to install.
        requirements string
    end

    methods
        function obj = Requirements(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Requirements
            end
            obj@JSONMapper(s, inputs);
        end
    end
end