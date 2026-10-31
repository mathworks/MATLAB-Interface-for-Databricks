classdef IntegerType < compiler.build.spark.data.IntegralType
    % IntegerType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.


    properties (Constant)
        BitWidth =  32;
    end
    
    methods
        function obj = IntegerType(varargin)
            obj@compiler.build.spark.data.IntegralType(varargin{:});
            obj.MATLABType = "int32";
            obj.type = "integer";
        end

    end

end