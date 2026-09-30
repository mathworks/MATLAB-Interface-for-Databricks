classdef (Abstract) DataType < handle & matlab.mixin.Heterogeneous
    % DataType Implementation for types in Coder workflow

    % Copyright 2025 The MathWorks, Inc.

    properties (SetAccess=protected)
        Name  string
        DT (1,1) string
        PYType (1,1) string
        PYCType (1,1) string
        MLType (1,1) string
        SparkType (1,1) string
        NPType (1,1) string
    end
    properties (Hidden)
        Parent
    end
    properties (Dependent)
        WrapperName (1,1) string
        GetterName (1,1) string
        SetterName (1,1) string
    end
    methods
        function obj = DataType(ciPort)
            arguments
                ciPort (1,1) RTW.DataInterface
            end
            obj.DT = ciPort.Type.Identifier;
        end

        function parent = getRoot(obj)
            parent = obj.Parent;
            if isa(parent, 'matlab.coder.pandas.data.DataType')
                parent = getRoot(parent);
            end
        end

        function str = getGetterSignature(obj)
            retType = obj.DT;
            rtmType = obj.Parent.getRTModelType();
            str = retType + " " + obj.GetterName + "(" + rtmType + "* rtm)";
        end
        function str = getSetterSignature(obj)
            rtmType = obj.getRoot.getRTModelType();
            str = "void " + obj.SetterName + "(" + rtmType + "* rtm, " + obj.DT + " val)";
        end

        function funcName = genPythonExampleFunction(obj, sw)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) matlab.coder.pandas.data.DataType
                sw (1,1) matlab.sparkutils.StringWriter
            end
            error('simpandas:unimplemented', 'Implement this in a concrete subclass');
        end

        function str = colName(obj)
            arguments
                obj matlab.coder.pandas.data.DataType
            end
            N = numel(obj);
            str = strings(1, N);
            for k=1:N
                str(k) = colName_(obj(k));
            end
        end

        function parentName = getParentColName(obj)
            % getParentColName Helper function for column name
            % This is needed, to ascertain if a function's parent is, for
            % example, the key in a map. This has an influence in creating
            % unique column names.
            arguments
                obj (1,1) matlab.coder.pandas.data.DataType
            end

            if hasDataTypeParent(obj)
                parentName = colName_(obj.Parent);
            else
                parentName = "C_";
            end

            % Look for special cases, like MAPS:
            if isa(obj.Parent, 'matlab.coder.pandas.data.MapType')
                if isequal(obj, obj.Parent.keyType)
                    parentName = parentName + "KEY";
                else
                    parentName = parentName + "VAL";
                end
            elseif isa(obj.Parent, 'matlab.coder.pandas.data.ArrayType')
                parentName = parentName + "ARR";
            end
        end

        function cName = colName_(obj)
            arguments
                obj (1,1) matlab.coder.pandas.data.DataType
            end

            cName = sprintf("%s%s_", obj.getParentColName(), obj.Name);
        end

        function tf = hasDataTypeParent(obj)
            arguments
                obj (1,1) matlab.coder.pandas.data.DataType
            end
            tf = isa(obj.Parent, 'matlab.coder.pandas.data.DataType');
        end


    end

    methods (Static)
        function obj = createFromDataInterface(ciPort)
            arguments
                ciPort (1,1) RTW.DataInterface
            end
            dt = ciPort.Type.Identifier;
            switch dt
                case 'real_T'
                    obj = matlab.coder.pandas.data.DoubleType(ciPort);
                case 'real32_T'
                    obj = matlab.coder.pandas.data.FloatType(ciPort);
                case 'int64_T'
                    obj = matlab.coder.pandas.data.LongType(ciPort);
                case 'int32_T'
                    obj = matlab.coder.pandas.data.IntegerType(ciPort);
                case 'int16_T'
                    obj = matlab.coder.pandas.data.ShortType(ciPort);
                case 'boolean_T'
                    obj = matlab.coder.pandas.data.BooleanType(ciPort);
                otherwise
                    error('Unsupported data type: %s', dt);
            end
            obj.Name = ciPort.GraphicalName;
        end
    end
    methods % Dependent methods
        function str = get.WrapperName(obj)
            str = obj.Parent.WrapperName;
        end
        function str = get.GetterName(obj)
            str = obj.WrapperName + "_get_" + obj.Name;
        end
        function str = get.SetterName(obj)
            str = obj.WrapperName + "_set_" + obj.Name;
        end
    end
end