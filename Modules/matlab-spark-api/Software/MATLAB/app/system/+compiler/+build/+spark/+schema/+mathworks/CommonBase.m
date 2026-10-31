classdef (Abstract) CommonBase < handle
    % CommonBase - Abstract helper class
    %
    % This class serves as a common base for DataType and StructField. There are common operations
    % and properties (Parent), that makes this useful.

    % Copyright 2024 The MathWorks, Inc.

    properties (SetAccess=protected, Hidden)
        Parent 
    end
    properties (SetAccess=protected)
        type (1,1) string
    end
    methods
        function obj = CommonBase()
        end

        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type
            so = obj.type;
        end

        function str = json(obj, options)
            arguments
                obj (1,1) compiler.build.spark.schema.mathworks.CommonBase
                options.pretty (1,1) logical = false
            end
            str = jsonencode(obj.toStruct, "PrettyPrint", options.pretty);
        end

        function obj = fromVal(obj, val) %#ok<INUSD>
            % fromVal Initialize an object from JSON/struct
            %
            % In the most basic cases, like IntegerTypes, this does
            % nothing.
        end

    end
    methods (Static)
        function S = load(val)
            if (isstring(val) || ischar(val)) && isfile(val)
                jsonStr = fileread(val);
                rawStruct = jsondecode(jsonStr);
                S = compiler.build.spark.schema.mathworks.CommonBase.load(rawStruct);
            else
                % Assuming here, we're using the raw struct
                S = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val);
            end
        end

        function clazz = classFromType(val)
            switch class(val)
                case 'struct'
                    type = val.type;
                    switch type
                        case 'compiler'
                            clazz = "compiler.build.spark.schema.mathworks.CompilerType";
                        case 'io'
                            clazz = "compiler.build.spark.schema.mathworks.IOType";
                        case 'struct'
                            clazz = "compiler.build.spark.schema.StructType";
                        otherwise
                            error("SPARKAPI:bad_deserialization_class", ...
                                "Deserialization for type %s not yet implemented.", type);
                    end
                case {'string', 'char'}
                
            end

        end

        function obj = instanceFromVal(val)
            switch class(val)
                case 'struct'
                    type = val.type;
                otherwise
                    type = val;
            end

            switch type
                case 'compiler'
                    obj = compiler.build.spark.schema.mathworks.CompilerType();
                case 'io'
                    obj = compiler.build.spark.schema.mathworks.IOType();
                case 'struct'
                    obj = compiler.build.spark.schema.StructType();
                case 'double'
                    obj = compiler.build.spark.schema.DoubleType();
                case 'float'
                    obj = compiler.build.spark.schema.FloatType();
                case 'long'
                    obj = compiler.build.spark.schema.LongType();
                case 'integer'
                    obj = compiler.build.spark.schema.IntegerType();
                case 'short'
                    obj = compiler.build.spark.schema.ShortType();
                case 'byte'
                    obj = compiler.build.spark.schema.ByteType();
                case 'binary'
                    obj = compiler.build.spark.schema.BinaryType();
                case 'boolean'
                    obj = compiler.build.spark.schema.BooleanType();
                case 'date'
                    obj = compiler.build.spark.schema.DateType();
                case 'timestamp'
                    obj = compiler.build.spark.schema.TimestampType();
                case 'string'
                    obj = compiler.build.spark.schema.StringType();
                case 'array'
                    obj = compiler.build.spark.schema.ArrayType();
                case 'map'
                    obj = compiler.build.spark.schema.MapType();
                otherwise
                    if startsWith(type, "interval")
                        obj = compiler.build.spark.schema.DayTimeIntervalType(type);
                    elseif startsWith(type, "decimal(")
                        obj = compiler.build.spark.schema.DecimalType(type);
                    else
                        error("SPARKAPI:bad_deserialization_class", ...
                            "Deserialization for type %s not yet implemented.", type);
                    end
            end
                
            obj.fromVal(val);
        end

    end

end