classdef MapType < compiler.build.spark.data.DataType
    % MapType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    properties
        valueContainsNull (1,1) logical = true
        keyType compiler.build.spark.data.DataType
        valueType compiler.build.spark.data.DataType
    end
    methods
        function obj = MapType(varargin)
            obj@compiler.build.spark.data.DataType(varargin{:});
            obj.type = "map";
            obj.MATLABType = "dictionary";
            obj.PythonType = "dict";
            if nargin > 0
                S = varargin{1};
                obj.keyType = compiler.build.spark.data.fromSchema(S.keyType, parent=obj);
                obj.valueType = compiler.build.spark.data.fromSchema(S.valueType, parent=obj);
                obj.valueContainsNull = S.valueContainsNull;
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
                obj (1,1) compiler.build.spark.data.MapType %#ok<INUSA>
                N_str (1,1) string
            end
            codeOut = sprintf("cell(%s, 1)", N_str);
        end

        function str = PandasSeriesType(obj) %#ok<MANU>
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.MapType
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
                obj (1,1) compiler.build.spark.data.MapType
                num (1,1) double
                count (1,1) double = 3 %#ok<INUSA>
            end
            ri = randi(3);
            parts = strings(1,ri);
            for m=1:ri
                parts(m) = sprintf("%s: %s", ...
                    instantiatePythonExampleValue(obj.keyType, num+m*10), ...
                    instantiatePythonExampleValue(obj.valueType, num+m*20));
            end
            ret = "{"  + join(parts, ", ") + "}";
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.MapType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            keyFunc = obj.keyType.genPythonExampleFunction();
            valFunc = obj.valueType.genPythonExampleFunction();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("ri = random.randrange(1,5)\n")
            SW.pf("retVal = {}\n")
            SW.pf("# key   UT: %s\n", obj.keyType.UniqueTypeName);
            SW.pf("# value UT: %s\n", obj.valueType.UniqueTypeName);
            SW.pf("for xi in range(0,ri):\n");
            SW.indent();
            SW.pf("retVal[%s(num + (xi+1)*10)] = %s(num + (xi+1)*20)\n", keyFunc, valFunc)
            SW.unindent();
            SW.pf("return retVal\n")
            SW.unindent();

            PyW.addMethod(SW);
        end


        % function ret = instantiateColExampleData(obj, srcCol)
        %     % instantiateColExampleData Instantiate example data from column
        %     %
        %     % The column, is in general something like an ID column
        %     % (spark.range(N)), and in simple cases is a cast to a
        %     % different type.
        %     arguments
        %         obj (1,1) compiler.build.spark.data.ArrayType
        %         srcCol (1,1) string
        %     end
        %     elem = instantiateColExampleData(obj.elementType, srcCol);
        %     ret = sprintf("matlab.pyspark.sql.functions.array(%s, %s, %s)", ...
        %         elem, elem, elem);
        % end
        %
        % function ret = instantiateMATLABExampleValue(obj, num, options)
        %     % instantiateMATLABExampleValue Create example value for MATLAB
        %     %
        %     % This method is used to create example files with values
        %     arguments
        %         obj (1,1) compiler.build.spark.data.ArrayType
        %         num (1,1) double
        %         options.doEval (1,1) logical = false
        %     end
        %     nEntries = randi(5);
        %     if options.doEval
        %         for k=1:nEntries
        %             ret(k) = instantiateMATLABExampleValue(obj.elementType, num+100*k, doEval=options.doEval); %#ok<AGROW>
        %         end
        %     else
        %         entries = strings(1,nEntries);
        %         for k=1:nEntries
        %             entries(k) = instantiateMATLABExampleValue(obj.elementType, num+100*k, doEval=options.doEval);
        %         end
        %         ret = sprintf("[%s]", join(entries, ", "));
        %     end
        % end
        %
        %
        % function codeOut = getMATLABColumnEntry(obj, codeIn, indexStr)
        %     % getMATLABColumnEntry Return a column entry
        %     %
        %     % This function is used to get one entry, that is one columns
        %     % entry for a particular row, indicated by index k.
        %     % It will behave differently for a scalar and an array. Furthermore,
        %     % string behaviour may have to be handled in a custom way.
        %
        %     arguments
        %         obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
        %         codeIn (1,1) string
        %         indexStr (1,1) string
        %     end
        %
        %     % Base case, just a datatype, not an array
        %     codeOut = sprintf("%s{%s}", codeIn, indexStr);
        % end
 
        function codeOut = col_Spark_to_IMPY(obj, codeIn)
            % col_Spark_to_IMPY  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.MapType
                codeIn (1,1) string
            end
        
            convFunc = obj.val_Spark_to_IMPY();
        
            if ~isempty(convFunc)
                codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, convFunc, codeIn);
            else
                codeOut = sprintf("%s = %s\n", obj.colName, codeIn);
            end
        end
        
        function funcName = val_Spark_to_IMPY(obj)
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.MapType
            end
        
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;
        
            % The keyConvFunc should always be empty, as we only support
            % string keys on this interface.
            keyConvFunc = obj.keyType.val_Spark_to_IMPY();
            valConvFunc = obj.valueType.val_Spark_to_IMPY();
        
            % Always convert a Map to its keys and values
            % if isempty(keyConvFunc) && isempty(valConvFunc)
            %     funcName = string.empty;
            %     return;
            % end
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
            SW.pf("def %s(a_dict):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from intermediate Python to intermediate MATLAB.\n')
            SW.pf('Column name: %s\n', colName);
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            SW.pf('new_keys = list()\n')
            SW.pf('new_values = list()\n')
            SW.pf("for key in a_dict:\n")
            SW.indent();
            if isempty(valConvFunc)
                newVal = "a_dict[key]";
            else
                newVal = sprintf("%s(a_dict[key])", valConvFunc);
            end
            if isempty(keyConvFunc)
                newKey = "key";
            else
                newKey = sprintf("%s(key)", keyConvFunc);
            end
            SW.pf("new_keys.append(%s)\n", newKey);
            SW.pf("new_values.append(%s)\n", newVal);
            SW.unindent();
            SW.pf("return (new_keys, new_values)\n\n")
            SW.unindent();
        
            PyW.addMethod(SW);
        
        end
        
        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.MapType
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
                obj (1,1) compiler.build.spark.data.MapType
            end
        
            
            keyFuncName = obj.keyType.array_IMPY_to_IMML();
            if isempty(keyFuncName)
                keyIsArray=false;
                keyFuncName = obj.keyType.val_IMPY_to_IMML();
            else
                keyIsArray=true;
            end

            valFuncName = obj.valueType.array_IMPY_to_IMML();
            if isempty(valFuncName)
                valIsArray = false;
                valFuncName = obj.valueType.val_IMPY_to_IMML();
            else
                valIsArray = true;
            end

            if isempty(keyFuncName) && isempty(valFuncName)
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
            SW.pf("def %s(key_val_tuple):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from intermediate Python to intermediate MATLAB.\n')
            SW.pf('Column name: %s\n', colName);
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            if isempty(keyFuncName)
                SW.pf('keys = key_val_tuple[0]\n');
            else
                if keyIsArray
                    SW.pf('keys = %s(key_val_tuple[0])\n', keyFuncName);
                else
                    SW.pf('keys = [%s(x) for x in key_val_tuple[0]]\n', keyFuncName);
                end
            end
            if isempty(valFuncName)
                SW.pf('vals = key_val_tuple[1]\n');
            else
                if valIsArray
                    SW.pf('vals = %s(key_val_tuple[1])\n', valFuncName);
                else
                    SW.pf('vals = [%s(x) for x in key_val_tuple[1]]\n', valFuncName);
                end
            end
            SW.pf("return (keys, vals)\n", keyFuncName);
            SW.unindent();
        
            PyW.addMethod(SW);
        
        end
        
        function codeOut = col_IMML_to_ML(obj, codeIn)
            % col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
            % This column should be apt as an argument to the table constructor
            arguments
                obj (1,1) compiler.build.spark.data.MapType
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
                obj (1,1) compiler.build.spark.data.MapType
            end
            
            keyConvFunc = obj.keyType.array_IMML_to_ML();
            if isempty(keyConvFunc)
                keyIsArray = false;
                keyConvFunc = obj.keyType.val_IMML_to_ML();
            else
                keyIsArray = true;
            end

            valConvFunc = obj.valueType.array_IMML_to_ML();
            if isempty(valConvFunc)
                valIsArray = false;
                valConvFunc = obj.valueType.val_IMML_to_ML();
            else
                valIsArray = false;
            end

            % A dictionary will always need a conversion, as it's made into
            % a struct in MATLAB
            % if isempty(keyConvFunc) && isempty(valConvFunc)
            %     funcName = string.empty;
            %     return;
            % end
            fullFuncName = sprintf("IMML_to_ML_%s", obj.colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);
        
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;
        
            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(keyValTuple)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n\n", obj.colName);

            keySrc = "keyValTuple{1}";
            valSrc = "keyValTuple{2}";
            if isempty(keyConvFunc)
                SW.pf("keys = %s;\n", keySrc);
            else
                if keyIsArray
                    SW.pf("keys = %s(keyValTuple{1});\n", keyConvFunc);
                else
                    SW.pf("if iscell(%s)\n", keySrc);
                    SW.indent();
                    SW.pf("keys = cellfun(@%s, %s, 'UniformOutput', true);\n", keyConvFunc, keySrc);
                    SW.unindent();
                    SW.pf("else\n");
                    SW.indent();
                    SW.pf("keys = arrayfun(@%s, %s, 'UniformOutput', true);\n", keyConvFunc, keySrc);
                    SW.unindent();
                    SW.pf("end\n");
                end
            end

            if isempty(valConvFunc)
                SW.pf("vals = %s;\n", valSrc);
            else
                if valIsArray
                    SW.pf("vals = %s(%s);\n", valConvFunc, valSrc);
                else
                    SW.pf("if iscell(%s)\n", valSrc);
                    SW.indent();
                    SW.pf("vals = cellfun(@%s, %s, 'UniformOutput', true);\n", valConvFunc, valSrc);
                    SW.unindent();
                    SW.pf("else\n");
                    SW.indent();
                    SW.pf("vals = arrayfun(@%s, %s, 'UniformOutput', true);\n", valConvFunc, valSrc);
                    SW.unindent();
                    SW.pf("end\n");

                end
            end
            SW.pf("conv = dictionary(keys(:), vals(:));\n");
       
            SW.unindent();
            SW.pf("end\n\n");
        
            MW.addSubFun(SW);
        end
        
        % function codeOut = convertStructColumn(obj, codeIn)
        %     % convertStructColumn Helper for struct columns
        %     %
        %     % A struct column will need its field entries to be cell arrays.
        %     arguments
        %         obj (1,1) compiler.build.spark.data.ArrayType %#ok<INUSA>
        %         codeIn (1,1) string
        %     end
        %     codeOut = codeIn;
        % end
        
        function codeOut = col_ML_to_IMML(obj, codeIn)
            % col_ML_to_IMML Convert MATLAB column to intermediate value
            arguments
                obj (1,1) compiler.build.spark.data.MapType
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
                obj (1,1) compiler.build.spark.data.MapType
            end
        
            keyFuncName = obj.keyType.array_ML_to_IMML();
            if isempty(keyFuncName)
                keyIsArray = false;
                keyFuncName = obj.keyType.val_ML_to_IMML();
            else
                keyIsArray = true;
            end
            valFuncName = obj.valueType.array_ML_to_IMML();
            if isempty(valFuncName)
                valIsArray = false;
                valFuncName = obj.valueType.val_ML_to_IMML();
            else
                valIsArray = true;
            end
        
            fullFuncName = sprintf("ML_to_IMML_%s", obj.colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);
        
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;
        
            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(dictVal)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n\n", obj.colName);
        
            if isempty(keyFuncName)
                keyStr = "transpose(dictVal.keys)";
            else
                keyStr = sprintf("%s(transpose(dictVal.keys))", keyFuncName);
            end
            if isempty(valFuncName)
                valStr = "transpose(dictVal.values)";
            else
                valStr = sprintf("%s(transpose(dictVal.values))", valFuncName);
            end

            SW.pf("conv = {%s, %s};\n", keyStr, valStr);
        
        
            SW.unindent();
            SW.pf("end\n\n");
        
            MW.addSubFun(SW);
        
        end
        
        
        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.MapType
                codeIn (1,1) string
            end
        
            % Note: This distinction may need more care later
            codeOut = codeIn;
        
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
                obj (1,1) compiler.build.spark.data.MapType
            end
        
            if obj.keyType.isLeaf()
                % convFunc = obj.elementType.arrayElemConverter();
                keyConvFunc = obj.keyType.array_IMML_to_IMPY();
            else
                keyConvFunc = obj.keyType.val_IMML_to_IMPY();
            end

            if obj.valueType.isLeaf()
                % convFunc = obj.elementType.arrayElemConverter();
                valConvFunc = obj.valueType.array_IMML_to_IMPY();
            else
                valConvFunc = obj.valueType.val_IMML_to_IMPY();
            end

            if isempty(keyConvFunc) && isempty(valConvFunc)
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
            keysStr = "elem[0]";
            valsStr = "elem[1]";
            if ~isempty(keyConvFunc)
                if obj.keyType.isLeaf()
                    keysStr = sprintf("%s(%s)", keyConvFunc, keysStr);
                else
                    keysStr = sprintf("[%s(x) for x in %s]", keyConvFunc, keysStr);
                end
            end
            if ~isempty(valConvFunc)
                if obj.valueType.isLeaf()
                    valsStr = sprintf("%s(%s)", valConvFunc, valsStr);
                else
                    valsStr = sprintf("[%s(x) for x in %s]", valConvFunc, valsStr);
                end
            end

            SW.pf("return (%s, %s)\n", keysStr, valsStr);
            SW.unindent();
        
            PyW.addMethod(SW);
        
        end
        
        
        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.MapType
            end
        
            file = obj.getFileParent;
            PyW = file.Parent.PyW;
            isPandas = file.Parent.CallCtx == "TablePandas";
        
            keyConvFunc = obj.keyType.val_IMPY_to_Spark();
            valConvFunc = obj.valueType.val_IMPY_to_Spark();
        
            UT = obj.UniqueTypeName;
            colName = obj.colName;
            if isPandas
                funcName = sprintf("__%s_%s_IMPYtoPandas", file.funcName, colName);
                fieldName = sprintf("IMPYtoPandas_%s", colName);
            else
                funcName = sprintf("__%s_%s_IMPYtoSpark", file.funcName, colName);
                fieldName = sprintf("IMPYtoSpark_%s", colName);
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
            SW.pf("new_dict = {}\n")
            SW.pf("keys = elem[0]\n")
            SW.pf("vals = elem[1]\n")
            SW.pf("N = len(keys)\n")
            SW.pf("for idx in range(N):\n")
            SW.indent()
            if isempty(keyConvFunc)
                keyStr = "keys[idx]";
            else
                keyStr = sprintf("%s(keys[idx])", keyConvFunc);
            end
            if isempty(valConvFunc)
                valStr = "vals[idx]";
            else
                valStr = sprintf("%s(vals[idx])", valConvFunc);
            end
            SW.pf('new_dict[%s] = %s\n', keyStr, valStr);
            SW.unindent();
            SW.pf("return new_dict\n");
            SW.unindent();
        
            PyW.addMethod(SW);
        
        end

        function col = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.MapType
                col
            end

            % The base case is to just return the column
            col = cellfun(@(x) val_MATLABTable(obj, x), col, 'UniformOutput', false);
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.MapType
                val
            end

            keys = val.keys;
            if iscell(keys)
                keys = cellfun(@(x) val_MATLABTable(obj.keyType, x), keys, 'UniformOutput', false);
            else
                keys = arrayfun(@(x) val_MATLABTable(obj.keyType, x), keys, 'UniformOutput', true);
            end
            values = val.values;
            if iscell(values)
                % TODO: Using UniformOutput set to true here may be a
                % simplifcation. It's a good choice when dealing with
                % strings, as these will otherwise be made into a cell
                % array, if a py.NoneType is present. There may be a need
                % for more rigorous rules, though.
                values = cellfun(@(x) val_MATLABTable(obj.valueType, x), values, 'UniformOutput', true);
            else
                values = arrayfun(@(x) val_MATLABTable(obj.valueType, x), values, 'UniformOutput', true);
            end
            val = dictionary(keys, values);
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

        function str = UniqueTypeName(obj)
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.MapType
            end

            str = sprintf("MAP_K%s_V%s", UniqueTypeName(obj.keyType), UniqueTypeName(obj.valueType));
        end


        function codeOut = getPyPandasSeriesConverterCtor(obj)
            keyConverterCtor = obj.keyType.getPyPandasSeriesConverterCtor();
            valueConverterCtor = obj.valueType.getPyPandasSeriesConverterCtor();
            codeOut = compose("MapSeriesConverter(%s, %s)", keyConverterCtor, valueConverterCtor);
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            keyConverter = obj.keyType.getMLPandasSeriesConverterCtor();
            valueConverter = obj.valueType.getMLPandasSeriesConverterCtor();
            codeOut = compose("MapSeriesConverter(%s, %s)", keyConverter, valueConverter);
        end
    end

end