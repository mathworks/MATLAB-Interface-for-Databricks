classdef LongType < compiler.build.spark.data.IntegralType
    % LongType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties (Constant)
        BitWidth = 64;
    end
   
    methods
        function obj = LongType(varargin)
            obj@compiler.build.spark.data.IntegralType(varargin{:});
            obj.MATLABType = "int64";
            obj.type = "long";
        end
    end

end