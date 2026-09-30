classdef DoubleType < matlab.coder.pandas.data.FractionalType
    % DoubleType Implementation for type in Coder workflow
    %
    % Copyright 2025 The MathWorks, Inc.

    methods

        function obj = DoubleType(ciPort)
            obj = obj@matlab.coder.pandas.data.FractionalType(ciPort);
            init(obj);
        end
    end

    methods (Access=private)
        function init(obj)
            obj.PYType = "float";
            obj.PYCType = "c_double";
            obj.MLType = "double";
            obj.SparkType = "double";
            obj.NPType = "float64";
        end
    end
end