classdef DockerImage < JSONMapper
    % DOCKERIMAGE Docker image connection information

    % Copyright 2025 The MathWorks, Inc.

    properties
        url string { JSONMapper.fieldName(url, "url") }
        basicAuth databricks.datastructures.instancepools.DockerBasicAuth { JSONMapper.fieldName(basicAuth, "basic_auth") }
    end

    methods
        function obj = DockerImage(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.DockerImage
            end
            obj@JSONMapper(s, inputs);
        end
    end
end