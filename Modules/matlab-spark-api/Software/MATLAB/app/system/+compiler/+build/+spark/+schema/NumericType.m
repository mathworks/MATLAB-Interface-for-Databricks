classdef (Abstract) NumericType < compiler.build.spark.schema.AtomicType
    % NumericType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = NumericType(~)
            obj@compiler.build.spark.schema.AtomicType();
        end
    end

end
