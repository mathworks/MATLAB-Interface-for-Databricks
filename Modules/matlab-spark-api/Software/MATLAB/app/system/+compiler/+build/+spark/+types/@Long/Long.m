classdef Long < compiler.build.spark.types.ArgType
    % Long Class used for SparkBuilder datatype handling
    
    % Copyright 2021 The MathWorks, Inc.
    
    methods
        function obj = Long(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "int64";
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
                encInst = "Encoders.LONG";
            else
                encInst = "SparkUtilityHelper.longArrayEncoder(spark)";
            end
        end
        
        function str = convertMWToRetValue(obj,  srcData)
           if obj.isScalarData
               str = sprintf("((MWNumericArray) %s).getLong()", srcData);
           else
               str = sprintf("((MWNumericArray) %s).getLongData()", srcData);
           end
        end
        
        function str = pythonSchemaType(obj)
            % pythonSchemaType Return python spark schema type
            %
            % Special handling for Long.
            % See compiler.build.spark.types.ArgType/pythonSchemaType
            str = "bigint";
        end
        
    end
end