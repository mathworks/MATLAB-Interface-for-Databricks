classdef StructType < compiler.build.spark.data.DataType
    % StructType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties
        fields compiler.build.spark.data.DataType
        names string
    end
    methods
        function obj = StructType(varargin)
            obj@compiler.build.spark.data.DataType(varargin{:});
            obj.MATLABType = "struct";
            obj.type = "struct";
            S = varargin{1};
            for k=1:numel(S.fields)
                % fieldData = compiler.build.spark.data.fromSchema(S.fields(k).dataType);
                fieldData = compiler.build.spark.data.fromSchema(S.fields(k), parent=obj);
                fieldData.dataType.Name = S.fields(k).name;
                fieldData.FieldIdx_ = k; % Set the internal index in the structure
                obj.fields(k) = fieldData;
                obj.names(k) = S.fields(k).name;
            end
        end

        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                num (1,1) double
                options.doEval (1,1) logical = false
                options.asTable (1,1) logical = false
                options.numEntries (1,1) double = 1
            end

            if options.doEval
                for ne=1:options.numEntries
                    sVals = cell(2,obj.NumFields);
                    for nf = 1:obj.NumFields
                        elem = obj.fields(nf).dataType;
                        sVals{1,nf} = obj.names(nf);
                        sVals{2,nf} = instantiateMATLABExampleValue(elem, num*ne + nf*1000, doEval=true);
                    end
                    ret(ne) = struct(sVals{:}); %#ok<AGROW>
                end
                if options.asTable
                    ret = struct2table(ret);
                end
            else
                SW = matlab.sparkutils.StringWriter();
                N = obj.NumFields;
                NE = options.numEntries;
                comma = ", ";
                for ne=1:NE
                    if ne==NE; comma = ""; end
                    SW.pf("struct(");
                    strElems = strings(1, 2*N);
                    idx = 1;
                    for nf=1:N
                        elem = obj.fields(nf).dataType;
                        strElems(idx) = sprintf("'%s'", obj.names(nf));
                        idx = idx + 1;
                        strElems(idx) = elem.instantiateMATLABExampleValue(num*ne + nf*1000, doEval=false);
                        idx = idx + 1;
                    end
                    SW.pf("%s", join(strElems, ", "));
                    SW.pf(")%s", comma);
                end

                ret = SW.getString();
                if NE > 1
                    ret = "[" + ret + "]";
                end
                if options.asTable
                    ret = sprintf("struct2table(%s)", ret);
                end

            end
        end



        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                num (1,1) double
                count (1,1) double = 3
            end
            N = numel(obj.fields);
            parts = strings(1,N);
            for k=1:N
                elem = obj.fields(k).dataType;
                parts(k) = sprintf("'%s': %s", obj.names(k),  instantiatePythonExampleValue(elem, num+k, 1));
            end
            ret = sprintf("{%s}", join(parts, ", "));
            % ret = sprintf("(%s)", join(parts, ", "));
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            N = numel(obj.fields);

            isColumn = obj == obj.getColumnObject;
            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            if isColumn
                % Special case at top level
                SW.pf("return (\n");
                SW.indent();
                for k=1:N
                    elem = obj.fields(k).dataType;
                    funcElem = elem.genPythonExampleFunction();
                    SW.pf("%s(num+%d),\n", funcElem, k);
                end
                SW.unindent();
                SW.pf(")\n")
            else
                SW.pf("return {\n");
                SW.indent();
                comma = ", ";
                for k=1:N
                    if k==N, comma=""; end
                    elem = obj.fields(k).dataType;
                    funcElem = elem.genPythonExampleFunction();
                    SW.pf("'%s': %s(num+%d)%s\n", obj.names(k), funcElem, k, comma);
                end
                SW.unindent();
                SW.pf("}\n")
            end
            SW.unindent();

            PyW.addMethod(SW);
        end


        function strs = colsIteratorInit(obj)
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end
            N = numel(obj.fields);
            % Take the structure itself too:
            strs = sprintf("%s = list()", obj.colName);
            for k=1:N
                F = obj.fields(k).dataType;
                % tmpStrs = F.colsIteratorInit();
                tmpStrs = sprintf("%s = list()", F.colName);
                strs = [strs, tmpStrs]; %#ok<AGROW>
            end
            strs = join(strs, newline);
        end

        function codeLines = addIteratorRow(obj, rowSrc)
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                rowSrc (1,1) string
            end
            N = numel(obj.fields);
            codeLines = strings(N, 1);
            for k=1:N
                src = sprintf("%s[%d]", rowSrc, k-1);
                F = obj.fields(k).dataType;

                subFunc = F.val_Spark_to_IMPY();
                if isempty(subFunc)
                    codeLines(k) = sprintf("%s.append(%s)", F.colName, src);
                else
                    codeLines(k) = sprintf("%s.append(%s(%s))", F.colName, subFunc, src);
                end
                % codeLines(k) = sprintf("%s.append(%s)", F.colName, codeOut);
            end
            codeLines = join(codeLines, newline);
        end

        function codeOut = convertPandaColumnToIntermediate(obj, codeIn)
            % convertPandaColumnToIntermediate Panda columns to intermediate
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end

            N = numel(obj.fields);
            codeLines = strings(1, N);
            for k=1:N
                F = obj.fields(k).dataType;
                src = sprintf("%s['%s']", codeIn, F.Name);
                codeLines(k) = sprintf("%s", F.convertPandaColumnToIntermediate(src));
            end
            codeOut = sprintf("(%s)", join(codeLines, ", "));

        end

        function codeOut = convertMATLABToIntermediate(obj, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end
            if obj.isScalarData
                % if Parent.CallCtx ~= compiler.build.spark.CallContext.TablePandas
                transpose = "'";
                % end
            else
                transpose = "";
            end
            codeOut = sprintf("num2cell(%s)%s", codeIn, transpose);
        end

        function str = PandasSeriesType(obj)
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end
            str = "object";
        end

        function codeOut = col_Spark_to_IMPY(obj, codeIn)
            % col_Spark_to_IMPY  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end

            SW = matlab.sparkutils.StringWriter();
            SW.pf("%s = %s\n", obj.colName, codeIn);

            N = obj.NumFields;
            for k=1:N
                elem = obj.fields(k).dataType;
                elemCode = sprintf("[cc['%s'] for cc in %s]", elem.Name, obj.colName);
                subFunName = elem.val_Spark_to_IMPY();
                if isempty(subFunName)
                    SW.pf("%s = %s\n", elem.colName, elemCode);
                else
                    SW.pf("%s = [%s(x) for x in %s]\n", elem.colName, subFunName, elemCode);
                end

            end

            codeOut = SW.getString();

        end

        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_Spark_to_IMPY  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string %#ok<INUSA>
            end

            % We treat this as column, if it's parent's parent is the
            % column object.
            if obj.Parent.Parent ~= obj.getColumnObject
                valFunc = obj.val_IMPY_to_IMML();
                if isempty(valFunc)
                    codeOut = sprintf("# No need to convert %s\n", obj.colName);
                else
                    codeOut = sprintf("%s = [%s(x) for x in %s]", obj.colName, valFunc, codeIn);
                end
                return;
            end

            SW = matlab.sparkutils.StringWriter();
            SW.pf("# Prepare structure %s\n", obj.colName);
            N = obj.NumFields;
            for k=1:N
                elem = obj.fields(k).dataType;
                elemColName = elem.colName;
                subColCode = elem.col_IMPY_to_IMML(elemColName);
                SW.pf("%s\n", subColCode);
            end
            SW.pf("%s = (\n", obj.colName);
            SW.indent();
            comma = ",";
            for k=1:N
                if k==N, comma=""; end
                elem = obj.fields(k).dataType;
                elemColName = elem.colName;
                SW.pf("%s%s\n",elemColName, comma);
            end
            SW.unindent();
            SW.pf(")\n");

            codeOut = SW.getString();

        end

        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            UT = obj.UniqueTypeName;
            colName = obj.colName;
            funcName = sprintf("__%s_%s_IMPY_to_IMML", file.funcName, colName);
            fieldName = sprintf("IMPY_to_IMML_%s", colName);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);
            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            N = obj.NumFields;
            subFuncs = strings(1,N);
            for k=1:N
                name = obj.names(k);
                elem = obj.fields(k).dataType;
                subFunTmp = elem.val_IMPY_to_IMML();
                if isempty(subFunTmp)
                    subFuncs(k) = missing;
                else
                    subFuncs(k) = elem.val_IMPY_to_IMML();
                end
            end

            if all(strlength(subFuncs)==0)
                funcName = string.empty;
                return;
            end

            file.API.(fieldName) = funcName;

            SW = matlab.sparkutils.StringWriter();

            SW.pf("def %s(val):\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from intermediate Python to intermediate MATLAB.\n')
            SW.pf('Column name: %s\n', colName);
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            SW.pf("return (\n");
            SW.indent();
            for k=1:N
                src = sprintf("val[%d]", k-1);
                if strlength(subFuncs(k)) > 0
                    SW.pf("%s(%s),\n", subFuncs(k), src);
                else
                    SW.pf("%s,\n", src);
                end
            end
            SW.unindent();
            SW.pf(")\n")
            SW.unindent();
            SW.pf("\n")

            PyW.addMethod(SW);

        end


        function codeOut = convertStructColumn(obj, codeIn)
            % convertStructColumn Helper for struct columns
            %
            % A struct column will need its field entries to be cell arrays.
            arguments
                obj (1,1) compiler.build.spark.data.StructType %#ok<INUSA>
                codeIn (1,1) string
            end
            convFunc = obj.val_IMML_to_ML();

            codeOut = sprintf("cellfun(@%s, %s, 'UniformOutput', false)", convFunc, codeIn);
        end

        function codeOut = table_IMML_to_ML(obj, codeIn)
            % table_IMML_to_ML Convert one column for a table.
            % This function is necessary, to deal with the difficulties of
            % handling struct columns, and deeper nesting.
            % In most cases, it will just revert to using the
            % col_IMML_to_ML, except in the case of StructType
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end

            SW = matlab.sparkutils.StringWriter();
            SW.pf("struct( ...\n");
            SW.indent();
            N = obj.NumFields;
            comma = ",";
            for k=1:N
                if k==N, comma = ""; end
                name = obj.names(k);
                elem = obj.fields(k).dataType;
                % srcData = sprintf("transpose(%s{%d})", codeIn, k);
                srcData = sprintf("%s{%d}", codeIn, k);
                elemConv = string(elem.col_IMML_to_ML(srcData));
                if elemConv.startsWith("cellfun") || isa(elem, 'compiler.build.spark.data.ArrayType')
                    SW.pf("'%s', %s%s ...\n", name, elemConv, comma);
                else
                    SW.pf("'%s', num2cell(%s)%s ...\n", name, elemConv, comma);
                end
            end
            SW.unindent();
            SW.pf(")");
            codeOut = SW.getString();
        end

        function codeOut = col_IMML_to_ML(obj, codeIn)
            % col_IMML_to_ML Convert intermediate MATLAB column to MATLAB
            % This column should be apt as an argument to the table constructor
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end


            codeIn = sprintf("transpose(%s)", codeIn);
            valFunc = obj.val_IMML_to_ML();
            if isempty(valFunc)
                codeOut = codeIn;
            else
                codeOut = sprintf("cellfun(@%s, %s, 'UniformOutput', false)", valFunc, codeIn);
            end
        end

        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert an intermediate MATLAB value to MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end

            fullFuncName = sprintf("IMMLtoML_%s", obj.colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n", obj.colName);

            N = obj.NumFields;
            SW.pf("conv = struct(...\n", N);
            SW.indent();
            comma = ",";

            for k=1:N
                if k==N, comma=""; end
                elem = obj.fields(k).dataType;
                fName = obj.names(k);
                % codeIn = sprintf("val.%s", fName);
                subFunName = elem.val_IMML_to_ML();
                argVal = sprintf("val{%d}", k);
                if isempty(subFunName)
                    SW.pf("'%s', %s%s ...\n", fName, argVal, comma);
                else
                    SW.pf("'%s', %s(%s)%s ...\n", fName, subFunName, argVal, comma);
                end
            end
            SW.unindent();
            SW.pf(");\n")

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function funcName = val_Spark_to_IMPY(obj)
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            isPandas = file.Parent.CallCtx == "TablePandas";
            if isPandas
                ext = "Pandas";
            else
                ext = "Spark";
            end

            UT = obj.UniqueTypeName;
            colName = obj.colName;
            funcName = sprintf("__%s_%s_%stoIMPY", file.funcName, colName, ext);

            fullFieldName = sprintf("%stoIMPY_%s", ext, colName);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fullFieldName);

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

            N = obj.NumFields;
            comma = ", ";
            SW.pf("val = (\n");
            SW.indent();
            for k=1:N
                if k==N
                    comma = "";
                end

                elem = obj.fields(k).dataType;
                % codeIn = sprintf("elem[%d]", k-1);
                codeIn = sprintf("elem['%s']", elem.Name);
                subFunName = elem.val_Spark_to_IMPY();
                if isempty(subFunName)
                    SW.pf("%s%s\n", codeIn, comma);
                else
                    SW.pf("%s(%s)%s\n", subFunName, codeIn, comma);
                end

            end
            SW.unindent();
            SW.pf(")\n");
            SW.pf("return val\n")

            SW.unindent();

            PyW.addMethod(SW);

        end


        function funcName = array_ML_to_IMML(obj) %#ok<MANU>
            % array_ML_to_IMML - Convert to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end

            subFuncName = obj.val_ML_to_IMML();

            colName = obj.colName;
            fullFuncName = sprintf("array_ML_to_IMML_%s", colName);
            funcName = compiler.build.spark.internal.shortenIdentifier(fullFuncName);
        
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;
        
            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(structArr)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", obj.UniqueTypeName);
            SW.pf("%% Element name: %s\n\n", colName);
        
            SW.pf("conv = arrayfun(@%s, structArr, 'UniformOutput', false);\n", subFuncName);
        
            SW.unindent();
            SW.pf("end\n\n");
        
            MW.addSubFun(SW);
            
        end

        function codeOut = col_ML_to_IMML(obj, codeIn)
            % col_ML_to_IMML Convert MATLAB column to intermediate value
            arguments
                obj (1,1) compiler.build.spark.data.StructType
                codeIn (1,1) string
            end
            % codeOut = sprintf("%s.tomemoryview().tolist()[0]", codeIn);
            codeOut = sprintf("transpose(%s)", codeIn);
            % convFunc = obj.colIntermediateMATLABToPython();
            convFunc = obj.val_ML_to_IMML();
            if ~isempty(convFunc)
                % Assuming the function will be vectorized
                codeOut = sprintf("arrayfun(@%s, %s, 'UniformOutput', false)", convFunc, codeOut);
            end
        end

        function funcName = val_ML_to_IMML(obj)
            % val_ML_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("MLtoIMML_%s_%s", obj.colName, UT);
            funcName = compiler.build.spark.internal.shortenIdentifier(funcName);

            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", UT);
            SW.pf("%% Element name: %s\n", obj.colName);

            N = obj.NumFields;
            SW.pf("conv = cell(1, %d);\n", N);
            for k=1:N
                elem = obj.fields(k).dataType;
                fName = obj.names(k);
                codeIn = sprintf("val.%s", fName);
                subFunName = elem.val_ML_to_IMML();
                if isempty(subFunName)
                    SW.pf("conv{%d} = %s;\n", k, codeIn);
                else
                    SW.pf("conv{%d} = %s(%s);\n", k, subFunName, codeIn);
                end
            end

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.StructType %#ok<INUSA>
                codeIn (1,1) string
            end
            funcName = val_IMML_to_IMPY(obj);

            codeOut = sprintf("[%s(x) for x in %s]", funcName, codeIn);

        end

        function funcName = val_IMML_to_IMPY(obj)
            % val_IMML_to_IMPY  Convert intermediate MATLAB to Pytthon
            arguments
                obj (1,1) compiler.build.spark.data.StructType
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

            N = obj.NumFields;
            comma = ", ";
            SW.pf("return Row(\n");
            SW.indent();
            for k=1:N
                if k==N, comma = ""; end
                elem = obj.fields(k).dataType;
                codeIn = sprintf("elem[%d]", k-1);
                subFunName = elem.val_IMML_to_IMPY();
                if isempty(subFunName)
                    SW.pf("%s%s\n", codeIn, comma);
                else
                    SW.pf("%s(%s)%s\n", subFunName, codeIn, comma);
                end

            end
            SW.unindent();
            SW.pf(")\n");

            SW.unindent();

            PyW.addMethod(SW);

        end


        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end


            file = obj.getFileParent;
            PyW = file.Parent.PyW;


            isPandas = file.Parent.CallCtx == "TablePandas";

            UT = obj.UniqueTypeName;

            fn = file.funcName;
            if isPandas
                funcName = sprintf("__%s_%s_IMPYtoPandas", fn, UT);
                fieldName = sprintf("IMPYtoPandas_%s", UT);
            else
                funcName = sprintf("__%s_%s_IMPYtoSpark", fn, UT);
                fieldName = sprintf("IMPYtoSpark_%s", UT);
            end
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end


            N = obj.NumFields;
            % This is a special case. If no changes is done to the code,
            % don't change anything, i.e return an empty function.
            convCodes = strings(1,N);
            mustChange = false;
            for k=1:N
                elem = obj.fields(k).dataType;
                codeIn = sprintf("elem[%d]", k-1);
                subFunName = elem.val_IMPY_to_Spark();
                if isempty(subFunName)
                    convCodes(k) = codeIn;
                else
                    convCodes(k) = sprintf("%s(%s)", subFunName, codeIn);
                    mustChange = true;
                end
            end
            if ~mustChange
                funcName = string.empty;
                return;
            end
               
            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();

            comma = ", ";
            SW.pf("return (\n");
            SW.indent();
            for k=1:N
                if k==N, comma = ""; end
                SW.pf("%s%s\n", convCodes(k), comma);
            end
            SW.unindent();
            SW.pf(")\n");

            SW.unindent();

            PyW.addMethod(SW);

        end

        function colS = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.StructType
                col
            end

            N = obj.NumFields;
            nRows = numel(col);
            
            % This is handled differently for built-in (R2024a and later)
            % conversions and hand crafted (R2023b and earlier).
            if isstruct(col)
                % This is the hand-crafted version
                for k=1:N
                    FN = obj.names(k);
                    elem = obj.fields(k).dataType;
                    for r=1:nRows
                        col(r).(FN) = elem.val_MATLABTable(col(r).(FN));
                    end
                end
                colS = col;
            else
                % This is the built-in version
                initS = cellstr(obj.names);
                initS = [initS; repmat({{}}, 1, N)];
                colS = struct(initS{:});
                colS(nRows).(obj.names(1)) = []; % Preallocation

                for k=1:N
                    FN = obj.names(k);
                    elem = obj.fields(k).dataType;

                    if iscell(col{1}(FN))
                        for r=1:nRows
                            colS(r).(FN) = val_MATLABTable(elem, col{r}{FN});
                        end
                    else
                        for r=1:nRows
                            colS(r).(FN) = val_MATLABTable(elem, col{r}(FN));
                        end
                    end
                end
                colS = colS(:);
            end

        end

        function valS = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.StructType
                val
            end
            N = obj.NumFields;
            if isa(val, 'py.NoneType')
                valS = struct.empty;
                return;
            end
            initS = cellstr(obj.names);
            initS = [initS; repmat({1}, 1, N)];
            valS = struct(initS{:});
            for k=1:N
                FN = obj.names(k);
                elem = obj.fields(k).dataType;
                valS.(FN) = elem.val_MATLABTable(val.get(FN));
            end
        end



        function tf = isLeaf(obj)
            % isLeaf Returns true for a leaf in the tree
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end
            tf = false;
        end

        function str = UniqueTypeName(obj)
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end
            N = obj.NumFields;
            UT = strings(1,N);
            for k=1:N
                F = obj.fields(k).dataType;
                UT(k) = sprintf("_F%d_%s", k, UniqueTypeName(F));

            end
            str = "STRUC_" + join(UT, "");
        end

        function N = NumFields(obj)
            arguments
                obj (1,1) compiler.build.spark.data.StructType
            end

            N = numel(obj.fields);
        end

        function codeOut = getPyPandasSeriesConverterCtor(obj)
            fieldConverters = strings([1 numel(obj.fields)]);
            for ii = 1:numel(obj.fields)
                fieldConverters(ii) = obj.fields(ii).getPyPandasSeriesConverterCtor();
            end

            fieldConverterList = "[" + join(fieldConverters, ", ") + "]";

            codeOut = compose("StructSeriesConverter(%s)", fieldConverterList);
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            structFields = strings([1 numel(obj.fields)]);
            for ii = 1:numel(obj.fields)
                structFields(ii) = obj.fields(ii).getMLPandasSeriesConverterCtor();
            end
            fieldConverterList = "[" + join(structFields, ", ") + "]";
            codeOut = compose("StructSeriesConverter(%s)", fieldConverterList);
        end
        
    end

end