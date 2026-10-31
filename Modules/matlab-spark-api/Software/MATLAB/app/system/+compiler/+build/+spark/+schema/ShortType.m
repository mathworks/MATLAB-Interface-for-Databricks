classdef ShortType < compiler.build.spark.schema.IntegralType
    % ShortType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = ShortType(~)
            obj@compiler.build.spark.schema.IntegralType();
            obj.type = 'short';
        end
    end

end