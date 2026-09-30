classdef Double < compiler.build.spark.types.ArgType
    % Double Class used for SparkBuilder datatype handling
    
    % Copyright 2021 The MathWorks, Inc.
    
    methods
        function obj = Double(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "double";
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
                encInst = "Encoders.DOUBLE";
            else
                encInst = "SparkUtilityHelper.doubleArrayEncoder(spark)";
            end
        end
        
        function str = convertMWToRetValue(obj,  srcData)
           if obj.isScalarData
               str = sprintf("((MWNumericArray) %s).getDouble()", srcData);
           else
               str = sprintf("((MWNumericArray) %s).getDoubleData()", srcData);
           end
        end
                
    end
end