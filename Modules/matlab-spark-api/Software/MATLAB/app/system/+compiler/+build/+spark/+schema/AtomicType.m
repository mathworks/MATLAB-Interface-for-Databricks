classdef (Abstract) AtomicType < compiler.build.spark.schema.DataType
    % AtomicType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = AtomicType(~)
            obj@compiler.build.spark.schema.DataType();
        end
    end

end