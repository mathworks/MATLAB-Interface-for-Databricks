classdef BooleanType < compiler.build.spark.data.AtomicType
    % BooleanType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = BooleanType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
            obj.MATLABType = "logical";
            obj.PythonType = "bool";
            obj.type = "boolean";
        end

        function str = PandasSeriesType(obj)
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
            end
            str = obj.PythonType;
        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType %#ok<INUSA> 
                num (1,1) double       %#ok<INUSA>
                count (1,1) double = 3 %#ok<INUSA>
            end
            val = rem(num, 2);
            if val
                ret = "True";
            else
                ret = "False";
            end
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return bool(num%%2)\n")
            SW.unindent();

            PyW.addMethod(SW);
        end


        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
                codeIn (1,1) string
            end

            convFunc = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            codeOut = sprintf("%s = %s(%s)", obj.colName, convFunc, codeIn);
        end

        function funcName = val_IMPY_to_IMML(obj) %#ok<MANU>
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
            end

            funcName = "matlab.logical";
        end

        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
                codeIn (1,1) string
            end

            funcName = array_IMML_to_IMPY(obj);
            codeOut = sprintf("%s(%s)", funcName, codeIn);
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.BooleanType %#ok<INUSA>
                val
            end

            % The base case is to just return the value
            val = logical(val);
        end


        function funcName = array_IMML_to_IMPY(obj)
            % array_IMML_to_IMPY Ensure the results are an array
            %
            % A table with 1 row will be returned as scalars from MATLAB
            % Runtime.
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_ArrayIMML", file.funcName, UT);
            fieldName = sprintf("ArrayIMML%s", UT);


            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();

            matlabType = "matlab." + obj.IntermediaryMATLABType;
            SW.pf('def %s(elem):\n', funcName)
            SW.indent();
            %%%
            SW.pf('"""Simple method to convert array entries in a column.\n')
            SW.pf('The Python type is %s."""\n', obj.PythonType);
            SW.pf("if isinstance(elem, %s):\n", matlabType);
            SW.indent();
            SW.pf("y = elem.tomemoryview().tolist()[0]\n");
            SW.unindent();
            SW.pf("elif isinstance(elem, %s):\n", obj.IntermediaryPythonType);
            SW.indent();
            SW.pf("y = [elem]\n");
            SW.unindent();
            SW.pf("else:\n");
            SW.indent();
            SW.pf("# Runtime debugging\n")
            SW.pf("y = elem\n");
            SW.unindent();
            SW.pf("return y\n");
            %%%
            SW.unindent();
            SW.pf('\n')

            PyW.addMethod(SW);

        end
        
        function arrStr = genMATLABArray(obj, N)
            % genMATLABArray - Preallocate data
            arguments
                obj (1,1) compiler.build.spark.data.BooleanType
                N (1,1) string
            end

            arrStr = sprintf("zeros(%s, 1, '%s')", N, obj.MATLABType);
        end

        function codeOut = getPyPandasSeriesConverterCtor(~)
            codeOut = "PrimitiveSeriesConverter(PrimitiveType.BOOL)";
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = compose("PrimitiveSeriesConverter()");
        end

    end

end