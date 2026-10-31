classdef LongType < compiler.build.spark.schema.IntegralType
    % LongType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = LongType(~)
            obj@compiler.build.spark.schema.IntegralType();
            obj.type = 'long';
        end

        function str = pythonSchemaType(~)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            str = "bigint";
        end
    end

end