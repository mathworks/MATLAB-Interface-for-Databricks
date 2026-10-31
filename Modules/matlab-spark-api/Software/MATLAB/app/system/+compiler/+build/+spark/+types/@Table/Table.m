classdef Table < compiler.build.spark.types.ArgType
    % Table Class used for SparkBuilder datatype handling
    
    % Copyright 2022 The MathWorks, Inc.
    
    properties
        TableCols (1,:) compiler.build.spark.types.ArgType
        names (1,:) string
        types (1,:) string
        sizes (1,:) cell
    end

    methods
        function obj = Table(varargin)
            % obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "table";
            initTable(obj, varargin{1});
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
     
        function initTable(obj, args)
            N = length(args);
            for k=1:N
                arg = args{k};
                tc = compiler.build.spark.types.ArgType.instantiate(arg{:});
                tc.setParent(obj);
                obj.TableCols(k) = tc;

                % TODO: The following can probably be removed later
                obj.types(k) = string(arg{1});
                obj.sizes{k} = arg{2};
                obj.names(k) = string(arg{3});
            end
        end
    end

end