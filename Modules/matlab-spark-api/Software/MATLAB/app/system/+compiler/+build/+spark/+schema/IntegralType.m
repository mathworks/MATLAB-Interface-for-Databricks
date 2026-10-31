classdef (Abstract) IntegralType < compiler.build.spark.schema.NumericType
    % IntegralType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = IntegralType(~)
            obj@compiler.build.spark.schema.NumericType();
        end
    end

end
