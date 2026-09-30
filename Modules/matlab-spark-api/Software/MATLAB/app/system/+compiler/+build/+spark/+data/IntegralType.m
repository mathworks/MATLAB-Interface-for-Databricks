classdef (Abstract) IntegralType < compiler.build.spark.data.NumericType
    % IntegralType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = IntegralType(varargin)
            obj@compiler.build.spark.data.NumericType(varargin{:});
            obj.PythonType = "int";
        end
        
        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.IntegralType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return int(num)\n")
            SW.unindent();

            PyW.addMethod(SW);
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.IntegralType
                val
            end

            % The base case is to just return the value
            val = feval(obj.MATLABType, val);
        end


    end

    
end