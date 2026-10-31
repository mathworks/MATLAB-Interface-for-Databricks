classdef IOType < compiler.build.spark.schema.mathworks.NonSparkType
    % IOType part of the Schema definitions
    %
    % Due to the fact that certain classes, not part of the Spark schemas, are 
    % needed to define certain aspects (file/function, inputs/outputs). this
    % class was created.
    % This class represents an Input or an Output
    
    % Copyright 2024-2025 The MathWorks, Inc.
     
    properties
        Name (1,1) string
        Direction (1,1) string
        SparkType compiler.build.spark.schema.DataType
        Table (1,1) logical = false
    end

    methods
        function obj = IOType(varargin)
            obj@compiler.build.spark.schema.mathworks.NonSparkType();
            obj.type = "io";

            if nargin == 0
                return;
            end
            if nargin >=3 && nargin <=4
                init3_4(obj, varargin{:});
                return;
            end

            error("SPARKAPI:iotype_constructor_arguments", ...
                "Unsupported arguments for IOType constructor");
        end

        function val = toStruct(obj)
            val = struct(...
                "type", obj.type, ...
                "Name", obj.Name, ...
                "Direction", obj.Direction, ...
                "Table", obj.Table, ...
                "SparkType", obj.SparkType.toStruct ...
                );
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            %
            % This is usually existent only for DataType classes and its
            % children. This is used as a helper for cases where scalar
            % inputs are being used.
            %
            % It should be called directly with an IOType array
            arguments
                obj compiler.build.spark.schema.mathworks.IOType
            end
            SW = matlab.sparkutils.StringWriter();
            % dfSchema = StructType([StructField('v1', ShortType(), True), StructField('v2', ArrayType(ShortType(), True), True)])
            SW.pf("StructType([");
            N = numel(obj);
            for k=1:N
                SW.pf("StructField('%s', %s, True)", obj(k).Name, obj(k).SparkType.pythonInitCode);
                if k<N, SW.pf(", "); end
            end
            SW.pf("])")
            PI = SW.getString();
        end


        function obj = fromVal(obj, val)
            obj.Name = val.Name;
            obj.Direction = val.Direction;
            obj.Table = val.Table;
            obj.SparkType = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(val.SparkType);
        end

    end

    methods (Access=protected)
        function init3_4(obj, name, direction, type_, isTable)
            arguments
                obj (1,1) compiler.build.spark.schema.mathworks.IOType
                name (1,1) string
                direction (1,1) string
                type_ compiler.build.spark.schema.DataType
                isTable (1,1) logical = false
            end
            obj.Name = name;
            obj.Direction = direction;
            obj.SparkType = type_;
            obj.Table = isTable;
        end
        
    end


end