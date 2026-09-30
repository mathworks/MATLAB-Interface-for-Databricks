classdef Integer < compiler.build.spark.types.ArgType
    % Integer Class used for SparkBuilder datatype handling
    
    % Copyright 2021 The MathWorks, Inc.
    
    methods
        function obj = Integer(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "int32";
        end
        function encType = getEncoderType(obj)
            if obj.isScalarData
                encType = obj.getJavaType;
            else
                encType = obj.getPrimitiveJavaType;
            end
        end
        function encInst = getEncoderInstantiation(obj)
            if obj.isScalarData
                encInst = "Encoders.INT";
            else
                encInst = "SparkUtilityHelper.intArrayEncoder(spark)";
            end
        end
        
        function ret = castLongColumnToValue(obj, srcData, isPython)
            if isPython
                ret = sprintf('(%s %% 20).cast(%s())', srcData, obj.SparkType);
            else
                ret = sprintf('(%s %% 20).cast(%s)', srcData, obj.SparkType);
            end
        end


        function str = convertMWToRetValue(obj,  srcData)
           if obj.isScalarData
               str = sprintf("((MWNumericArray) %s).getInt()", srcData);
           else
               str = sprintf("((MWNumericArray) %s).getIntData()", srcData);
           end
        end
        
        function ret = instantiateScalaExampleValue(obj, num, count)
            % instantiateScalaExampleValue Create example value for Scala
            %
            % See compiler.build.spark.types.ArgType/instantiateScalaExampleValue
            arguments
                obj (1,1) compiler.build.spark.types.ArgType
                num (1,1) double
                count (1,1) double = 3
            end
    
            if obj.isScalarData
                ret = sprintf("%d.toInt", num);
            else
                ret = "Array(";
                for m=1:count
                    ret = ret + sprintf("%d.toInt%s", (num+m), obj.getComma(m, count));
                end
                ret = ret + ")";
            end

        end

        function ret = getMATLABHelperInputConversion(obj, srcData, isArray)
            % getMATLABHelperInputConversion Convert from different types
            %
            % See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion

            % This conversion is only necessary for Python
            if obj.isPythonBuild
                ret = sprintf("%s = int32(%s);", srcData, srcData);
            else
                ret = "";
            end
        end
                    

    end
end