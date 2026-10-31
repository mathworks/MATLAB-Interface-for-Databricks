classdef (Abstract) DataType < compiler.build.spark.schema.mathworks.CommonBase & matlab.mixin.Heterogeneous
    % DataType Abstract base class for Spark schema types

    % Copyright 2024-2025 The MathWorks, Inc.

    properties (Hidden)
        data_ compiler.build.spark.data.DataType = compiler.build.spark.data.DataType.empty
    end

    methods
        function obj = DataType()
            obj@compiler.build.spark.schema.mathworks.CommonBase();
        end

        function PT = pythonType(obj)
            clazz = string(class(obj));
            parts = split(clazz, ".");
            PT = parts(end);
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            PT = obj.pythonType();
            PI = PT + "()";
        end

        function imports = getPythonImports(obj)
            % getPythonImports Return imports for types
            imports = obj.pythonType();
        end

        function tf = pyTF(~, val)
            if logical(val)
                tf = "True";
            else
                tf = "False";
            end
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            str = obj.type;
        end

        function st = getSparkType(obj)
            % Return the SparkType, that can be used in e.g. UDF definitions
            % Can be deduced in many cases. Exceptions should be overridden in
            % their classes.
            st = obj.pythonType();
        end

    end

    methods (Static)
        function S = createSchema(src)
            % schema Create a Spark Schema from other input
            %
            % The input could be a python object (pyspark.sql.types.*) or a JSON
            % file (*.schema). Other options may be added.

            if isa(src, 'py.pyspark.sql.types.DataType')
                S = compiler.build.spark.schema.DataType.pyTypeToSchema(src);
            elseif isa(src, 'compiler.build.spark.schema.DataType')
                % If it's already a Schema in MATLAB form, just return it.
                S = src;
            else
                % This means it's a MATLAB value
                S = compiler.build.spark.schema.DataType.matlabValueToSchema(src);
            end
        end

        function S = matlabValueToSchema(T)
            clazz = getClazz(T);
            switch clazz
                case 'table'
                    S = compiler.build.spark.schema.DataType.tableToSchema(T);
                otherwise
                    % This is wher ethe code ends up when used for a
                    % non-table argument, i.e. either an extra argument, or
                    % a function with scalar arguments.
                    % Special consideration must be made for cases with
                    % arrays that are not uint8 (i.e. bytes).
                    S = compiler.build.spark.schema.DataType.matlabClassToSchema(T, clazz);
                    if numel(T) > 1
                        if "uint8" ~= clazz && "char" ~= clazz
                            S = compiler.build.spark.schema.ArrayType(S);
                        end
                    end
            end

        end
        function S = tableToSchema(T)
            S = compiler.build.spark.schema.StructType();
            fieldNames = string(T.Properties.VariableNames);
            for k=1:numel(fieldNames)
                F = fieldNames(k);
                val = T.(F);
                CS = compiler.build.spark.schema.DataType.tableColumnToSchema(val);
                S.add(F, CS);
            end
        end

        function S = structToSchema(ST)
            S = compiler.build.spark.schema.StructType();
            fieldNames = string(fieldnames(ST));
            for k=1:numel(fieldNames)
                F = fieldNames(k);
                CS = compiler.build.spark.schema.DataType.tableColumnToSchema(ST(1).(F));
                S.add(F, CS);
            end
        end


        function S = arrayToSchema_col(ARR)
            clazz = getClazz(ARR);
            subSchema = compiler.build.spark.schema.DataType.matlabClassToSchema_col(ARR, clazz);
            if clazz == "uint8"
                S = subSchema;
            else
                S = compiler.build.spark.schema.ArrayType(subSchema);
            end

        end

        function S = structToSchema_col(ST)
            S = compiler.build.spark.schema.StructType();
            ST_isArray = colIsArray(ST);
            if ST_isArray
                fieldNames = string(fieldnames(ST{1}));
            else
                fieldNames = string(fieldnames(ST));
            end
            for k=1:numel(fieldNames)
                F = fieldNames(k);
                if ST_isArray
                    % for nr=1:numRows
                    COL = cellfun(@(x) [x.(F)], ST, 'UniformOutput',false);
                    % COL = cell(numTotalArrElems, 1);
                else
                    COL = {ST.(F)}';
                end
                if colIsArray(COL)
                    % do nothing
                else
                    % Not an array
                    COL = cellfun(@(x) x, COL, 'UniformOutput',true);
                end
                CS = compiler.build.spark.schema.DataType.tableColumnToSchema(COL);
                S.add(F, CS);
            end
        end

        function S = tableColumnToSchema(TC)
            if iscell(TC)
                clazz = getClazz(TC{1});
                clazz2 = getClazz(TC);
                assert(isequal(clazz, clazz2));
                % S = compiler.build.spark.schema.DataType.arrayToSchema_col(TC);
                S = compiler.build.spark.schema.ArrayType(TC);
                % isArray = colIsArray(TC);
                % subSchema = compiler.build.spark.schema.DataType.matlabClassToSchema_col(TC, clazz);
                % if clazz == "uint8"
                %     S = subSchema;
                % else
                %     S = compiler.build.spark.schema.ArrayType(subSchema);
                % end
                % if isArray
                %     S = compiler.build.spark.schema.ArrayType(S);
                % end
            else
                clazz = getClazz(TC);
                % isArray = colIsArray(TC);
                S = compiler.build.spark.schema.DataType.matlabClassToSchema_col(TC, clazz);
                % if isArray
                %     S = compiler.build.spark.schema.ArrayType(S);
                % end
            end
        end

        function S = tableColumnToSchema_old(TC)
            if iscell(TC)
                % isArray = colIsArray(TC);
                clazz = getClazz(TC{1});
                subSchema = compiler.build.spark.schema.DataType.matlabClassToSchema(TC{1}, clazz);
                if clazz == "uint8"
                    S = subSchema;
                else
                    S = compiler.build.spark.schema.ArrayType(subSchema);
                end
                % if isArray
                %     S = compiler.build.spark.schema.ArrayType(S);
                % end
            else
                clazz = getClazz(TC);
                % isArray = colIsArray(TC);
                S = compiler.build.spark.schema.DataType.matlabClassToSchema(TC(1,:), clazz);
                % if isArray
                %     S = compiler.build.spark.schema.ArrayType(S);
                % end
            end
        end

        function S = matlabClassToSchema_col(val, clazz, options)
            arguments
                val
                clazz char
                options.parentIsArray (1,1) logical = false
            end

            switch clazz
                case 'int64'
                    S = compiler.build.spark.schema.LongType();
                case 'double'
                    S = compiler.build.spark.schema.DoubleType();
                case 'single'
                    S = compiler.build.spark.schema.FloatType();
                case 'int32'
                    S = compiler.build.spark.schema.IntegerType();
                case 'int16'
                    S = compiler.build.spark.schema.ShortType();
                case 'int8'
                    S = compiler.build.spark.schema.ByteType();
                case 'uint8'
                    S = compiler.build.spark.schema.BinaryType();
                case 'logical'
                    S = compiler.build.spark.schema.BooleanType();
                case 'string'
                    S = compiler.build.spark.schema.StringType();
                case 'char'
                    % TODO: Add some check for 'proper string' here.
                    S = compiler.build.spark.schema.StringType();
                case 'datetime'
                    S = compiler.build.spark.schema.DateType();
                case 'timestamp'
                    % This is not really a MATLAB type, but doing it like
                    % this, it will be correct. See getClazz in same file.
                    S = compiler.build.spark.schema.TimestampType();
                case 'struct'
                    % S = compiler.build.spark.schema.DataType.structToSchema_col(val);
                    S = compiler.build.spark.schema.StructType(val, parentIsArray=options.parentIsArray);
                case 'dictionary'
                    S = compiler.build.spark.schema.MapType(val);
                case 'duration'
                    S = compiler.build.spark.schema.DayTimeIntervalType();
                case 'missing'
                    psbDoc = matlab.databricks.internal.docLink("matlab-spark-api/PythonSparkBuilder");
                    fsDoc = matlab.databricks.internal.docLink("matlab-spark-api/FunctionSchemas");
                    error("SPARKAPI:missing_class_not_implemented", ...
                        "One column (or composite value of a column) has class of type missing. " + ...
                        "In this case, it's not possible to deduce the underlying class. " + ...
                        "Please refer to the documentation %s and %s.", psbDoc, fsDoc);
                case {'uint64', 'uint32', 'uint16'}
                    error("SPARKAPI:schema_class_not_implemented", ...
                        "Apache spark doesn't support any unsigned types. " + ...
                        "uint8 values are automatically mapped to ByteType, uint64, uint32 and uint16 are not supported. " +  ...
                        "See also: https://spark.apache.org/docs/latest/sql-ref-datatypes.html");
                otherwise
                    error("SPARKAPI:schema_class_not_implemented", ...
                        "The class %s is not yet implemented.", clazz);
            end
        end
        function S = matlabClassToSchema(val, clazz)
            switch clazz
                case 'int64'
                    S = compiler.build.spark.schema.LongType();
                case 'double'
                    S = compiler.build.spark.schema.DoubleType();
                case 'single'
                    S = compiler.build.spark.schema.FloatType();
                case 'int32'
                    S = compiler.build.spark.schema.IntegerType();
                case 'int16'
                    S = compiler.build.spark.schema.ShortType();
                case 'int8'
                    S = compiler.build.spark.schema.ByteType();
                case 'uint8'
                    S = compiler.build.spark.schema.BinaryType();
                case 'logical'
                    S = compiler.build.spark.schema.BooleanType();
                case 'string'
                    S = compiler.build.spark.schema.StringType();
                case 'char'
                    % TODO: Add some check for 'proper string' here.
                    S = compiler.build.spark.schema.StringType();
                case 'datetime'
                    S = compiler.build.spark.schema.DateType();
                case 'timestamp'
                    % This is not really a MATLAB type, but doing it like
                    % this, it will be correct. See getClazz in same file.
                    S = compiler.build.spark.schema.TimestampType();
                case 'struct'
                    % S = compiler.build.spark.schema.DataType.structToSchema_col(val);
                    S = compiler.build.spark.schema.StructType(val);
                case 'dictionary'
                    S = compiler.build.spark.schema.MapType(val);
                case 'duration'
                    S = compiler.build.spark.schema.DayTimeIntervalType();
                otherwise
                    error("SPARKAPI:schema_class_not_implemented", ...
                        "The class %s is not yet implemented.", clazz);
            end
        end

        function S = pyTypeToSchema(T)
            fullClassName = string(class(T));
            parts = fullClassName.split(".");
            className = parts(end);
            funcConstructor = "compiler.build.spark.schema." + className;
            funcName = strrep(fullClassName, '.', '_');
            try
                % S = feval(funcName, T);
                S = feval(funcConstructor, T);
            catch EX
                fprintf(2, "Message: %s", EX.message);
                error("SPARKAPI:BAD_SCHEMA_IMPLEMENTATION", ...
                    "Problems with function %s. It's either not implemented or threw an error.", funcName);
            end
        end

        function clazz = getClassTS(val)
            % getClassTS Return class, but handle timestamps/date
            % explicitly
            if isa(val, 'datetime')
                if contains(string(val.Format), 'HH')
                    clazz = 'timestamp';
                else
                    clazz = 'datetime';
                end
            else
                clazz = class(val);
            end
        end
    end
end

function isArr = colIsArray(TC)
    % colIsArray Is a table column an array
    if iscell(TC)
        isArr = any(cellfun(@(x) numel(x)>1, TC, 'UniformOutput', true));
    else
        isArr = any(size(TC, 2) > 1);
    end

end

function clazz = getClazz(TC)
    if isa(TC, 'cell')
        clazz = getClazz(TC{1});
    else
        if isa(TC, 'datetime') && contains(string(TC.Format), 'HH')
            clazz = 'timestamp';
        else
            clazz = class(TC);
        end
    end
end
% __all__ = [
% ^   "DataType",
%     "NullType",
%     "CharType",
% ^   "StringType",
%     "VarcharType",
%     "BinaryType",
% ^   "BooleanType",
%     "DateType",
%     "TimestampType",
%     "TimestampNTZType",
%     "DecimalType",
% ^   "DoubleType",
% ^   "FloatType",
%     "ByteType",
% ^   "IntegerType",
% ^   "LongType",
%     "DayTimeIntervalType",
%     "YearMonthIntervalType",
%     "Row",
% ^   "ShortType",
% ^   "ArrayType",
%     "MapType",
% ^   "StructField",
% ^   "StructType",
% ]

