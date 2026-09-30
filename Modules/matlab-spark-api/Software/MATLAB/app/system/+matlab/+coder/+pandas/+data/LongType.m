classdef LongType < matlab.coder.pandas.data.IntegralType
    % LongType Implementation for type in Coder workflow
    %
    % Copyright 2025 The MathWorks, Inc.

    methods

        function obj = LongType(ciPort)
            obj = obj@matlab.coder.pandas.data.IntegralType(ciPort);
            init(obj);
        end
    end

    methods (Access=private)
        function init(obj)
            obj.PYType = "int";
            obj.PYCType = "c_int64";
            obj.MLType = "int64";
            obj.SparkType = "long";
            obj.NPType = "int64";
        end
    end
end