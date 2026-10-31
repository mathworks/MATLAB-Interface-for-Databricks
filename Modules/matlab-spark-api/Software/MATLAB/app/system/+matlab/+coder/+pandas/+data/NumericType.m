classdef (Abstract) NumericType < matlab.coder.pandas.data.AtomicType
    % NumericType Implementation for types in Coder workflow

    % Copyright 2025 The MathWorks, Inc.

    methods
        function funcName = genPythonExampleFunction(obj, sw)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) matlab.coder.pandas.data.NumericType
                sw (1,1) matlab.sparkutils.StringWriter
            end

            funcName = sprintf("%s_ex", obj.colName);
            sw.pf("def %s(num):\n", funcName);
            sw.indent();
            sw.pf('"""Example code for C type %s, column %s."""\n', obj.PYCType, obj.colName);
            sw.pf("return %s(num)\n", obj.PYType)
            sw.unindent();
            sw.pf("\n");

        end
    end
end