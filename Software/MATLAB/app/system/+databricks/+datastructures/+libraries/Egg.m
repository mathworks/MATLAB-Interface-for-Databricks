classdef Egg < JSONMapper
    % EGG Represents a cluster Egg library - Deprecated
    % Installing Python egg files is deprecated and is not supported in Databricks Runtime 14.0 and above.
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % Deprecated. URI of the egg library to install.
        egg string
    end


    methods
        function obj = Egg(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Egg
            end
            obj@JSONMapper(s, inputs);
        end
    end
end