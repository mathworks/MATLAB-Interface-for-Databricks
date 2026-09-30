classdef TimestampType < compiler.build.spark.schema.AtomicType
    % TimestampType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = TimestampType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'timestamp';
        end
    end

end