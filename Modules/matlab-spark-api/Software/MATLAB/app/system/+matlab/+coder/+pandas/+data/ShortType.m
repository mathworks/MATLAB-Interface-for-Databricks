classdef ShortType < matlab.coder.pandas.data.IntegralType
    % ShortType Implementation for type in Coder workflow
    %
    % Copyright 2025 The MathWorks, Inc.

    methods

        function obj = ShortType(ciPort)
            obj = obj@matlab.coder.pandas.data.IntegralType(ciPort);
            init(obj);
        end

        function funcName = genPythonExampleFunction(obj, sw)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) matlab.coder.pandas.data.ShortType
                sw (1,1) matlab.sparkutils.StringWriter
            end

            funcName = sprintf("%s_ex", obj.colName);
            sw.pf("def %s(num):\n", funcName);
            sw.indent();
            sw.pf('"""Example code for C type %s, column %s."""\n', obj.PYCType, obj.colName);
            sw.pf("return %s( num %% %d)\n", obj.PYType, intmax(obj.MLType));
            sw.unindent();
            sw.pf("\n");

        end

    end

    methods (Access=private)
        function init(obj)
            obj.PYType = "int";
            obj.PYCType = "c_int16";
            obj.MLType = "int16";
            obj.SparkType = "short";
            obj.NPType = "int16";
        end
    end
end