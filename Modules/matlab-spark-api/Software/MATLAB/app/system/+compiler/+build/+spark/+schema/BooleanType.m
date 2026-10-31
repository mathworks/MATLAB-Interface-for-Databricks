classdef BooleanType < compiler.build.spark.schema.AtomicType
    % BooleanType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = BooleanType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'boolean';
        end

    end

end