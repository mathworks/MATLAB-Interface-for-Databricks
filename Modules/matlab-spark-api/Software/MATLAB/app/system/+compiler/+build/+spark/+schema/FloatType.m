classdef FloatType < compiler.build.spark.schema.FractionalType
    % FloatType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = FloatType(~)
            obj@compiler.build.spark.schema.FractionalType();
            obj.type = 'float';
        end
    end

end