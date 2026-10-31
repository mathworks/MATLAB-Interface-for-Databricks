classdef (Abstract) FractionalType < compiler.build.spark.data.NumericType
    % FractionalType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = FractionalType(varargin)
            obj@compiler.build.spark.data.NumericType(varargin{:});
            obj.PythonType = "float";
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.FractionalType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return float(num)\n")
            SW.unindent();

            PyW.addMethod(SW);
        end

    end

end