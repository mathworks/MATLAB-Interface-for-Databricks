classdef ByteType < compiler.build.spark.data.IntegralType
    % ByteType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    properties (Constant)
        BitWidth = 8;
    end

    methods
        function obj = ByteType(varargin)
            obj@compiler.build.spark.data.IntegralType(varargin{:});
            obj.MATLABType = "int8";
            obj.type = "byte";
        end
    end

end