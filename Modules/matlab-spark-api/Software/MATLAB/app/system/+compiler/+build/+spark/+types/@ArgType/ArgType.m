classdef ArgType < handle & matlab.mixin.Heterogeneous
    % ArgType Base class for argument types
    %
    % Subclasses are instances of specific data types, e.g. Double, Float,
    % Boolean, etc. The names of the Subclasses will coincide with the Java
    % type names.
    % Compound types may be be subclassed too, or simlpy created by virtue
    % of being an array.
    
    % Copyright 2021-2023 The MathWorks, Inc.

    properties
        Name string
    end
    
    properties (SetAccess = protected)
        MATLABType string
        Size double
        JavaType string
        PrimitiveJavaType string
        PythonType string
        SparkType string
        Encoder string
        MWClassID string
        MWget string
        MWType string
        RowGet string
    end

    properties (SetAccess = protected, Hidden)
        Parent
    end


    methods
        function obj = ArgType(sz, name)
            if nargin == 0
                sz = [1,1];
            end
            obj.Size = sz;
            if nargin > 1
                obj.Name = name;
            end
            init(obj);
        end

        function parent = getFileParent(obj)
            parent = obj.Parent;
            if ~isa(parent, "compiler.build.spark.File")
                % Recurse upwards if necessary
                parent = getFileParent(parent);
            end
        end

        function L = getVectorLength(obj)
            L = prod(obj.Size);
        end


        function ret = getMATLABHelperInputConversion(obj, srcData, isArray) %#ok
            % getMATLABHelperInputConversion Convert from different types
            % If this function returns an empty string, no conversion is
            % necessary. If the string is non-empty, it is used for the
            % conversion. 
            % In general, no conversion will be necessary, but if it is
            % necessary, that class (e.g. Timestamp) should overload
            % this method.
            ret = "";
        end

        function ret = getMATLABHelperOutputConversion(obj, srcData, isArray) %#ok
            % getMATLABHelperOutputConversion Convert from different types
            % If this function returns an empty string, no conversion is
            % necessary. If the string is non-empty, it is used for the
            % conversion. 
            % In general, no conversion will be necessary, but if it is
            % necessary, that class (e.g. Timestamp) should overload
            % this method.
            ret = "";
        end

        function ret = castLongColumnToValue(obj, srcData, isPython)
            % castLongColumnToValue Convert a long to a value of this type
            % This function is used for creating example code.
            % It will be subclassed in types with more complex conversions.
            % It assumes that the input is a Spark Column with type long
            if isPython
                ret = sprintf('%s.cast(%s())', srcData, obj.SparkType);
            else
                ret = sprintf('%s.cast(%s)', srcData, obj.SparkType);
            end
        end

        function ret = instantiateScalaExampleValue(obj, num, count)
            % instantiateScalaExampleValue Create example value for Scala
            %
            % This method is used to create example files with values
            % Many types can use the standard Scala way (toFloat,
            % toBoolean, etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.types.ArgType
                num (1,1) double
                count (1,1) double = 3
            end
            if obj.isScalarData
                ret = sprintf("%d.to%s", num, obj.JavaType);
            else
                ret = "Array(";
                for m=1:count
                    ret = ret + sprintf("%d.to%s%s", (num+m), obj.JavaType, obj.getComma(m, count));
                end
                ret = ret + ")";
            end
        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.types.ArgType
                num (1,1) double
                count (1,1) double = 3
            end
            if obj.isScalarData
                ret = sprintf("%s(%d)", obj.PythonType, num);
            else
                ret = "[";
                for m=1:count
                    ret = ret + sprintf("%s(%d)%s", obj.PythonType, (num+m), obj.getComma(m, count));
                end
                ret = ret + "]";
            end
        end

        

        function str = convertPythonValueForMW(obj, srcData)
            % convertPythonValueForMW
            %
            % Some datatypes will need to be converted to something that
            % MATLAB can understand. In general, the function will just
            % return the srcData string. For certain datatypes, like
            % timestamp (datetime.datetime in Python), the method will be
            % overridden in the class file (Timestamp.m).

            % if obj.isScalarData
            %     str = srcData;
            % else
                str = sprintf("matlab.%s(%s)", obj.MATLABType, srcData);

            % end
        end


        function str = createMWValueToJavaStatement(obj, srcData, retValName)
            % createMWValueToJavaStatement Statement(s) to convert MW to Java
            %
            % The Java return values from the MATLAB runtime need to be
            % converted to a non-MathWorks type. This may be done in one
            % single line, but for certain datatypes, it may need several
            % lines.
            % For simple cases, it will use the convertMWToRetValue method,
            % and for more complex conversions, this method may be
            % overridden in other classes.
            arguments
                obj (1,1) compiler.build.spark.types.ArgType 
                srcData (1,1) string
                retValName (1,1) string
            end

            SW = matlab.sparkutils.StringWriter();

            SW.pf("%s %s = %s;\n", ...
                obj.getReturnType, retValName, ...
                obj.convertMWToRetValue(srcData));

            str = SW.getString();
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return python spark schema type
            %
            % This function will return a schema type, which in many cases
            % coincide with the Java primitive type. In cases where this
            % differes, a suitably overridden method will be used.
            str = obj.PrimitiveJavaType;
        end

    end
    
    methods (Static)
        function obj = instantiate(typeName, varargin)
            switch lower(string(typeName))
                case "double"
                    javaType = "Double";
                case {"single", "float"}
                    javaType = "Float";
                case {"long", "int64"}
                    javaType = "Long";
                case {"int", "integer", "int32"}
                    javaType = "Integer";
                case {"short", "int16"}
                    javaType = "Short";
                case {"boolean", "logical"}
                    javaType = "Boolean";
                case "string"
                    javaType = "String";
                case "table"
                    javaType = "Table";
                case "datetime"
                    javaType = "Timestamp";
                otherwise
                    error("SparkBuilder:DataTypes", ...
                        "Unsupported datatype: '%s'\n", typeName);
                    
            end
            clsName = "compiler.build.spark.types." + javaType;
            obj = feval(clsName, varargin{:});
        end
    end
    
    methods (Abstract)
        encType = getEncoderType(obj)
        encInst = getEncoderInstantiation(obj)
        str = convertMWToRetValue(obj,  srcData)
    end
    
    methods (Sealed)

        function ret = isScalarData(obj)
            N = numel(obj);
            ret = zeros(N, 1, 'logical');
            for k=1:N
                ret(k) = getVectorLength(obj(k)) == 1;
            end
        end

        function types = getReturnTypes(obj)
            types = string.empty;
            for k=1:length(obj)
                types(k) = obj(k).getReturnType;
            end
        end
        
        function types = getFuncArgTypes(obj)
            types = string.empty;
            for k=1:length(obj)
                types(k) = obj(k).getFuncArgType;
            end
        end
        
        function retType = getReturnType(obj)
            retType = getEncoderType(obj);
        end
        
        function argType = getFuncArgType(obj)
            argType = getPrimitiveJavaType(obj);
        end
        
        function argType = getUDFFuncArgType(obj)
            if obj.isScalarData
                argType = obj.getFuncArgType();
            else
                argType = "WrappedArray<Object>";
            end
        end
        
        function str = getRowInputValue(obj, src, argName)
            primType = obj.getPrimitiveJavaType;
            if obj.isScalarData
                str = sprintf("%s %s = (%s) (%s);\n", ...
                    primType, argName, primType, src);
            else
                sw = matlab.sparkutils.StringWriter();
                tmpArg = argName + "_w";
                sw.pf("Object[] %s = SparkUtilityHelper.WrappedArrayRefToArray(%s).toArray();\n", tmpArg, src);
                sw.pf("%s[] %s = new %s[%s.length];\n", ...
                    obj.PrimitiveJavaType, argName, obj.PrimitiveJavaType, tmpArg);
                sw.pf("for (int k=0; k< %s.length; k++) {\n", argName);
                sw.indent();
                switch obj.JavaType
                    case "String"
                        sw.pf("%s[k] = (%s) %s[k];\n", ...
                            argName, obj.JavaType, tmpArg);
                    otherwise
                        sw.pf("%s[k] = ((%s) %s[k]).%sValue();\n", ...
                            argName, obj.JavaType, tmpArg, obj.PrimitiveJavaType);
                end
                sw.unindent();
                sw.pf("}\n");
                str = sw.getString();
            end
        end
        
        function mwType = getMWArgType(obj)
            mwType = obj.MWType;
        end
        
        function enc = getEncoderCreator(obj)
            if ~isscalar(obj)
                enc = string.empty();
                N = length(obj);
                for k=1:N
                   enc(k) = getEncoderCreator(obj(k)); 
                end
            else
                if obj.isScalarData
                    enc = sprintf("Encoders.%s()", obj.Encoder);
                else
                    switch obj.JavaType
                        case "Boolean"
                            enc = "SparkUtilityHelper.booleanArrayEncoder(spark)";
                        case "Double"
                            enc = "SparkUtilityHelper.doubleArrayEncoder(spark)";
                        case "Float"
                            enc = "SparkUtilityHelper.floatArrayEncoder(spark)";
                        case "Short"
                            enc = "SparkUtilityHelper.shortArrayEncoder(spark)";
                        case "Integer"
                            enc = "SparkUtilityHelper.intArrayEncoder(spark)";
                        case "Long"
                            enc = "SparkUtilityHelper.longArrayEncoder(spark)";
                        case "String"
                            enc = "SparkUtilityHelper.stringArrayEncoder(spark)";
                        otherwise
                            error("SparkAPI:Error", "Unsupported datatype for arrays: %s\n", obj.JavaType);
                    end
                end
            end
            
        end
        
        function str = getBoxedJavaValue(obj, srcData, castArgument)
            % instantiateMWValue - Instantiate MW type Java object
            % Arguments:
            %  src - a text string describing the variable to use
            %  castArgument [optional] - a boolean stating if explicit casting
            %  should be used, e.g. in case it is just an Object.
            %  Default value is false.
            
            if nargin < 3
                castArgument = false;
            end
            if castArgument
                castStr = sprintf("(%s)", obj.getJavaType);
            else
                castStr = "";
            end
            switch obj.JavaType
                case {"Boolean"}
                    if obj.isScalarData
                        str = sprintf("new java.lang.Boolean(%s%s)", ...
                        castStr, srcData);
                    else
                        str = sprintf("SparkUtilityHelper.WrappedArrayRefToArray(%s).toArray()", srcData);
                    end
                case {"String"}
                    if obj.isScalarData
                        str = sprintf("%s%s", ...
                            castStr, srcData);
                    else
                        str = sprintf("SparkUtilityHelper.WrappedArrayRefToArray(%s).toArray()", srcData);
                    end
                case {"Integer", "Double", "Float", "Long", "Short"}
                    if obj.isScalarData
                        str = sprintf("(%s%s)", castStr, srcData);
                    else
                        str = sprintf("SparkUtilityHelper.WrappedArrayRefToArray(%s).toArray()", srcData);
                    end
                case {"java.sql.Timestamp"}
                    %% TODO: Reconsider if casting may be necessary here.
                    str = sprintf("((%s%s).getTime())", castStr, srcData);
                otherwise
                    error("Spark:Error", "Unsupported MATLAB type, %s\n", obj.MATLABType);
            end
        end


        function str = instantiateMWValue(obj, srcData, castArgument)
            % instantiateMWValue - Instantiate MW type Java object
            % Arguments:
            %  src - a text string describing the variable to use
            %  castArgument [optional] - a boolean stating explicit casting
            %  should be used, e.g. in case it is just an Object.
            %  Default value is false.
            
            if nargin < 3
                castArgument = false;
            end
            if castArgument
                castStr = sprintf("(%s)", obj.getJavaType);
            else
                castStr = "";
            end
            switch obj.JavaType
                case {"Boolean", "String"}
                    str = sprintf("new %s(%s%s)", ...
                        obj.MWType, castStr, srcData);
                case {"Double", "Float", "Long", "Integer", "Short"}
                    str = sprintf("new %s(%s%s, %s)", ...
                        obj.MWType, castStr, srcData, obj.MWClassID);
                case {"java.sql.Timestamp"}
                    str = sprintf("new %s(%s.getTime(), MWClassID.INT64)", obj.MWType, srcData);
                otherwise
                    error("Spark:Error", "Unsupported MATLAB type, %s\n", obj.MATLABType);
            end
        end
        
        function str = declareAndSetRowValue(obj, srcData, inArgName)
            inArgType = obj.getFuncArgType;
            if obj.isScalarData
                str = sprintf("%s %s = (%s) (%s);\n", ...
                    inArgType, inArgName, inArgType, srcData);
            else
                sw = matlab.sparkutils.StringWriter();
                tmpArg = inArgName + "_w";
                sw.pf("Object[] %s = SparkUtilityHelper.WrappedArrayRefToArray(%s).toArray();\n", tmpArg, srcData);
                sw.pf("%s %s = new %s[%s.length];\n", ...
                    inArgType, inArgName, obj.PrimitiveJavaType, tmpArg);
                sw.pf("for (int k=0; k< %s.length; k++) {\n", inArgName);
                sw.indent();
                % TODO: Add some method like unboxArrayElement
                switch obj.JavaType
                    case "String"
                        sw.pf("%s[k] = (%s) %s[k];\n", ...
                            inArgName, obj.JavaType, tmpArg);
                    otherwise
                        sw.pf("%s[k] = ((%s) %s[k]).%sValue();\n", ...
                            inArgName, obj.JavaType, tmpArg, obj.PrimitiveJavaType);
                end
                sw.unindent();
                sw.pf("}\n");
                str = sw.getString();
            end
        end
        
        function ret = pythonInputArgumentNeedsCasting(obj)
            ret = false;
            if (~obj.isScalarData())
                if obj.MATLABType == "string"
                    ret = false;
                else
                    % Cast numerical arrays
                    ret = true;
                end

                return;
            else
                if (obj.MATLABType == "int32" || obj.MATLABType == "int16")
                    ret = true;
                end
            end
        end

        function T = getJavaType(obj)
            if ~isscalar(obj)
                T = string.empty();
                N = length(obj);
                for k=1:N
                    T(k) = getJavaType(obj(k));
                end
            else
                T = obj.JavaType;
                if ~isScalarData(obj)
                    T = T + "[]";
                end
            end
        end

        function primitiveName = getPrimitiveJavaType(obj)
            if ~isscalar(obj)
                primitiveName = string.empty();
                N = length(obj);
                for k=1:N
                    primitiveName(k) = getPrimitiveJavaType(obj(k));
                end
            else
                primitiveName = obj.PrimitiveJavaType;
                if ~isScalarData(obj)
                    primitiveName = primitiveName + "[]";
                end
            end
        end

        function str = getSparkTypeConstructor(obj)
            % getSparkTypeConstructor Return UDF style constructor
            % When defining a UDF, the return type can be indicated by a
            % Spark type
            str = sprintf("%s()", obj.SparkType);
            if ~obj.isScalarData
                str = sprintf("ArrayType(%s)", str);
            end
        end
    end
    
    methods (Hidden)
        function setParent(obj, parent)
            obj.Parent = parent;
        end
    end

    methods (Access = private)
        function init(obj)
            cls = string(class(obj));
            parts = cls.split(".");
            if parts(end)=="Table"
                % Tables are handled separately
                return;
            end
            E = matlab.sparkutils.datatypeMapper("java", parts(end));
            obj.JavaType = E.JavaType;
            obj.PrimitiveJavaType = E.PrimitiveJavaType;
            obj.PythonType = E.PythonType;
            obj.SparkType = E.SparkType;
            obj.Encoder = E.Encoders;
            obj.MWClassID = E.MWClassID;
            obj.MWget = E.MWget;
            obj.MWType = E.MWType;
            obj.RowGet = E.RowGet;
        end
    end
end


