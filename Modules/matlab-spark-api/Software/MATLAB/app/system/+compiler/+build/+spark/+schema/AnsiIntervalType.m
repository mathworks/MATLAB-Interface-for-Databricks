classdef (Abstract) AnsiIntervalType < compiler.build.spark.schema.AtomicType
    % AnsiIntervalType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = AnsiIntervalType(~)
            obj@compiler.build.spark.schema.AtomicType();
        end
    end

end
