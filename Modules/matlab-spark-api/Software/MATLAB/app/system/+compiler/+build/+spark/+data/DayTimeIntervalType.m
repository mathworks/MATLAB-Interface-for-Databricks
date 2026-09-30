classdef DayTimeIntervalType < compiler.build.spark.data.AnsiIntervalType
    % DayTimeIntervalType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    properties
        startField (1,1) compiler.build.spark.schema.mathworks.DHMSInterval = "DAY"
        endField (1,1) compiler.build.spark.schema.mathworks.DHMSInterval = "SECOND"
    end

    methods
        function obj = DayTimeIntervalType(varargin)
            obj@compiler.build.spark.data.AnsiIntervalType(varargin{:});
            obj.MATLABType = "duration";
            obj.type = "interval";
            S = varargin{1};
            obj.startField = S.startField;
            obj.endField = S.endField;
        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                num (1,1) double
                count (1,1) double = 3
            end
            ret = sprintf("datetime.timedelta(seconds=%d)", num);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return datetime.timedelta(seconds=num)");
            SW.unindent();

            PyW.addMethod(SW);
        end

        function strs = colsIteratorInit(obj)
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end
            strs = sprintf("%s = list()", obj.colName);
            strs(end+1) = sprintf("dtit = DayTimeIntervalType()\n");
        end

        function funcName = val_Spark_to_IMPY(obj)
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_SparktoIMPY", file.funcName, UT);
            fieldName = sprintf("SparkstoIMPY_%s", UT);
            fieldName = compiler.build.spark.internal.shortenIdentifier(fieldName);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();

            SW.pf("return dtit.toInternal(elem)\n")

            SW.unindent();

            PyW.addMethod(SW);

        end

        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                codeIn (1,1) string
            end

            convFunc = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            codeOut = sprintf("%s = %s(%s)", obj.colName, convFunc, codeIn);
        end


        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value from intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end

            funcName = "matlab." + obj.IntermediaryMATLABType;

        end

        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("IMMLtoML_%s_%s", obj.colName, UT);
            funcName= compiler.build.spark.internal.shortenIdentifier(funcName);
            
            file = obj.getFileParent();
            PSB = file.Parent;
            MW = PSB.MW;

            SW = matlab.sparkutils.StringWriter();
            SW.pf("function conv = %s(val)\n", funcName);
            SW.indent();
            SW.pf("%% %s Conversion helper function\n", funcName);
            SW.pf("%% Unique type: %s\n", UT);
            SW.pf("%% Element name: %s\n", obj.colName);
            
            SW.pf("conv = milliseconds(val/1000);\n");

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function funcName = val_ML_to_IMML(obj)
            % val_ML_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("%s_%s_MLtoIMML", obj.colName, UT);
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
            SW.pf("conv = %s(milliseconds(val))*1000;\n", obj.IntermediaryMATLABType);
            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                codeIn (1,1) string
            end

            baseConvFunc = obj.arrayElemConverter();
            codeOut = sprintf("%s(%s)", baseConvFunc, codeIn);

            % convFunc = obj.colIntermediateMATLABToPython();
            convFunc = obj.val_IMML_to_IMPY();
            if ~isempty(convFunc)
                codeOut = sprintf("[%s(x) for x in %s]", convFunc, codeOut);
            end
        end

        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_IMPYtoSpark", file.funcName, UT);
            fieldName = sprintf("IMPYtoSpark_%s", UT);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("return datetime.timedelta(microseconds=elem)");

            SW.unindent();

            PyW.addMethod(SW);

        end

        function ret = instantiateMATLABExampleValue(obj, num, options)
            % instantiateMATLABExampleValue Create example value for MATLAB
            %
            % This method is used to create example files with values
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                num (1,1) double
                options.doEval (1,1) logical = false
            end
            if options.doEval
                ret = feval(obj.IntermediaryMATLABType, 10 * 1e6 * num);
            else
                ret = sprintf("seconds(%d)", 5 * num);
            end
        end

        function codeOut = convertPandaColumnToIntermediate(obj, codeIn)
            % convertPandaColumnToIntermediate Panda columns to intermediate
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                codeIn (1,1) string
            end

            % This is normally used, but pandas changes the type of this
            % code.
            subConv = sprintf("%s(%s.total_seconds() * 1000000)", obj.IntermediaryPythonType, "x");

            codeOut = sprintf("[%s for x in %s]",subConv, codeIn);
        end

        function codeOut = convertMATLABToIntermediate(obj, codeIn)
            % convertMATLABToIntermediate Convert MATLAB values to interm.
            %
            % For some datatypes, an intermediate representation is
            % necessary (e.g. timestamps). If no conversion is necessary,
            % this just returns the same value
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
                codeIn (1,1) string
            end

            if obj.isScalarData
                transpose = "'";
            else
                transpose = "";
            end

            F = obj.getFileParent();
            PSB = F.Parent;

            if PSB.CallCtx == compiler.build.spark.CallContext.TablePandas
                codeOut = sprintf("%s(milliseconds(%s))%s*1000*1000", obj.IntermediaryMATLABType, codeIn, transpose);
            else
                codeOut = sprintf("%s(milliseconds(%s))%s*1000", obj.IntermediaryMATLABType, codeIn, transpose);
            end


        end

        function str = PandasSeriesType(obj)
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end
            str = "timedelta64[ns]";
        end

        function codeOut = getPyPandasSeriesConverterCtor(~)
           codeOut = "Timedelta64SeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            PSB = obj.getFileParent().Parent;
            if PSB.CallCtx == compiler.build.spark.CallContext.TablePandas
                timeUnit = "Nanoseconds";
            else
                timeUnit = "Milliseconds";
            end
            codeOut = compose("TimedeltaSeriesConverter(TimeUnit.%s)", timeUnit);
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
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
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
                obj (1,1) compiler.build.spark.data.DayTimeIntervalType
            end
            T = "int64";
        end

    end

end