classdef DateType < compiler.build.spark.data.DateTimeStampType
    % DateType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = DateType(varargin)
            obj@compiler.build.spark.data.DateTimeStampType(varargin{:});
            obj.MATLABType = "datetime";
            obj.PythonType = "datetime.date";
            obj.type = "date";
        end

        function ret = instantiateColExampleData(obj, srcCol)
            % instantiateColExampleData Instantiate example data from column
            %
            % The column, is in general something like an ID column
            % (spark.range(N)), and in simple cases is a cast to a
            % different type.
            arguments
                obj (1,1) compiler.build.spark.data.DateType %#ok<INUSA>
                srcCol (1,1) string
            end
            ret = ...
                "matlab.pyspark.sql.functions.date_add(" + ...
                "matlab.pyspark.sql.functions.current_date(), " + ...
                srcCol + ".cast('int'))";
        end

        function col = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DateType %#ok<INUSA>
                col
            end

            % The base case is to just return the column
            col = cellfun(@(x) datetime(string(py.str(x))), col, 'UniformOutput',true);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return datetime.date.fromtimestamp(1602306305 + (num*1000*1000))");
            SW.unindent();

            PyW.addMethod(SW);
        end

        function funcName = val_Spark_to_IMPY(obj) %#ok<MANU>
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end

            UT = obj.UniqueTypeName;

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;
            funcName = sprintf("__%s_SparktoIMPY", UT);
            fieldName = sprintf("SparktoIMPY_%s", UT);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem: datetime.date) -> int:\n", funcName);
            SW.indent();
            SW.pf('"""Helper function to convert from Spark to intermediate Python.\n')
            SW.pf('Type: %s\n', UT);
            SW.pf('"""\n')
            SW.pf('return elem.toordinal()\n')
            SW.unindent()
            SW.pf('\n')

            PyW.addMethod(SW);
        end

        function funcName = val_IMML_to_ML(obj)
            % val_IMML_to_ML Convert a value from intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DateType
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

            SW.pf("conv = datetime(1, 1, 1) + days(val-1);\n");

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end

        function funcName = val_ML_to_IMML(obj)
            % val_ML_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("MLtoIMML_%s_%s", obj.colName, UT);
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

            SW.pf("conv = int64(days(val-datetime(1,1,1))+1);\n")

            SW.unindent();
            SW.pf("end\n\n");

            MW.addSubFun(SW);

        end

        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end


            funcName = "datetime.date.fromordinal";
            return;

        end


        function str = PandasSeriesType(obj) %#ok<MANU>
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end
            str = "object";
        end


        function T = IntermediaryMATLABType(obj)
            % IntermediaryMATLABType
            %
            % The IntermediaryMATLABType is sometimes used to have as a
            % distinction for the real type (e.g. datetime) as opposed to
            % the intermediary type (int64 for datetime).
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end
            T = "int64";
        end


        function str = UniqueTypeName(obj) %#ok<MANU>
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.DateType
            end
            str = "date";
        end

        function codeOut = getPyPandasSeriesConverterCtor(~)
            codeOut = "DateSeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = "DateSeriesConverter()";
        end
    end

end