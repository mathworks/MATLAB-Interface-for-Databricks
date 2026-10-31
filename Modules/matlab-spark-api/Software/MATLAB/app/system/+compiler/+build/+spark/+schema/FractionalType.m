classdef (Abstract) FractionalType < compiler.build.spark.schema.NumericType
    % FractionalType Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = FractionalType(~)
            obj@compiler.build.spark.schema.NumericType();
        end
    end

end
