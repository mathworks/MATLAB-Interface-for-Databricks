classdef Timestamp < compiler.build.spark.types.ArgType
    % Double Class used for SparkBuilder datatype handling

    % Copyright 2021-2023 The MathWorks, Inc.

    methods
        function obj = Timestamp(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "datetime";
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
                encInst = "Encoders.TIMESTAMP";
            else
                error('SPARKAPI:Unimplemented', 'This type combination is not yet implemented');
                % encInst = "SparkUtilityHelper.doubleArrayEncoder(spark)";
            end
        end

        function str = convertMWToRetValue(obj,  srcData)
            if obj.isScalarData
                str = sprintf("new java.sql.Timestamp(((MWNumericArray) %s).getLong())", srcData);
            else
                error('SPARKAPI:Unimplemented', 'This type combination is not yet implemented');
                % str = sprintf("((MWNumericArray) %s).getLongData()", srcData);
            end
        end

        function ret = getMATLABHelperInputConversion(obj, srcData, isArray)
            % getMATLABHelperInputConversion Convert from different types
            %
            % See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion
            ret = sprintf("%s = datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1000);", ...
                srcData, srcData);
        end

        function ret = getMATLABHelperOutputConversion(obj, srcData, isArray)
            ret = sprintf("%s = convertTo(%s, 'epochtime', 'TicksPerSecond', 1000);", ...
                srcData, srcData);
        end

        function ret = castLongColumnToValue(obj, srcData, isPython)
            % castLongColumnToValue A helper function to create test data
            %
            % The number 1602306305 simply corresponds to the date
            % 2020-10-10T05:05:05, and was used to have something else than
            % starting at 1970. It has no deeper meaning.
            if isPython
                ret = sprintf('(%s + lit(1602306305)).cast(%s())', srcData, obj.SparkType);
            else
                ret = sprintf('(%s + lit(1602306305L)).cast(%s)', srcData, obj.SparkType);
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
                ret = sprintf("new java.sql.Timestamp(1600306305000L + %d.toLong)", num);
            else
                ret = "Array(";
                for m=1:count
                    ret = ret + sprintf("new java.sql.Timestamp(1600306305000L + %d.toLong)%s", (num+m*10), obj.getComma(m, count));
                end
                ret = ret + ")";
            end
        end

        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % See compiler.build.spark.types.ArgType/instantiatePythonExampleValue
            arguments
                obj (1,1) compiler.build.spark.types.ArgType
                num (1,1) double
                count (1,1) double = 3
            end
            if obj.isScalarData
                ret = sprintf("datetime.datetime.fromtimestamp(1602306305 + %d)", num);
            else
                ret = "[";
                for m=1:count
                    ret = ret + sprintf("datetime.datetime.fromtimestamp(1602306305 + %d)%s", num+m, obj.getComma(m, count));
                end
                ret = ret + "]";
            end
        end

        function codeOut = convertIntermediateColumnForRuntime(obj, codeIn)
            % convertIntermediateColumnForRuntime Convert columns
            %
            % See also compiler.build.spark.types.ArgType/convertIntermediateColumnForRuntime

            if obj.isScalarData
                codeOut = sprintf("matlab.int64(%s)", codeIn);
            else
                codeOut = codeIn;
            end
        end

        function str = convertPythonValueForMW(obj, srcData)
            % convertPythonValueForMW
            %
            % Special handling for timestamps.
            % See compiler.build.spark.types.ArgType/convertPythonValueForMW

            str = sprintf("int(%s.timestamp()*1000.0)", srcData);
        end


        function str = pythonSchemaType(obj)
            % pythonSchemaType Return python spark schema type
            %
            % Special handling for timestamps.
            % See compiler.build.spark.types.ArgType/pythonSchemaType
            str = "timestamp";
        end

    end
end
