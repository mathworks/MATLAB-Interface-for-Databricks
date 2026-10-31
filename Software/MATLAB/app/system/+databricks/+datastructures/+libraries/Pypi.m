classdef Pypi < JSONMapper
    % PYPI Represents a cluster Jar library
    % Specification of a PyPi library to be installed.
    % 
    % Example: 
    %   "simplejson"
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % Specification of a PyPi library to be installed.
        package string
        repo string
    end


    methods
        function obj = Pypi(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Pypi
            end
            obj@JSONMapper(s, inputs);
        end
    end
end