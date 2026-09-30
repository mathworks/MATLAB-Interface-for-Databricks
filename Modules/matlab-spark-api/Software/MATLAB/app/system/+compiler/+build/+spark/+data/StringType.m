classdef StringType < compiler.build.spark.data.AtomicType
    % StringType Implementation for types in Compiler workflow
    % 
    % This class deals with Strings and the conversion between MATLAB, Spark
    % and Python.
    
    % Copyright 2024-2025 The MathWorks, Inc.

    methods
        function obj = StringType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
            % TODO: Check if string/char dicothomy needs to be implemented
            obj.MATLABType = "string";
            obj.PythonType = "str";
            obj.type = "string";
        end

        function codeOut = preAllocateMATLABColumn(obj, N_str)
            % preAllocateMATLABColumn Preallocate column data
            %
            % This may be a simple zeros column for numeric types, or a
            % cell array for array types.
            % The argument N_str is a string describing the size of the
            % column
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                N_str (1,1) string
            end
            codeOut = sprintf("strings(1, %s)", N_str);
        end

        function codeOut = convertIntermediateToMATLAB(obj, codeIn)
            % convertIntermediateToMATLAB Intermediate to MATLAB
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            % TODO: Look this up warning("SPARKAPI:not_yet_implemented", "Verify this with old style. - %s", mfilename("fullpath"));
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                codeIn (1,1) string
            end
            codeOut = sprintf("string(%s)", codeIn);
        end


        function codeOut = convertMATLABToIntermediate(~, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value

            codeOut = codeIn;

        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
            arguments
                obj (1,1) compiler.build.spark.data.StringType
                num (1,1) double
                count (1,1) double = 3
            end
            cnum = num - 1;
            a = floor(cnum/26);
            b = rem(cnum,26);
            C = char(65+[a,b]);
            ret = sprintf("'%s%d'", C, num);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.StringType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf('a = num//26\n')
            SW.pf('b = num %% 26\n')            
            SW.pf("return chr(a+65) + chr(b+65) + str(num)\n")
            SW.unindent();

            PyW.addMethod(SW);
        end


        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                num (1,1) double
                options.doEval (1,1) logical = false
            end
            names = ["Alice", "Bob", "Celine", "David", "Elisa", "Frank", "Giselle"];
            idx = 1 + rem(num,numel(names));
            ret = names(idx) + "_" + num;
            if ~options.doEval
                ret = sprintf('"%s"', ret);
            end
        end



        function codeOut = getMATLABColumnEntry(obj, codeIn, indexStr)
            % getMATLABColumnEntry Return a column entry
            %
            % This function is used to get one entry, that is one columns
            % entry for a particular row, indicated by index k.
            % It will behave differently for a scalar and an array. Furthermore,
            % string behaviour may have to be handled in a custom way.

            arguments
                obj (1,1) compiler.build.spark.data.StringType
                codeIn (1,1) string
                indexStr (1,1) string
            end

            % Base case, just a datatype, not an array
            % codeOut = sprintf("string(%s{%s})", codeIn, indexStr);
            codeOut = sprintf("%s(%s)", codeIn, indexStr);
        end

        function codeOut = convertStructColumn(obj, codeIn)
            % convertStructColumn Helper for struct columns
            %
            % A struct column will need its field entries to be cell arrays.
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                codeIn (1,1) string
            end
            codeOut = codeIn;
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
                obj (1,1) compiler.build.spark.data.StringType
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

            SW.pf('def %s(elem):\n', funcName)
            SW.indent();
            %%%
            SW.pf('"""Simple method to convert array entries in a column.\n')
            SW.pf('The Python type is %s."""\n', obj.PythonType);
            SW.pf("if isinstance(elem, %s):\n", obj.IntermediaryPythonType);
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

        function funcName = array_IMML_to_ML(obj) %#ok<MANU> 
            % array_IMML_to_ML Make an array conversion
            arguments
                obj (1,1) compiler.build.spark.data.StringType
            end
            funcName = "string";
        end

        function codeOut = col_IMML_to_ML(obj, codeIn)
            % col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
            % This column should be apt as an argument to the table constructor
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                codeIn (1,1) string
            end

            codeOut = sprintf("string(transpose(%s))", codeIn);
        end

        function funcName = val_IMML_to_ML(obj) %#ok<MANU> 
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.StringType
            end

            funcName = "string";
            
        end

        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                codeIn (1,1) string
            end
            codeOut = codeIn;
        end

        function colStr = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                col 
            end

            % The base case is to just return the column

            if iscell(col)
                N = numel(col);
                colStr = strings(N,1);
                for k=1:N
                    if isstring(col{k})
                        colStr(k) = col{k};
                    elseif isa(col{k}, "py.NoneType")
                        colStr(k) = missing;
                    else
                        error("SPARKAPI:table_conversion", "Unhandled case for strings");
                    end
                end
            else
                colStr = col;
            end
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                val
            end

            % The base case is to just return the value
            if isstring(val)
                % Just keep the value
            elseif isa(val, 'py.NoneType')
                val = missing;
            elseif isa(val, 'py.str')
                val = string(val);
            else
                val = string(val.tolist());
            end
        end



        function arrStr = genMATLABArray(obj, N)
            % genMATLABArray - Preallocate data
            arguments
                obj (1,1) compiler.build.spark.data.StringType %#ok<INUSA>
                N (1,1) string
            end

            arrStr = sprintf("strings(%s, 1)", N);
        end

        function funcName = arrayElemConverter(obj)
            % arrayElemConverter Convert one element in array
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.StringType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_ArrElemMLtoPy", UT);
            fieldName = sprintf("ArrElemColPy%s", UT);

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            convType = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            SW = PyW.newMethod();

            SW.pf('def %s(elem):\n', funcName)
            SW.indent();
            %%%
            SW.pf('"""Simple method to convert array entries in a column.\n')
            SW.pf('The MATLAB type is %s and the Python type %s."""\n', convType, obj.PythonType);
            SW.pf("if isinstance(elem, %s):\n", obj.IntermediaryPythonType);
            SW.indent();
            SW.pf("y = [elem]\n");
            SW.unindent();
            SW.pf("elif isinstance(elem, numpy.ndarray):\n");
            SW.indent();
            SW.pf("y = elem.tolist()\n");
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

        function codeOut = getPyPandasSeriesConverterCtor(~)
           codeOut = "StringSeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = compose("StringSeriesConverter()");
        end

    end

end

