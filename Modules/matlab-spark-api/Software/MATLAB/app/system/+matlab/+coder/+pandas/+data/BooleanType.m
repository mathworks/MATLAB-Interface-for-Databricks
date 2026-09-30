classdef BooleanType < matlab.coder.pandas.data.DataType
    % BooleanType Implementation for type in Coder workflow
    %
    % Copyright 2025 The MathWorks, Inc.

    methods

        function obj = BooleanType(ciPort)
            obj = obj@matlab.coder.pandas.data.DataType(ciPort);
            init(obj);
        end

        function funcName = genPythonExampleFunction(obj, sw)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) matlab.coder.pandas.data.BooleanType
                sw (1,1) matlab.sparkutils.StringWriter
            end

            funcName = sprintf("%s_ex", obj.colName);
            sw.pf("def %s(num):\n", funcName);
            sw.indent();
            sw.pf('"""Example code for C type %s, column %s."""\n', obj.PYCType, obj.colName);
            sw.pf("return num %% 2 == 0\n")
            sw.unindent();
            sw.pf("\n");
        end

    end

    methods (Access=private)
        function init(obj)
            obj.PYType = "bool";
            obj.PYCType = "c_bool";
            obj.MLType = "logical";
            obj.SparkType = "boolean";
            obj.NPType = "bool";
        end
    end
end