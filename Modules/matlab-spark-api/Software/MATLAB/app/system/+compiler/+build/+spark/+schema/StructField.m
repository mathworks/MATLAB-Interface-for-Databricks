classdef StructField < compiler.build.spark.schema.DataType
    % StructField Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    properties
        name (1,1) string
        dataType compiler.build.spark.schema.DataType
        nullable (1,1) logical
        metadata (1,1) struct
    end
    methods
        function obj = StructField(varargin)
            obj@compiler.build.spark.schema.DataType();
            obj.type = 'structfield'; % Not used as others

            if nargin == 1 && isa(varargin{1},  'py.pyspark.sql.types.StructField')
                initStructField(obj, varargin{1});
                return;
            end
            if nargin >=3 && nargin <=4
                initSeparateFields(obj, varargin{:});
                return;
            end
                
            error("SPARK_API:bad_structfield_arguments", ...
                "Constructor arguments of these types are not yet supported.")

            % sf.name = name_;
            % sf.dataType = datatype_;
            % sf.nullable = nullable_;
            % % TODO: Do metadata another time
            % if isfield(options, 'metadata')
            %     sf.metadata = options.metadata;
            % end
        end

        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type

            so = struct(...
                "metadata", {obj.metadata}, ...
                "name", obj.name, ...
                "nullable", obj.nullable, ...
                "type", obj.dataType.toStruct() ...
                );
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            PT = obj.pythonType();
            PI = PT + "(" + ...
                "'" + obj.name + "', " + ...
                obj.dataType.pythonInitCode() + ", " + ...
                obj.pyTF(obj.nullable) + ...
                ... TODO: What about metadata?
                ")";
        end

    end
    methods (Access = private, Hidden)
        function initStructField(obj, PF)
                obj.name = string(PF.name);
                obj.dataType = compiler.build.spark.schema.DataType.createSchema(PF.dataType);
                obj.nullable = PF.nullable;
                % TODO: Handle metadata later
        end
        function initSeparateFields(obj, name, datatype, nullable, options)
            arguments
                obj (1,1) compiler.build.spark.schema.StructField
                name (1,1) string
                datatype (1,1) compiler.build.spark.schema.DataType
                nullable (1,1) logical
                options.metadata = struct
            end

            obj.name = name;
            obj.dataType = datatype;
            obj.nullable = nullable;
            obj.metadata = options.metadata;
        end

    end

end