classdef ShortType < compiler.build.spark.data.IntegralType
    % ShortType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties (Constant)
        BitWidth = 16;
    end

    methods
        function obj = ShortType(varargin)
            obj@compiler.build.spark.data.IntegralType(varargin{:});
            obj.MATLABType = "int16";
            obj.type = "short";
        end
    end

end