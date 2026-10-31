classdef Short < compiler.build.spark.types.ArgType
    % Short Class used for SparkBuilder datatype handling
    
    % Copyright 2021 The MathWorks, Inc.
    
    methods
        function obj = Short(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "int16";
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
                encInst = "Encoders.SHORT";
            else
                encInst = "SparkUtilityHelper.shortArrayEncoder(spark)";
            end
        end
        
        function str = convertMWToRetValue(obj,  srcData)
           if obj.isScalarData
               str = sprintf("((MWNumericArray) %s).getShort()", srcData);
           else
               str = sprintf("((MWNumericArray) %s).getShortData()", srcData);
           end
        end

        function ret = getMATLABHelperInputConversion(obj, srcData, isArray)
            % getMATLABHelperInputConversion Convert from different types
            %
            % See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion

            % This conversion is only necessary for Python
            if obj.isPythonBuild
                ret = sprintf("%s = int16(%s);", srcData, srcData);
            else
                ret = "";
            end
        end
        
    end
end