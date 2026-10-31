classdef DateType < compiler.build.spark.schema.AtomicType
    % DateType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = DateType(~)
            obj@compiler.build.spark.schema.AtomicType();
            obj.type = 'date';
        end
    end

end