classdef EnvVar < JSONMapper
    % ENVVAR The environment variables to set in the app runtime environment
    % This will override the environment variables specified in the app.yaml file.
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The name of the environment variable.
        name string { JSONMapper.fieldName(name, "name")}
        % The value for the environment variable.
        % Example "/Volumes/catalog-name/schema-name/dir-name"
        value string { JSONMapper.fieldName(value, "value")}
        % The name of an external Databricks resource that contains the value, such as a secret or a database table.
        valueFrom string { JSONMapper.fieldName(valueFrom, "value_from")}
    end

    methods
        function obj = EnvVar(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.EnvVar
            end
            obj@JSONMapper(s, inputs);
        end
    end
end