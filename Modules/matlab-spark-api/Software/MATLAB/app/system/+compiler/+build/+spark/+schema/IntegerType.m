classdef IntegerType < compiler.build.spark.schema.IntegralType
    % IntegerType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = IntegerType(~)
            obj@compiler.build.spark.schema.IntegralType();
            obj.type = 'integer';
        end
    end

end