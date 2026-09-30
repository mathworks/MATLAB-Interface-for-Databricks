classdef Boolean < compiler.build.spark.types.ArgType
    % Boolean Class used for SparkBuilder datatype handling

    % Copyright 2021-2023 The MathWorks, Inc.

    methods
        function obj = Boolean(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "logical";
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
                encInst = "Encoders.BOOLEAN";
            else
                encInst = "SparkUtilityHelper.booleanArrayEncoder(spark)";
            end
        end

        function str = convertMWToRetValue(obj,  srcData)
            if obj.isScalarData
                str = sprintf("((MWLogicalArray) %s).getBoolean(1)", srcData);
            else
                str = sprintf("(boolean[])((MWLogicalArray) %s).getData()", srcData);
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
                ret = sprintf("%d.toInt %%2 == 0", num);
            else
                ret = "Array(";
                for m=1:count
                    ret = ret + sprintf("%d.toInt %%2 == 0%s", (num+m*10), obj.getComma(m, count));
                end
                ret = ret + ")";
            end

        end

    end
end