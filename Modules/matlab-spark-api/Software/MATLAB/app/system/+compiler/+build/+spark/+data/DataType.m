classdef (Abstract) DataType < compiler.build.spark.data.BaseType
    % DataType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties
        MATLABType (1,1) string
        PythonType (1,1) string
        Name (1,1) string
    end
    properties (Hidden)
        schema_ compiler.build.spark.schema.DataType = compiler.build.spark.schema.DataType.empty
    end
    properties (Hidden, SetAccess=protected)
        ColNameCache_ string = string.empty
    end

    methods
        function obj = DataType(varargin)
            obj@compiler.build.spark.data.BaseType(varargin{:});
        end

        function tf = isScalarData(obj)
            tf = true;
            parent = obj.Parent;
            if isa(parent, 'compiler.build.spark.data.BaseType')
                if parent.type == "array"
                    tf = false;
                end
            end
        end

        function tf = isColumn(obj)
            % isColumn Check if an object is actually a column
            % This is true if it's part of a table input (or output), and
            % if it's part of the top-level structure. This is important,
            % in certain conversions. A column with type array<something>
            % should always return cell arrays in MATLAB, whereas an array
            % element in a struct, in general, shouldnt.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            tf = true;
            parent = obj.Parent;
            if isempty(parent) || isa(parent, 'compiler.build.spark.PythonFileV2')
                % No parent, or file parent means column
                return;
            end

            % If the first wasn't the case, this is an element of a struct.
            parent = parent.Parent;

            % Let's check for its parent
            parent = parent.Parent;
             if isempty(parent) || isa(parent, 'compiler.build.spark.PythonFileV2')
                % No parent, or file parent means column
                return;
            end
            
            % If we arrive here, this is not a column
            tf = false;
            
        end

        function codeOut = preAllocateMATLABColumn(obj, N_str)
            % preAllocateMATLABColumn Preallocate column data
            %
            % This may be a simple zeros column for numeric types, or a
            % cell array for array types.
            % The argument N_str is a string describing the size of the
            % column
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                N_str (1,1) string
            end
            codeOut = sprintf("zeros(%s, 1, '%s')", N_str, obj.MATLABType);
        end

        function str = PandasSeriesType(obj)
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            str = obj.MATLABType;
        end

        function codeOut = convertStructColumn(obj, codeIn)
            % convertStructColumn Helper for struct columns
            %
            % A struct column will need its field entries to be cell arrays.
            arguments
                obj (1,1) compiler.build.spark.data.DataType %#ok<INUSA>
                codeIn (1,1) string
            end
            convFunc = obj.val_IMML_to_ML();
            if isempty(convFunc)
                codeOut = "num2cell(" + codeIn + ")";
            else
                codeOut = sprintf("num2cell(%s(%s))", convFunc, codeIn);
            end
        end

        function codeOut = convertIntermediateToMATLAB(obj, codeIn)
            % convertIntermediateToMATLAB Intermediate to MATLAB
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value

            codeOut = codeIn;
        end

        function codeOut = convertMATLABToIntermediate(obj, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end
            if obj.isScalarData
                % if Parent.CallCtx ~= compiler.build.spark.CallContext.TablePandas
                transpose = "'";
                % end
            else
                transpose = "";
            end
            codeOut = sprintf("%s%s", codeIn, transpose);
        end

        function funcName = col_IMML_to_PandasSeries(obj)
            % col_IMML_to_PandasSeries
            % Generate a helper function, and add it to the API struct. If already
            % present, don't generate it.

            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            file = obj.getFileParent;
            PSB = file.Parent;
            PyW = PSB.PyW;

            UT = obj.UniqueTypeName;
            fileFuncName = file.funcName;
            funcName = sprintf("__%s_%s_IMMLtoPandasSeries", fileFuncName, UT);
            fieldName = compiler.build.spark.internal.shortenIdentifier(sprintf("IMMLtoPandasSeries_%s", UT));

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();

            SW.pf("def %s(col):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function for converting column\n')
            SW.pf('      of type ''%s''\n', UT);
            SW.pf('"""\n');

            SW.pf("# IMML_to_IMPY\n");
            colName = obj.colName;
            SW.pf("%s = %s\n", colName, col_IMML_to_IMPY(obj, "col"));

            SW.pf("# IMPY_to_Spark\n");
            outConv = col_IMPY_to_Spark(obj, colName);
            if outConv ~= colName
                SW.pf("%s = %s\n", colName, outConv);
                % if PSB.Debug
                %     SW.pf("print(f'%s: {%s}')\n", colName, colName)
                % end
            end
            SW.pf("\n");

            SW.pf("return pd.Series(%s, name='%s', dtype='%s')\n", obj.colName, obj.Name, obj.PandasSeriesType);
            SW.unindent();
            SW.pf("\n");

            PyW.addMethod(SW);
        end

        function funcName = colIntermediateMATLABToPython(obj)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_IntermediateMLtoPy", UT);
            fieldName = sprintf("intermColPy%s", UT);

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;


            convType = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            SW = PyW.newMethod();

            SW.pf("def %s(col):\n", funcName)
            SW.indent();
            SW.pf('"""Function for converting a column with underlying type %s"""\n', UT);
            SW.pf('\n')
            SW.pf('def fix_element(x):\n')
            SW.indent();
            %%%
            SW.pf("if isinstance(x, %s):\n", convType);
            SW.indent();
            SW.pf("y = x.tomemoryview().tolist()[0]\n");
            SW.unindent();
            SW.pf("elif isinstance(x, %s):\n", obj.PythonType);
            SW.indent();
            SW.pf("y = [x]\n");
            SW.unindent();
            SW.pf("elif isinstance(x, list):\n");
            SW.indent();
            SW.pf("# Already a list\n");
            SW.pf("if isinstance(x[0], %s):\n", convType);
            SW.indent();
            SW.pf("y = x[0].tomemoryview().tolist()\n");
            SW.unindent();
            SW.pf("else:\n");
            SW.indent();
            SW.pf("y = x\n");
            SW.unindent();
            SW.unindent();
            SW.pf("else:\n");
            SW.indent();
            SW.pf("y = None\n");
            SW.unindent();
            SW.pf("return y\n");
            %%%
            SW.unindent();
            SW.pf('\n')
            SW.pf('return [fix_element(x) for x in col]\n');
            SW.unindent();
            SW.pf('\n')

            PyW.addMethod(SW);

        end

        function funcName = arrayElemConverter(obj)
            % arrayElemConverter Convert one element in array
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_ArrElemMLtoPy", file.funcName, UT);
            fieldName = sprintf("ArrElemColPy%s", UT);


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
            SW.pf("if isinstance(elem, %s):\n", convType);
            SW.indent();
            SW.pf("y = elem.tomemoryview().tolist()[0]\n");
            SW.unindent();
            SW.pf("elif isinstance(elem, %s):\n", obj.IntermediaryPythonType);
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

        function funcName = genIntermediateArrayToPython(arg)
            % genIntermediateArrayToPython
            % Generate a helper function, and add it to the API struct. If already
            % present, don't generate it.

            arguments
                arg (1,1) compiler.build.spark.data.DataType
            end

            funcName = sprintf("__array%s_to_py", arg.UniqueTypeName);
            fieldName = sprintf("intermColConvPy%s", arg.UniqueTypeName);

            file = arg.getFileParent;
            PyW = file.Parent.PyW;

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            convType = sprintf("matlab.%s", arg.IntermediaryMATLABType);
            SW = PyW.newMethod();

            SW.pf("def %s(col):\n", funcName);
            SW.indent();
            SW.pf("def fix_item(x):\n");
            SW.indent();
            SW.pf("if isinstance(x, %s):\n", convType);
            SW.indent();
            SW.pf("y = x.tomemoryview().tolist()[0]\n");
            SW.unindent();
            SW.pf("elif isinstance(x, %s):\n", arg.PythonType);
            SW.indent();
            SW.pf("y = [x]\n");
            SW.unindent();
            SW.pf("elif isinstance(x, list):\n");
            SW.indent();
            SW.pf("# Already a list\n");
            SW.pf("if isinstance(x[0], %s):\n", convType);
            SW.indent();
            SW.pf("y = x[0].tomemoryview().tolist()\n");
            SW.unindent();
            SW.pf("else:\n");
            SW.indent();
            SW.pf("y = x\n");
            SW.unindent();
            SW.unindent();
            SW.pf("else:\n");
            SW.indent();
            SW.pf("y = None\n");
            SW.unindent();
            SW.pf("return y\n");
            SW.unindent();
            SW.pf("return [fix_item(x) for x in col]\n");
            SW.unindent();
            SW.pf("\n");

            PyW.addMethod(SW);
        end

        function codeOut = convertPandaColumnFromIntermediate(obj, codeIn) %#ok<INUSD>
            % convertPandaColumnFromIntermediate Panda columns to intermediate
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            %
            % If the code out is not length zero, it will be added to the code.

            codeOut = "";

        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                num (1,1) double
                count (1,1) double = 3 %#ok<INUSA>
            end
            ret = sprintf("%s(%d)", obj.PythonType, num);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            error("SPARKAPI:NEEDS_OVERRIDE", ...
                "The method genPythonExampleFunction must be overridden for %s", class(obj));
        end

        function ret = instantiateColExampleData(obj, srcCol)
            % instantiateColExampleData Instantiate example data from column
            %
            % The column, is in general something like an ID column
            % (spark.range(N)), and in simple cases is a cast to a
            % different type.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                srcCol (1,1) string
            end
            ret = srcCol + ".cast('" + obj.type + "')";
        end

        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                num (1,1) double
                options.doEval (1,1) logical = false
            end
            if options.doEval
                ret = feval(obj.MATLABType, num);
            else
                ret = sprintf("%s(%d)", obj.MATLABType, num);
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
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
                indexStr (1,1) string
            end

            % Base case, just a datatype, not an array
            codeOut = sprintf("%s(%s)", codeIn, indexStr);
        end

        function tf = hasDataTypeParent(obj)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            tf = isa(obj.Parent, 'compiler.build.spark.data.DataType');
        end

        function parentName = getParentColName(obj)
            % getParentColName Helper function for column name
            % This is needed, to ascertain if a function's parent is, for
            % example, the key in a map. This has an influence in creating
            % unique column names.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            if hasDataTypeParent(obj)
                parentName = colName_(obj.Parent);
            else
                parentName = "C_";
            end

            % Look for special cases, like MAPS:
            if isa(obj.Parent, 'compiler.build.spark.data.MapType')
                if isequal(obj, obj.Parent.keyType)
                    parentName = parentName + "KEY";
                else 
                    parentName = parentName + "VAL";
                end
            elseif isa(obj.Parent, 'compiler.build.spark.data.ArrayType')
                parentName = parentName + "ARR";
            end
        end

        function cName = colName_(obj)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            cName = sprintf("%s%s_", obj.getParentColName(), obj.Name);
        end

        function strs = colsIteratorInit(obj)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            strs = sprintf("%s = list()", obj.colName);
        end

        function codeLines = addIteratorRow(obj, rowSrc)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                rowSrc (1,1) string
            end
            convFunc = obj.val_Spark_to_IMPY();

            if isempty(convFunc)
                codeLines = sprintf("%s.append(%s)\n", obj.colName, rowSrc);
            else
                codeLines = sprintf("%s.append(%s(%s))\n", obj.colName, convFunc, rowSrc);
            end
        end

        function codeOut = pandasSeriesToColumn(obj) %#ok<MANU>
            arguments
                obj(1, 1) compiler.build.spark.data.DataType
            end
            codeOut = "to_list()";
        end

        function codeOut = col_Spark_to_IMPY(obj, codeIn)
            % col_Spark_to_IMPY  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end

            convFunc = obj.val_Spark_to_IMPY();
            if ~isempty(convFunc)
                codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, convFunc, codeIn);
            else
                codeOut = sprintf("%s = %s\n", obj.colName, codeIn);
            end
        end


        function funcName = val_Spark_to_IMPY(obj) %#ok<MANU>
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_MLtoIMML", UT);
            % fieldName = sprintf("MLtoIMML_%s", UT);

            % file = obj.getFileParent();
            % PSB = file.Parent;
            % MW = PSB.MW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

        end

        function funcName = array_Spark_to_IMPY(obj)
            % array_Spark_to_IMPY Convert an array from Spark to IMPY
            %
            % This is different from the val_Spark_to_IMPY, because the way
            % values can be returned from Spark, e.g. a list or a
            % numpy.ndarray.
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_ArraySparkToIMPY", file.funcName, UT);
            fieldName = sprintf("ArraySparkToIMPY%s", UT);


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
            % TODO: Unclear if the first one can happen. Probably not,
            % given how Python looks at arrays
            % SW.pf("if isinstance(elem, %s):\n", obj.IntermediaryPythonType);
            % SW.indent();
            % SW.pf("y = [elem]\n");
            % SW.unindent();
            SW.pf("if isinstance(elem, numpy.ndarray):\n");
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


        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end

            convFunc = obj.val_IMPY_to_IMML();
            if ~isempty(convFunc)
                codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, convFunc, codeIn);
            else
                codeOut = sprintf("%s = %s\n", obj.colName, codeIn);
            end
        end

        function funcName = val_IMPY_to_IMML(obj) %#ok<MANU>
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_MLtoIMML", UT);
            % fieldName = sprintf("MLtoIMML_%s", UT);

            % file = obj.getFileParent();
            % PSB = file.Parent;
            % MW = PSB.MW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

        end

        function funcName = array_IMPY_to_IMML(obj) %#ok<MANU>
            % array_IMPY_to_IMML Convert array value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
        end

        function codeOut = table_IMML_to_ML(obj, codeIn)
            % table_IMML_to_ML Convert one column for a table.
            % This function is necessary, to deal with the difficulties of
            % handling struct columns, and deeper nesting. 
            % In most cases, it will just revert to using the
            % col_IMML_to_ML, except in the case of StructType
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end

            codeOut = col_IMML_to_ML(obj, codeIn);
        end

        function funcName = array_IMML_to_ML(obj) %#ok<MANU> 
            % array_IMML_to_ML Make an array conversion
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            funcName = string.empty;
        end

        function codeOut = col_IMML_to_ML(obj, codeIn)
            % col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
            % This column should be apt as an argument to the table constructor
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end

            codeIn = sprintf("transpose(%s)", codeIn);
            convFunc = obj.val_IMML_to_ML();
            if ~isempty(convFunc)
                codeOut = sprintf("%s(%s)", convFunc, codeIn);
            else
                codeOut = codeIn;
            end
        end

        function funcName = val_IMML_to_ML(obj) %#ok<MANU>
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_MLtoIMML", UT);
            % fieldName = sprintf("MLtoIMML_%s", UT);

            % file = obj.getFileParent();
            % PSB = file.Parent;
            % MW = PSB.MW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

        end

        function funcName = array_ML_to_IMML(obj) %#ok<MANU> 
            % array_ML_to_IMML - Convert to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
        end
        
        function codeOut = col_ML_to_IMML(obj, codeIn)
            % col_ML_to_IMML Convert MATLAB column to intermediate value
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end
            % codeOut = sprintf("%s.tomemoryview().tolist()[0]", codeIn);
            codeOut = sprintf("transpose(%s)", codeIn);
            % convFunc = obj.colIntermediateMATLABToPython();
            convFunc = obj.val_ML_to_IMML();
            if ~isempty(convFunc)
                % Assuming the function will be vectorized
                codeOut = sprintf("%s(%s)", convFunc, codeOut);
            end
        end

        function funcName = val_ML_to_IMML(obj) %#ok<MANU>
            % val_ML_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_MLtoIMML", UT);
            % fieldName = sprintf("MLtoIMML_%s", UT);

            % file = obj.getFileParent();
            % PSB = file.Parent;
            % MW = PSB.MW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

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
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end
            % codeOut = sprintf("%s.tomemoryview().tolist()[0]", codeIn);
            codeOut = codeIn;
            % convFunc = obj.colIntermediateMATLABToPython();
            convFunc = obj.val_IMML_to_IMPY();
            if ~isempty(convFunc)
                codeOut = sprintf("[%s(x) for x in %s]", convFunc, codeOut);
            end
        end

        function funcName = val_IMML_to_IMPY(obj)
            % val_IMML_to_IMPY Convert a value to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_IMMLtoIMPY", UT);
            % fieldName = sprintf("IMMLtoIMPY_%s", UT);

            % file = obj.getFileParent;
            % PyW = file.Parent.PyW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

        end

        function codeOut = col_IMPY_to_Spark(obj, codeIn)
            % col_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                codeIn (1,1) string
            end

            convFunc = obj.val_IMPY_to_Spark();
            if ~isempty(convFunc)
                codeOut = sprintf("[%s(x) for x in %s]", convFunc, codeIn);
            else
                codeOut = codeIn;
            end

        end

        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            funcName = string.empty;
            return;

            % Use similar code for actual conversions

            % UT = obj.UniqueTypeName;
            % funcName = sprintf("__%s_IMPYtoSpark", UT);
            % fieldName = sprintf("IMPYtoSpark_%s", UT);

            % file = obj.getFileParent;
            % PyW = file.Parent.PyW;

            % if isfield(file.API, fieldName)
            %     % This was already generated, don't bother
            %     return
            % end

            % file.API.(fieldName) = funcName;

        end

        function col = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DataType %#ok<INUSA>
                col 
            end

            % The base case is to just return the column
            % col = col;
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DataType %#ok<INUSA>
                val
            end

            % The base case is to just return the value
            % val = val;
        end

        function arrStr = genMATLABArray(obj, N)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                N (1,1) string
            end
            error('SPARKAPI:abstract_function', ...
                'Implement this for any used data type');
        end

        function tf = isLeaf(obj) %#ok<MANU>
            % isLeaf Returns true for a leaf in the tree
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            tf = true;
        end

        function str = getIndexString_(obj, idx)
            % getIndexString_
            %
            % Returns something like (k) or {k}
            arguments
                obj       compiler.build.spark.data.DataType
                idx       string
            end
            str = sprintf("(%s)", idx);
        end
    
        function colObj = getColumnObject(obj)
            % getColumnObject Return column object
            % The column object is the data on the top-level, i.e. the data
            % directly in the file object.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            parent = obj.Parent;
            if isa(parent, 'compiler.build.spark.PythonFileV2')
                colObj = obj;
            else
                colObj = getColumnObject(parent);
            end
        end
        function [idx, isInput] = getColumnIndex(obj)
            % getColumnIndex Return the column index
            % Returns column index, as well as if it's an input or an
            % output. The column index here is the top-level, i.e. a table
            % entry, or an array entry, will be mapped to the corresponding
            % column above.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            co = obj.getColumnObject();
            file = co.Parent;
            for k=1:file.nArgIn
                if isequal(co, file.InData(k))
                    idx = k;
                    isInput = true;
                    return;
                end
            end
            for k=1:file.nArgOut
                if isequal(co, file.OutData(k))
                    idx = k;
                    isInput = false;
                    return;
                end
            end
            idx = [];
            isInput = [];
            % error("SPARKAPI:BAD_DATA_OBJET", ...
            %     "Couldn't find column object.");
        end

        function tf = isExtraArgument(obj)
            % isExtraArgument Check if this is an additional argument
            %
            % It can only be an extra argument if it's an input, it's index
            % is larger than one, and the first argument is a table.
            % This will be needed in conversion routines
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            tf = false;
            [idx, isInput] = getColumnIndex(obj);
            if ~isempty(isInput) && isInput && (idx>1)
                file = obj.getFileParent;
                tf = file.Schema.Inputs(1).Table;
            end
        end
    end

    methods (Sealed)
        function str = getIndexString(obj, idx)
            % getIndexString
            %
            % Returns something like (k) or {k}
            arguments
                obj       compiler.build.spark.data.DataType
                idx       string
            end
            N = numel(obj);
            str = strings(1, N);
            for k=1:N
                str(k) = getIndexString_(obj(k), idx);
            end
        end
        function str = colName(obj)
            arguments
                obj compiler.build.spark.data.DataType
            end
            N = numel(obj);
            str = strings(1, N);
            for k=1:N
                curObj = obj(k);
                if isempty(curObj.ColNameCache_)
                    curObj.ColNameCache_ = getSafeName(colName_(curObj));
                end
                str(k) = curObj.ColNameCache_;
            end
        end

    end

    methods
        function T = IntermediaryPythonType(obj)
            % IntermediaryPythonType
            %
            % The IntermediaryPythonType is something that is used to check
            % for if output is an instance, e.g. int, or a list of ints. In
            % most cases, the intermediary type is just the python type,
            % but in some cases, there's an intermediary type, which is
            % used in python, as a route to MATLAB.
            % The Timestamp data type is an example of this, so this method
            % must be overridden there.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            T = obj.PythonType;
        end
        function T = IntermediaryMATLABType(obj)
            % IntermediaryMATLABType
            %
            % The IntermediaryMATLABType is sometimes used to have as a
            % distinction for the real type (e.g. datetime) as opposed to
            % the intermediary type (int64 for datetime).
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            T = obj.MATLABType;
        end
        function str = UniqueTypeName(obj)
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            str = obj.MATLABType;
        end
    end

    methods (Abstract)
        % Generates the PandasSeriesConverter constructor to invoke in
        % order to construct the appropriate PandasSeriesConverter python
        % object.
        codeOut = getPyPandasSeriesConverterCtor(obj)

        % Generates the PandasSeriesConverter constructor to invoke in
        % order to construct the appropriate PandasSeriesConverter MATLAB
        % object.
        codeOut = getMLPandasSeriesConverterCtor(obj)

    end

end

function safeName = getSafeName(name)
    % getSafeName Return 'safe' MATLAB name
    % A column name may not work as a MATLAB variable name. In
    % those cases, the name must be changed in a unique way.
    arguments
        name (1,1) string {mustBeTextScalar}
    end

    % safeName = "SN" + idx + "_" + matlab.lang.makeValidName(name);
    str = matlab.lang.makeValidName(name);
    if strcmp(str, name)
        safeName = name; % No change needed
    else
        hashString = string(py.hashlib.md5(py.str(name).encode()).hexdigest());
        safeName = str + hashString.extractBefore(9);
    end
end
