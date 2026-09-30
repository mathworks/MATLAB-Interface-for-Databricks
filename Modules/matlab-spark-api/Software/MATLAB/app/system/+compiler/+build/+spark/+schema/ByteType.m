classdef ByteType < compiler.build.spark.schema.IntegralType
    % ByteType Spark schema types

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = ByteType(~)
            obj@compiler.build.spark.schema.IntegralType();
            obj.type = 'byte';
        end
    end

end