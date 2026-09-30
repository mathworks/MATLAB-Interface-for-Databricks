classdef DecimalType < compiler.build.spark.data.FractionalType
    % DecimalType Implementation for types in Compiler workflow

    % Copyright 2026 The MathWorks, Inc.

    properties
        precision (1,1) int32 = 10
        scale (1,1) int32 = 0
    end

    properties (Constant)
        BitWidth = 64;
    end

    methods
        function obj = DecimalType(varargin)
            obj@compiler.build.spark.data.FractionalType(varargin{:});
            obj.MATLABType = "double";
            if nargin > 0
                schema = varargin{1};
                obj.precision = schema.precision;
                obj.scale = schema.scale;
            end
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
                val
            end

            if isa(val, 'py.NoneType')
                val = nan;
            else
                val = double(py.float(val));
            end
        end

        function col = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DecimalType %#ok<INUSA>
                col
            end

            % TODO: Consider doing this part in the conversion from pandas
            % to table.
            col = cellfun(@(x) val_MATLABTable(obj, x), col, 'UniformOutput', true);

        end

        function funcName = val_Spark_to_IMPY(obj) %#ok<MANU>
            % val_Spark_to_IMPY Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
            end

            funcName = "float";

        end

        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
                codeIn (1,1) string
            end

            funcName = array_IMML_to_IMPY(obj);
            codeOut = sprintf("%s(%s)", funcName, codeIn);

        end

        function funcName = val_IMPY_to_Spark(obj)
            % val_IMPY_to_Spark  Convert intermediate py to Spark
            % Converts from intermediate Python (e.g.int) to
            % Spark timestamp, e.g. datetime.dateime(123456789)
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
            end

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_IMPYtoSpark", UT);
            fieldName = sprintf("IMPYtoSpark_%s", UT);

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("return Decimal(str(elem))\n");

            SW.unindent();

            PyW.addMethod(SW);



        end

        function str = PandasSeriesType(obj)
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
            end
            str = "object";
        end



        function str = UniqueTypeName(obj)
            % UniqueTypeName - A unique name for conversion functions
            % This name will simply be the MATLABType for simple types,
            % and some convoluted name for complex types.
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
            end

            str = sprintf("decimal_p%d_s%d", obj.precision, obj.scale);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.DecimalType
            end
            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("return Decimal(num)\n")
            SW.unindent();

            PyW.addMethod(SW);
        end

        function codeOut = getPyPandasSeriesConverterCtor(~)
            codeOut = "DecimalSeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = compose("PrimitiveSeriesConverter()");
        end
    end

end