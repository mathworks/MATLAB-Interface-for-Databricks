classdef ArrayType < compiler.build.spark.schema.DataType
    % ArrayType Structure class for Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    properties
        containsNull (1,1) logical = true
        elementType compiler.build.spark.schema.DataType
    end

    methods
        function obj = ArrayType(initVal, options)
            arguments
                initVal = []
                options.containsNull  (1,1) logical
            end
            obj@compiler.build.spark.schema.DataType();
            obj.type = 'array';
            if isempty(initVal)
                return;
            end
            if isa(initVal, 'py.pyspark.sql.types.ArrayType')
                obj.elementType = compiler.build.spark.schema.DataType.createSchema(initVal.elementType);
                obj.containsNull = initVal.containsNull;
            elseif isa(initVal, 'compiler.build.spark.schema.DataType')
                obj.elementType = initVal;
                if isfield(options, 'containsNull')
                    obj.containsNull = options.containsNull;
                else
                    obj.containsNull = true;
                end
            else
                % Create an arraytype from a MATLAB value
                clazz = class(initVal{1});
                % If any of the rows is an array, the element contains an
                % array.
                rowLengths = cellfun(@numel, initVal, 'UniformOutput',true);
                isSubArray = any(rowLengths>1);

                obj.elementType =compiler.build.spark.schema.DataType.matlabClassToSchema_col(initVal, clazz, parentIsArray=true);
            end
        end


        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type

            % {"containsNull":true,"elementType":"double","type":"array"}

            so = struct(...
                "containsNull", obj.containsNull, ...
                "elementType", obj.elementType.toStruct, ...
                "type", obj.type);
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            PT = obj.pythonType();
            PI = PT + "(" + ...
                obj.elementType.pythonInitCode() + ", " + ...
                obj.pyTF(obj.containsNull) + ...
                ")";
        end

        function imports = getPythonImports(obj)
            % getPythonImports Return imports for types
            imports = [obj.pythonType(), getPythonImports(obj.elementType)];
        end

        function obj = fromVal(obj, val)
            elemType = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val.elementType);
            obj.containsNull = val.containsNull;
            obj.elementType = elemType;
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            str = "array<" + pythonSchemaType(obj.elementType) + ">";
        end

    end

end