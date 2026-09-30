classdef MapType < compiler.build.spark.schema.DataType
    % MapType Map class for Spark schema types

    % Copyright 2025 The MathWorks, Inc.

    properties
        valueContainsNull (1,1) logical = true
        keyType compiler.build.spark.schema.DataType
        valueType compiler.build.spark.schema.DataType
    end

    methods
        function obj = MapType(varargin)
            obj@compiler.build.spark.schema.DataType();
            obj.type = 'map';
            if nargin > 0
                if nargin == 1
                    MT = varargin{1};
                    if isa(MT, 'py.pyspark.sql.types.MapType')
                        obj.keyType = compiler.build.spark.schema.DataType.createSchema(MT.keyType);
                        obj.valueType = compiler.build.spark.schema.DataType.createSchema(MT.valueType);
                        obj.valueContainsNull = MT.valueContainsNull;
                    elseif isa(MT, 'dictionary')
                        keys = MT.keys;
                        vals = MT.values;
                        obj.keyType = compiler.build.spark.schema.DataType.matlabValueToSchema(keys(1));
                        obj.valueType = compiler.build.spark.schema.DataType.matlabValueToSchema(vals(1));
                    else
                        error("Bad arguments");
                    end
                    % elseif nargin == 2
                    %     obj.elementType = varargin{1};
                    %     obj.containsNull = varargin{2};
                else
                    error("Bad arguments");
                end
            end
        end


        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type

            % {"containsNull":true,"elementType":"double","type":"array"}
            arguments
                obj (1,1) compiler.build.spark.schema.MapType
            end
            so = struct(...
                "keyType", obj.keyType.toStruct, ...
                "type", obj.type, ...
                "valueContainsNull", obj.valueContainsNull, ...
                "valueType", obj.valueType.toStruct);
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            arguments
                obj (1,1) compiler.build.spark.schema.MapType
            end
            PT = obj.pythonType();
            PI = PT + "(" + ...
                obj.keyType.pythonInitCode() + ", " + ...
                obj.valueType.pythonInitCode() + ", " + ...
                obj.pyTF(obj.valueContainsNull) + ...
                ")";
        end

        function imports = getPythonImports(obj)
            % getPythonImports Return imports for types
            arguments
                obj (1,1) compiler.build.spark.schema.MapType
            end
            imports = [...
                obj.pythonType(), ...
                getPythonImports(obj.keyType), ...
                getPythonImports(obj.valueType)];
        end

        function obj = fromVal(obj, val)
            obj.keyType =compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val.keyType);
            obj.valueType =compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val.valueType );
            obj.valueContainsNull = val.valueContainsNull;
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            arguments
                obj (1,1) compiler.build.spark.schema.MapType
            end
            str = sprintf("map<%s,%s>", ...
                pythonSchemaType(obj.keyType), pythonSchemaType(obj.valueType));
        end

    end

end