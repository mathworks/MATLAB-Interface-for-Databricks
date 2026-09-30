classdef TimestampNTZType < compiler.build.spark.data.DateTimeStampType
    % TimestampNTZType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = TimestampNTZType(varargin)
            obj@compiler.build.spark.data.DateTimeStampType(varargin{:});
            obj.MATLABType = "timestamp";
            obj.PythonType = "datetime.datetime";
            obj.type = "timestamp";
        end

        function codeOut = preAllocateMATLABColumn(obj, N_str)
            % preAllocateMATLABColumn Preallocate column data
            %
            % This may be a simple zeros column for numeric types, or a
            % cell array for array types.
            % The argument N_str is a string describing the size of the
            % column
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType %#ok<INUSA>
                N_str (1,1) string
            end
            codeOut = sprintf("NaT(%s, 1)", N_str);
        end

        function str = PandasSeriesType(obj) %#ok<MANU>
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end
            % TODO: This may have to be handled different in different cases.
            % There are milliseconds and nanoseconds versions of this.
            str = "datetime64[ns]";
        end

        function codeOut = convertIntermediateToMATLAB(obj, codeIn)
            % convertIntermediateToMATLAB Intermediate to MATLAB
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType %#ok<INUSA>
                codeIn (1,1) string
            end

            codeOut = sprintf("datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1000)", codeIn);
        end

        function codeOut = convertMATLABToIntermediate(obj, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
                codeIn (1,1) string
            end
            % if obj.type == "array"
            %     transpose = "";
            % else
            %     % if Parent.CallCtx ~= compiler.build.spark.CallContext.TablePandas
            %     transpose = "'";
            %     % end
            % end
            % codeOut = sprintf("%s%s", codeIn, transpose);
            F = obj.getFileParent();
            PSB = F.Parent;

            if obj.isScalarData
                transpose = "'";
            else
                transpose = "";
            end

            if PSB.CallCtx == compiler.build.spark.CallContext.TablePandas
                codeOut = sprintf("convertTo(%s, 'epochtime', 'TicksPerSecond', 1e9)%s", codeIn, transpose);
            else
                codeOut = sprintf("convertTo(%s, 'epochtime', 'TicksPerSecond', 1e3)%s", codeIn, transpose);
            end

        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType %#ok<INUSA>
                num (1,1) double
                count (1,1) double = 3 %#ok<INUSA>
            end
            ret = sprintf("datetime.datetime.fromtimestamp(1602306305 + (%d*10))", num);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return datetime.datetime.fromtimestamp(1602306305 + (num*10))");
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
                obj (1,1) compiler.build.spark.data.TimestampNTZType
                srcCol (1,1) string
            end
            % ret = "(" + srcCol + " + 1602306305)" + ...
            %     ".cast('" + obj.type + "')";
            % ret = srcCol + ".cast('" + obj.type + "')";
            ret = "matlab.pyspark.sql.functions.current_timestamp()";
        end

        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
                num (1,1) double
                options.doEval (1,1) logical = false
            end
            if options.doEval
                % ret = datetime(1602306305 + 10 * num, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1000);
                epoch = feval(obj.IntermediaryMATLABType, 1602306305 + 10 * num);
                ret = datetime(epoch, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1000);
            else
                ret = sprintf("datetime(%d, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1000)", ...
                    1602306305 + 10 * num);
            end
        end

        function arrStr = genMATLABArray(obj, N)
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType %#ok<INUSA>
                N (1,1) string
            end
            arrStr = sprintf("datetime('yesterday') + transpose(seconds(1:%s))", N);
        end

        function funcName = val_Spark_to_IMPY(obj)
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            isPandas = file.Parent.CallCtx == "TablePandas";
            if isPandas
                ext = "Pandas";
                epochFactor = 1e9;
            else
                ext = "Spark";
                epochFactor = 1e3;
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_%stoIMPY", file.funcName, UT, ext);
            fieldName = sprintf("%stoIMPY_%s", ext, UT);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("return int(elem.timestamp()*%d)\n", epochFactor);
            SW.unindent();

            PyW.addMethod(SW);
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
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            isPandas = file.Parent.CallCtx == "TablePandas";
            if isPandas
                ext = "Pandas";
            else
                ext = "Spark";
            end
            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_Array%sToIMPY", file.funcName, UT, ext);
            fieldName = sprintf("Array%sToIMPY%s", ext, UT);


            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();

            subFunc = obj.val_Spark_to_IMPY();
            SW.pf('def %s(arr):\n', funcName)
            SW.indent();
            SW.pf('"""Simple method to convert TimestampNTZType array entries."""\n')

            SW.pf("return [%s(elem) for elem in arr]\n", subFunc);
            SW.unindent();
            SW.pf('\n')

            PyW.addMethod(SW);

        end



        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
                codeIn (1,1) string
            end

            convFunc = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            codeOut = sprintf("%s = %s(%s)", obj.colName, convFunc, codeIn);
        end


        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end

            funcName = "matlab." + obj.IntermediaryMATLABType;

        end

        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert a value from intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("IMMLtoML_%s_%s", obj.colName, UT);
            funcName= compiler.build.spark.internal.shortenIdentifier(funcName);
            
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            if file.Parent.CallCtx == "TablePandas"
                epochFactor = 1e9;
            else
                epochFactor = 1e3;
            end

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", UT);
            SW.pf("%% Element name: %s\n", obj.colName);

            SW.pf("conv = datetime(val, 'ConvertFrom', 'epochtime', 'TicksPerSecond', %d);\n", epochFactor);

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function funcName = val_ML_to_IMML(obj)
            % val_ML_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("MLtoIMML_%s_%s", obj.colName, UT);
            funcName= compiler.build.spark.internal.shortenIdentifier(funcName);
            
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            if file.Parent.CallCtx == "TablePandas"
                epochFactor = 1e9;
            else
                epochFactor = 1e3;
            end

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", UT);
            SW.pf("%% Element name: %s\n", obj.colName);

            SW.pf("conv = convertTo(val, 'epochtime', 'TicksPerSecond', %d);\n", epochFactor)
            
            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end

        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end


            file = obj.getFileParent;
            PyW = file.Parent.PyW;
            isPandas = file.Parent.CallCtx == "TablePandas";

            UT = obj.UniqueTypeName;
            fn = file.funcName;

            if isPandas
                funcName = sprintf("__%s_%s_IMPYtoPandas", fn, UT);
                fieldName = sprintf("IMPYtoPandas_%s", UT);
                tsFuncName = "utcfromtimestamp";
                denom = 1e9;
            else
                funcName = sprintf("__%s_%s_IMPYtoSpark", fn, UT);
                fieldName = sprintf("IMPYtoSpark_%s", UT);
                tsFuncName = "fromtimestamp";
                denom = 1e3;
            end


            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("return datetime.datetime.%s(elem/%d)", tsFuncName, denom);

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
                obj (1,1) compiler.build.spark.data.TimestampNTZType
                col
            end

            % The base case is to just return the column
            if isa(col, 'datetime')
                % Don't convert a perfect datetime
            else
                col = cellfun(@obj.val_MATLABTable, col, 'UniformOutput', true);
            end
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType %#ok<INUSA>
                val
            end

            % The base case is to just return the value
            % val = val;
            if isa(val, 'py.pandas._libs.tslibs.timestamps.Timestamp')
                val = datetime(val.timestamp(), 'ConvertFrom', 'epochtime');
            end
        end

        %TODO: Refactor TimestampNTZType and TimestampType to reuse code.
        function codeOut = getPyPandasSeriesConverterCtor(~)
           codeOut = "Datetime64SeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            PSB = obj.getFileParent().Parent;
            if PSB.CallCtx == compiler.build.spark.CallContext.TablePandas
                timeUnit = "Nanoseconds";
            else
                timeUnit = "Milliseconds";
            end
            codeOut = compose("TimestampSeriesConverter(TimeUnit.%s)", timeUnit);
        end
    end

    methods % Dependent types
        function T = IntermediaryPythonType(obj) %#ok<MANU>
            % get.IntermediaryPythonType
            %
            % The IntermediaryPythonType is something that is used to check
            % for if output is an instance, e.g. int, or a list of ints. In
            % most cases, the intermediary type is just the python type,
            % but in some cases, there's an intermediary type, which is
            % used in python, as a route to MATLAB.
            % The Timestamp data type is an example of this, so this method
            % must be overridden there.
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end
            T = "int";
        end

        function T = IntermediaryMATLABType(obj) %#ok<MANU>
            % get.IntermediaryMATLABType
            %
            % The IntermediaryMATLABType is sometimes used to have as a
            % distinction for the real type (e.g. datetime) as opposed to
            % the intermediary type (int64 for datetime).
            arguments
                obj (1,1) compiler.build.spark.data.TimestampNTZType
            end
            T = "int64";
        end

    end


end