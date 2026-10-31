classdef FloatType < matlab.coder.pandas.data.FractionalType
    % FloatType Implementation for type in Coder workflow
    %
    % Copyright 2025 The MathWorks, Inc.

    methods

        function obj = FloatType(ciPort)
            obj = obj@matlab.coder.pandas.data.FractionalType(ciPort);
            init(obj);
        end
    end

    methods (Access=private)
        function init(obj)
            obj.PYType = "float";
            obj.PYCType = "c_float";
            obj.MLType = "single";
            obj.SparkType = "float";
            obj.NPType = "float32"            ;
        end
    end
end