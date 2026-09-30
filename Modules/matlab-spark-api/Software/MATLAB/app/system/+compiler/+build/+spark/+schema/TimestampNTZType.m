classdef TimestampNTZType < compiler.build.spark.schema.AtomicType
    % TimestampNTZType Spark schema types

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = TimestampNTZType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'timestamp';
        end
    end

end