classdef DoubleType < compiler.build.spark.schema.FractionalType
    % DoubleType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = DoubleType(~)
            obj@compiler.build.spark.schema.FractionalType();
            obj.type = 'double';
        end
    end

end