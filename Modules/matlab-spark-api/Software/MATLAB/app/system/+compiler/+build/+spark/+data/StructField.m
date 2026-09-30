classdef StructField < compiler.build.spark.data.DataType
    % StructField Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    properties
        name (1,1) string
        dataType compiler.build.spark.data.DataType
        nullable (1,1) logical
        metadata (1,1) struct
    end
    
    properties (Hidden)
        FieldIdx_ (1,1) double
    end

    methods
        function obj = StructField(varargin)
            obj@compiler.build.spark.data.DataType(varargin{:});
            obj.type = "structfield"; % Not used as others
            if nargin > 0
                S = varargin{1};
                obj.name = S.name;
                obj.nullable = S.nullable;
                obj.metadata = S.metadata;
                obj.dataType = compiler.build.spark.data.fromSchema(S.dataType, parent=obj);
            end
        end

        function cName = colName_(obj)
            arguments
                obj (1,1) compiler.build.spark.data.StructField
            end

            % A StructField always has a Parent
            cName = sprintf("%sF%d_", obj.getParentColName(), obj.FieldIdx_);
        end

        function tf = isLeaf(obj)
            % isLeaf Returns true for a leaf in the tree
            arguments
                obj (1,1) compiler.build.spark.data.StructField
            end
            % Consider have this look at its child instead.
            tf = false;
        end

        function codeOut = getPyPandasSeriesConverterCtor(obj)
            converterArg = obj.dataType.getPyPandasSeriesConverterCtor();
            codeOut = compose("FieldConverter('%s', %s)",  obj.name, converterArg);
        end

        function codeOut = getMLPandasSeriesConverterCtor(obj)
            converterArg = obj.dataType.getMLPandasSeriesConverterCtor();
            codeOut = compose("StructField('%s', %s)", obj.name, converterArg);
        end

        
    end

end