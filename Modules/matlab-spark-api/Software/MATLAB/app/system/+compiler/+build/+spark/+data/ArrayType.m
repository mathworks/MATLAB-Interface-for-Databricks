classdef ArrayType < compiler.build.spark.data.DataType
    % ArrayType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties
        containsNull (1,1) logical = true
        elementType compiler.build.spark.data.DataType
    end
    methods
        function obj = ArrayType(varargin)
            obj@compiler.build.spark.data.DataType(varargin{:});
            obj.type = "array";
            if nargin > 0
                S = varargin{1};
                obj.elementType = compiler.build.spark.data.fromSchema(S.elementType, parent=obj);
                obj.containsNull = S.containsNull;
            end
        end

        function codeOut = preAllocateMATLABColumn(obj, N_str)
            % preAllocateMATLABColumn Preallocate column data
            %
            % This may be a simple zeros column for numeric types, or a
            % cell array for array types.
            % The argument N_str is a string describing the size of the
            % column
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
                N_str (1,1) string
            end
            codeOut = sprintf("cell(%s, 1)", N_str);
        end

        function codeOut = convertIntermediateToMATLAB(obj, codeIn)
            % convertIntermediateToMATLAB Intermediate to MATLAB
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            subConv = convertIntermediateToMATLAB(obj.elementType, "x");
            if subConv == "x"
                codeOut = sprintf("%s'", codeIn);
            else
                codeOut = sprintf("cellfun(@(x) %s, %s, 'UniformOutput', false)'", subConv, codeIn);
            end
        end

        function codeOut = convertMATLABToIntermediate(obj, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end
            subConv = convertMATLABToIntermediate(obj.elementType, "x");
            if subConv == "x"
                codeOut = codeIn;
            else
                codeOut = sprintf("cellfun(@(x) %s, %s, 'UniformOutput', false)", subConv, codeIn);
            end
        end

        function str = PandasSeriesType(obj) %#ok<MANU>
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end
            str = "object";
        end


        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                num (1,1) double
                count (1,1) double = 3 %#ok<INUSA>
            end
            parts = string.empty;
            ri = randi(5);
            for m=1:ri
                parts(m) = instantiatePythonExampleValue(obj.elementType, num+m);
            end
            ret = "["  + join(parts, ", ") + "]";
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("retVal = list()\n");
            SW.pf("ri = random.randrange(1,10)\n")
            funcElem = obj.elementType.genPythonExampleFunction();
            SW.pf("for x in range(0,ri):\n")
            SW.indent();
            SW.pf("retVal.append(%s(num+x+1))\n", funcElem)
            SW.unindent();
            SW.pf("return retVal\n")
            SW.unindent();

            PyW.addMethod(SW);
        end

        function ret = instantiateColExampleData(obj, srcCol)
            % instantiateColExampleData Instantiate example data from column
            %
            % The column, is in general something like an ID column
            % (spark.range(N)), and in simple cases is a cast to a
            % different type.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                srcCol (1,1) string
            end
            elem = instantiateColExampleData(obj.elementType, srcCol);
            ret = sprintf("matlab.pyspark.sql.functions.array(%s, %s, %s)", ...
                elem, elem, elem);
        end

        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                num (1,1) double
                options.doEval (1,1) logical = false
            end
            nEntries = randi(5);
            if options.doEval
                for k=1:nEntries
                    ret(k) = instantiateMATLABExampleValue(obj.elementType, num+100*k, doEval=options.doEval); %#ok<AGROW>
                end
            else
                entries = strings(1,nEntries);
                for k=1:nEntries
                    entries(k) = instantiateMATLABExampleValue(obj.elementType, num+100*k, doEval=options.doEval);
                end
                ret = sprintf("[%s]", join(entries, ", "));
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
                obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
                codeIn (1,1) string
                indexStr (1,1) string
            end

            % Base case, just a datatype, not an array
            codeOut = sprintf("%s{%s}", codeIn, indexStr);
        end

        function str = UniqueTypeName(obj)
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end
            str = "ARR_" + UniqueTypeName(obj.elementType);
        end

        function codeLines = addIteratorRow(obj, rowSrc)
            arguments
                obj (1,1) compiler.build.spark.data.DataType
                rowSrc (1,1) string
            end
            convFunc = obj.elementType.val_Spark_to_IMPY();

            if isempty(convFunc)
                codeLines = sprintf("%s.append(%s)\n", obj.colName, rowSrc);
            else
                codeLines = sprintf("%s.append([%s(x) for x in %s])\n", obj.colName, convFunc, rowSrc);
            end
        end

        function codeOut = col_Spark_to_IMPY(obj, codeIn)
            % col_Spark_to_IMPY  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            % Arrays may be in numpy.ndarray format
            elemType = obj.elementType;
            % if isa(elemType, "compiler.build.spark.data.NumericType")
            if elemType.isLeaf
                convFunc = elemType.array_Spark_to_IMPY();
            else
                convFunc = obj.val_Spark_to_IMPY();
            end
            

            if ~isempty(convFunc)
                codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, convFunc, codeIn);
            else
                codeOut = sprintf("%s = %s\n", obj.colName, codeIn);
            end
        end

        function funcName = val_Spark_to_IMPY(obj)
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            convFunc = obj.elementType.val_Spark_to_IMPY();

            if isempty(convFunc)
                funcName = string.empty;
                return;
            end
            isPandas = file.Parent.CallCtx == "TablePandas";
            if isPandas
                ext = "Pandas";
            else
                ext = "Spark";
            end

            UT = obj.UniqueTypeName;
            colName = obj.colName;
            funcName = sprintf("__%s_%s_%stoIMPY", file.funcName, colName, ext);
            fieldName = sprintf("%stoIMPY_%s", ext, colName);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(arr):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from intermediate Python to intermediate MATLAB.\n')
            SW.pf('Column name: %s\n', colName);
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            SW.pf("return [%s(elem) for elem in arr]\n", convFunc);
            SW.unindent();

            PyW.addMethod(SW);

        end

        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            % convFunc = obj.elementType.val_IMPY_to_IMML();
            convFunc = obj.val_IMPY_to_IMML();
            if ~isempty(convFunc)
                codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, convFunc, codeIn);
            else
                codeOut = sprintf("%s = %s\n", obj.colName, codeIn);
            end
        end

        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            % 
            % In the case of an array, there may be an existing conversion
            % function, like matlab.int32, or a created one. It will be
            % taken from the underlying array function.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            subFuncName = obj.elementType.array_IMPY_to_IMML();
            if ~isempty(subFuncName)
                funcName = subFuncName;
                return;
            end

            subFuncName = obj.elementType.val_IMPY_to_IMML();
            if isempty(subFuncName)
                funcName = string.empty;
                return;
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            colName = obj.colName;
            funcName = sprintf("__%s_%s_IMPYtoIMML", file.funcName, colName);
            fieldName = sprintf("IMPYtoIMML_%s", colName);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from intermediate Python to intermediate MATLAB.\n')
            SW.pf('Column name: %s\n', colName);
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            SW.pf("return [%s(x) for x in elem]", subFuncName);
            SW.unindent();

            PyW.addMethod(SW);

        end

        function codeOut = col_IMML_to_ML(obj, codeIn)
            % col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
            % This column should be apt as an argument to the table constructor
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            codeIn = sprintf("transpose(%s)", codeIn);
            convFunc = obj.val_IMML_to_ML();
            if ~isempty(convFunc)
                codeOut = sprintf("cellfun(@%s, %s, 'UniformOutput', false)", convFunc, codeIn);
            else
                codeOut = codeIn;
            end
        end


        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            subFuncName = obj.elementType.val_IMML_to_ML();

            if isempty(subFuncName)
                funcName = string.empty;
                return;
            end
            fullFuncName = sprintf("IMML_to_ML_%s", obj.colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);

            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n\n", obj.colName);

            SW.pf("if iscell(val)\n");
            SW.indent();
            SW.pf("conv = cellfun(@%s, val, 'UniformOutput', true);\n", subFuncName);
            SW.unindent();
            SW.pf("else\n");
            SW.indent();
            SW.pf("conv = %s(val);\n", subFuncName);
            SW.unindent();
            SW.pf("end\n")


            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end

        function codeOut = convertStructColumn(obj, codeIn)
            % convertStructColumn Helper for struct columns
            %
            % A struct column will need its field entries to be cell arrays.
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
                codeIn (1,1) string
            end            
            codeOut = codeIn;
        end

        function codeOut = col_ML_to_IMML(obj, codeIn)
            % col_ML_to_IMML Convert MATLAB column to intermediate value
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            codeOut = sprintf("transpose(%s)", codeIn);

            convFunc = obj.val_ML_to_IMML();
            if ~isempty(convFunc)
                % Assuming the function will be vectorized
                codeOut = sprintf("cellfun(@%s, %s, 'UniformOutput', false)", convFunc, codeOut);
            end
        end

        function funcName = val_ML_to_IMML(obj)
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            subFuncName = obj.elementType.val_ML_to_IMML();

            if isempty(subFuncName)
                funcName = string.empty;
                return;
            end
            fullFuncName = sprintf("ML_to_IMML_%s", obj.colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);

            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n\n", obj.colName);

            SW.pf("if iscell(val)\n");
            SW.indent();
            SW.pf("conv = cellfun(@%s, val, 'UniformOutput', false);\n", subFuncName);
            SW.unindent();
            SW.pf("else\n");
            SW.indent();
            SW.pf("conv = arrayfun(@%s, val, 'UniformOutput', false);\n", subFuncName);
            SW.unindent();
            SW.pf("end\n")


            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                codeIn (1,1) string
            end

            % Note: This distinction may need more care later
            % if isa(obj.elementType, 'compiler.build.spark.data.NumericType')
            %     codeOut = sprintf("%s.tomemoryview().tolist()[0]", codeIn);
            % else
            codeOut = codeIn;
            % end

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
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            if obj.elementType.isLeaf()
                % convFunc = obj.elementType.arrayElemConverter();
                convFunc = obj.elementType.array_IMML_to_IMPY();
            else
                convFunc = obj.elementType.val_IMML_to_IMPY();
            end

            if isempty(convFunc)
                funcName = string.empty;
                return;
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_IMMLtoIMPY", file.funcName, UT);
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
            if obj.elementType.isLeaf()
                SW.pf("return %s(elem)", convFunc);
            else
                SW.pf("return [%s(x) for x in elem]", convFunc);
            end
            SW.unindent();

            PyW.addMethod(SW);

        end


        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;
            isPandas = file.Parent.CallCtx == "TablePandas";

            convFunc = obj.elementType.val_IMPY_to_Spark();
            if isempty(convFunc)
                funcName = string.empty;
                return;
            end

            UT = obj.UniqueTypeName;
            if isPandas
                funcName = sprintf("__%s_IMPYtoPandas", UT);
                fieldName = sprintf("IMPYtoPandas_%s", UT);
            else
                funcName = sprintf("__%s_IMPYtoSpark", UT);
                fieldName = sprintf("IMPYtoSpark_%s", UT);
            end
                            
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("return [%s(x) for x in elem]", convFunc);

            SW.unindent();

            PyW.addMethod(SW);

        end

        function newCol = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                col 
            end

            % The base case is to just return the column
            N = numel(col);
            newCol = cell(N,1);
            for k=1:N
                val = col{k};
                if isa(val, 'py.numpy.ndarray')
                    val = cell(val.tolist());
                    newCol{k} = val_MATLABTable(obj, val);
                elseif isa(val, 'py.NoneType')
                    % Convert a python None value to a MATLAB missing value.
                    newCol{k} = missing;
                end               
            end
            
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                val
            end

            % The base case is to just return the value
            if isa(val, 'py.numpy.ndarray')
                    val = val.tolist();
                if obj.isColumn
                    val = cellfun(@(x) val_MATLABTable(obj.elementType, x), cell(val), 'UniformOutput', true);
                elseif obj.Parent.type == "array"
                    val = cellfun(@(x) val_MATLABTable(obj.elementType, x), cell(val), 'UniformOutput', false);
                elseif obj.elementType.isLeaf()
                    val = obj.elementType.val_MATLABTable(val);
                else
                    val = cellfun(@(x) val_MATLABTable(obj.elementType, x), cell(val), 'UniformOutput', true);
                end
            else
                val = cellfun(@(x) val_MATLABTable(obj.elementType, x), val, 'UniformOutput', true);
            end
        end


        function funcName = colIntermediateMATLABToPython(obj)
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
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


            elem = obj.elementType;
            elemConv = elem.arrayElemConverter();

            if isempty(elemConv)
                funcName = string.empty;
                return;
            end
            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();

            SW.pf("def %s(col):\n", funcName)
            SW.indent();
            SW.pf('"""Function for converting a column with underlying type %s"""\n', UT);
            SW.pf('\n')
            SW.pf('return [%s(x) for x in col]\n', elemConv);
            SW.unindent();
            SW.pf('\n')

            PyW.addMethod(SW);

        end

        function arrStr = genMATLABArray(obj, N)
            % genMATLABArray - Preallocate data
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
                N (1,1) string
            end

            arrStr = sprintf("cell(%s, 1)", N);
        end

        function str = getIndexString_(obj, idx)
            % getIndexString
            %
            % Returns something like (k) or {k}
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
                idx (1,1) string
            end
            str = sprintf("{%s}", idx);
        end

        function tf = isLeaf(obj) %#ok<MANU>
            % isLeaf Returns true for a leaf in the tree
            arguments
                obj (1,1) compiler.build.spark.data.ArrayType
            end
            tf = false;
        end

        function codeOut = getPyPandasSeriesConverterCtor(obj)
            elementConverterCtor = obj.elementType.getPyPandasSeriesConverterCtor();
            codeOut = compose("ArraySeriesConverter(%s)", elementConverterCtor);
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            elementConverter = obj.elementType.getMLPandasSeriesConverterCtor();
            arraySeriesClass = "ArraySeriesConverter";
            codeOut = compose("%s(%s)",arraySeriesClass, elementConverter);
        end

    end

end
