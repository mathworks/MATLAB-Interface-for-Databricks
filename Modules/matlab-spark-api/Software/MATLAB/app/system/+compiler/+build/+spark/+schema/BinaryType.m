classdef BinaryType < compiler.build.spark.schema.AtomicType
    % BinaryType Spark schema types

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = BinaryType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'binary';
        end
    end

end