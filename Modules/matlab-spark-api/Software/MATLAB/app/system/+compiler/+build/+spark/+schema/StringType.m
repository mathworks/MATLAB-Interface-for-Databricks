classdef StringType < compiler.build.spark.schema.AtomicType
    % StringType Spark schema types

    % Copyright 2024-2025 The MathWorks, Inc.

    methods
        function obj = StringType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'string';
        end

    end

end