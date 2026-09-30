classdef Cran < JSONMapper
    % CRAN Represents a cluster Whl library
    % Specification of a CRAN library to be installed as part of the library.
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % Specification of a CRAN library to be installed as part of the library.
        package string
        repo string
    end

    methods
        function obj = Cran(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Cran
            end
            obj@JSONMapper(s, inputs);
        end
    end
end