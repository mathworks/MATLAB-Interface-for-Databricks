classdef (Abstract) NumericType < compiler.build.spark.data.AtomicType
    % NumericType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

     properties(Abstract, Constant)
        BitWidth
     end

    methods
        function obj = NumericType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
        end

        function codeOut = convertStructColumn(obj, codeIn)
            % convertStructColumn Helper for struct columns
            %
            % A struct column will need its field entries to be cell arrays.
            arguments
                obj (1,1) compiler.build.spark.data.NumericType %#ok<INUSA>
                codeIn (1,1) string
            end
            codeOut = "num2cell(" + codeIn + ")";
        end

        function arrStr = genMATLABArray(obj, N)
            % genMATLABArray - Preallocate data
            arguments
                obj (1,1) compiler.build.spark.data.NumericType
                N (1,1) string
            end

            arrStr = sprintf("zeros(%s, 1, '%s')", N, obj.MATLABType);
        end

        function codeOut = pandasSeriesToColumn(obj) %#ok<MANU>
            arguments
                obj(1, 1) compiler.build.spark.data.DataType
            end
            codeOut = "to_numpy()";
        end

        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.NumericType
                codeIn (1,1) string
            end

            convFunc = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            codeOut = sprintf("%s = %s(%s)", obj.colName, convFunc, codeIn);
        end

        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            if obj.isExtraArgument()
                funcName = string.empty;
            else
                funcName = "matlab." + obj.IntermediaryMATLABType;
            end
        end

        function funcName = array_IMPY_to_IMML(obj)
            % array_IMPY_to_IMML Convert array value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.NumericType
            end

            subFuncName = val_IMPY_to_IMML(obj);
            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;

            funcName = sprintf("__%s_%s_arrayIMPYtoIMML", file.funcName, UT);
            fieldName = sprintf("IMMLtoIMPY_%s", UT);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            
            SW.pf("if isinstance(elem, list) and isinstance(elem[0], numpy.ndarray):\n")
            SW.indent();
            SW.pf("return %s(elem[0].tolist())\n", subFuncName)
            SW.unindent();
            SW.pf("else:\n")
            SW.indent();
            SW.pf("return %s(elem)\n", subFuncName)
            SW.unindent();
            SW.unindent();

            PyW.addMethod(SW);

        end

        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.NumericType
            end

            if obj.isExtraArgument()
                funcName = obj.IntermediaryMATLABType;
            else                
                funcName = string.empty;
            end

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.NumericType
                codeIn (1,1) string
            end
            
            funcName = array_IMML_to_IMPY(obj);
            codeOut = sprintf("%s(%s)", funcName, codeIn);

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
                obj (1,1) compiler.build.spark.data.NumericType
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

        function codeOut = getPyPandasSeriesConverterCtor(obj)
            enum = compose("PrimitiveType.%s%d", upper(obj.PythonType), obj.BitWidth);
            codeOut = compose("PrimitiveSeriesConverter(%s)", enum);
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = compose("PrimitiveSeriesConverter()");
        end
    end

end