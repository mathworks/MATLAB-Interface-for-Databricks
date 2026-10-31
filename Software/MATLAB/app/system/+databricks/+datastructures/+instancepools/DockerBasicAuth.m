classdef DockerBasicAuth < JSONMapper
    % DOCKERBASICAUTH Container registry basic authentication information

    % Copyright 2025 The MathWorks, Inc.

    properties
        username string { JSONMapper.fieldName(username, "username") }
        password string { JSONMapper.fieldName(password, "password") }
    end

    methods
        function obj = DockerBasicAuth(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.DockerBasicAuth
            end
            obj@JSONMapper(s, inputs);
        end
    end
end