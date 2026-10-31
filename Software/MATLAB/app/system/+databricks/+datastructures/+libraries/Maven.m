classdef Maven < JSONMapper
    % MAVEN Represents a cluster Jar library
    % Specification of a maven library to be installed.
    %
    % Example:
    %  "org.jsoup:jsoup:1.7.2"
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % Specification of a maven library to be installed.
        coordinates string
        exclusions string {JSONMapper.JSONArray}
        repo string
    end


    methods
        function obj = Maven(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Maven
            end
            obj@JSONMapper(s, inputs);
        end
    end
end