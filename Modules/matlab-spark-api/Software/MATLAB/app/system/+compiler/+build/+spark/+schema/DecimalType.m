classdef DecimalType < compiler.build.spark.schema.FractionalType
    % DecimalType Spark schema types

    % Copyright 2026 The MathWorks, Inc.

    properties
        precision (1,1) int32 = 10
        scale (1,1) int32 = 0
    end

    methods
        function obj = DecimalType(arg)
            obj@compiler.build.spark.schema.FractionalType();
            obj.type = 'decimal';
            tArg = class(arg);
            switch tArg
                case 'py.pyspark.sql.types.DecimalType'
                    obj.precision = arg.precision;
                    obj.scale = arg.scale;
                case {'char', 'string'}
                    S = regexp(arg, 'decimal\((?<precision>[0-9]+)\s*,\s*(?<scale>[0-9]+)\)', 'names', 'once');
                    obj.precision = str2double(S.precision);
                    obj.scale = str2double(S.scale);
                otherwise
                    error("SPARKAPI:schema:decimaltypeconstructor", "Bad arguments to constructor for compiler.build.spark.schema.DecimalType");
            end
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            arguments
                obj (1,1) compiler.build.spark.schema.DecimalType
            end
            PT = obj.pythonType();
            PI = sprintf("%s(%d,%d)", PT, obj.precision, obj.scale);
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            arguments
                obj (1,1) compiler.build.spark.schema.DecimalType
            end
            str = sprintf('%s(%d,%d)', obj.type, obj.precision, obj.scale);
        end

        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type
            arguments
                obj (1,1) compiler.build.spark.schema.DecimalType
            end
            so = obj.pythonSchemaType();
        end

    end

end