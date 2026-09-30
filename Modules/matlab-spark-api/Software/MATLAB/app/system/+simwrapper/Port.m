classdef (Abstract) Port < handle
    % Port Abstract class for ports
    properties (SetAccess = protected)
        PortNum (1,1) double
        Name (1,1) string
        PortData (1,1) RTW.DataInterface
    end
    properties (SetAccess = protected, Hidden)
        Parent
    end
    properties (Dependent)
        WrapperName (1,1) string
        GetterName (1,1) string
        SetterName (1,1) string
        DataType (1,1) string
        PYType  (1,1) string
        PYCType  (1,1) string
        MLType (1,1) string
        SparkType (1,1) string
        NPType (1,1) string
    end
    methods
        function obj = Port(idx, ioData, parent)
            arguments
                idx (1,1) double
                ioData (1,1) RTW.DataInterface
                parent (1,1) simwrapper.SimWrapper
            end
            obj.PortNum = idx;
            obj.Name = ioData.GraphicalName;
            obj.PortData = ioData;
            obj.Parent = parent;
            % obj.WrapperName = obj.Parent.
        end

        function tf = isInport(obj)
            tf = isa(obj, 'simwrapper.InPort');
        end

        function str = getGetterSignature(obj)
            retType = obj.DataType;
            rtmType = obj.Parent.getRTModelType();
            str = retType + " " + obj.GetterName + "(" + rtmType + "* rtm)";
        end
        function str = getSetterSignature(obj)
            rtmType = obj.Parent.getRTModelType();
            str = "void " + obj.SetterName + "(" + rtmType + "* rtm, " + obj.DataType + " val)";
        end
        function str = getVariableString(obj, refVar)
            if obj.isInport()
                direction = "inputs";
            else
                direction = "outputs";
            end
            str = refVar + "->" + direction + "->" + obj.Name;
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
        function str = get.DataType(obj)
            str = obj.PortData.Type.Identifier;
        end
        function str = get.PYType(obj)
            str = simwrapper.typeMapping(from="RTW", name=obj.DataType, to="PY");
        end
        function str = get.PYCType(obj)
            str = simwrapper.typeMapping(from="RTW", name=obj.DataType, to="PYC");
        end
        function str = get.MLType(obj)
            str = simwrapper.typeMapping(from="RTW", name=obj.DataType, to="ML");
        end
        function str = get.SparkType(obj)
            str = simwrapper.typeMapping(from="RTW", name=obj.DataType, to="Spark");
        end
        function str = get.NPType(obj)
            str = simwrapper.typeMapping(from="RTW", name=obj.DataType, to="NP");
        end
        
    end
end