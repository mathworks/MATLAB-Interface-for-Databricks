classdef String < compiler.build.spark.types.ArgType
    % String Class used for SparkBuilder datatype handling

    % Copyright 2021-2024 The MathWorks, Inc.

    methods
        function obj = String(varargin)
            obj@compiler.build.spark.types.ArgType(varargin{:});
            obj.MATLABType = "string";
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
            if compiler.build.spark.internal.hasMWStringArray
                if obj.isScalarData
                    str = sprintf("(String)((MWStringArray) %s).get(1)", srcData);
                else
                    str = sprintf("(String[])((MWStringArray) %s).getData()", srcData);
                end
            else
                if obj.isScalarData
                    str = sprintf("(String)((MWCharArray) %s).toString()", srcData);
                else
                    %% BUGFIX - NOT WORKING - WORKAROUND TO TEST COMPILATION
                    str = sprintf('{"Hello AST"}');
                    % error("SparkBuilder:UnsupportedType", ...
                    %     "String arrays are not supported in versions earlier than R2020b\n");
                end
            end
        end

        function str = createMWValueToJavaStatement(obj, srcData, retValName)
            % createMWValueToJavaStatement Statement(s) to convert MW to Java
            %
            % See compiler.build.spark.types.ArgType/createMWValueToJavaStatement
            arguments
                obj (1,1) compiler.build.spark.types.ArgType
                srcData (1,1) string
                retValName (1,1) string
            end

            SW = matlab.sparkutils.StringWriter();
            nArgOut = obj.getFileParent.nArgOut;

            if compiler.build.spark.internal.hasMWStringArray
                if obj.isScalarData
                    tmpStr = sprintf("(String)((MWStringArray) %s).get(1)", srcData);
                else
                    tmpStr = sprintf("(String[])((MWStringArray) %s).getData()", srcData);
                end
                SW.pf("%s %s = %s;\n", ...
                    obj.getReturnType, retValName, tmpStr);
            else
                if true
                    if obj.isScalarData
                        tmpStr = sprintf("(String)((MWCharArray) %s).toString()", srcData);
                        SW.pf("%s %s = %s;\n", ...
                            obj.getReturnType, retValName, tmpStr);
                    else
                        lenName = sprintf("mwca_%s_len", retValName);
                        SW.pf("Integer %s = %s.numberOfElements();\n", lenName, srcData);
                        SW.pf("%s %s = new String[%s];\n", ...
                            obj.getReturnType, retValName, lenName);
                        SW.pf("for (int mwarr_idx = 0; mwarr_idx < %s; mwarr_idx++) {\n", lenName);
                        SW.indent();
                        SW.pf("MWCharArray caElem = (MWCharArray) %s.getCell(mwarr_idx+1);\n", srcData);
                        SW.pf("%s[mwarr_idx] = caElem.toString();\n", retValName);
                        SW.unindent();
                        SW.pf("}\n");
                    end
                else
                    if obj.isScalarData
                        tmpStr = sprintf("(String)((MWCharArray) %s).toString()", srcData);
                        SW.pf("%s %s = %s;\n", ...
                            obj.getReturnType, retValName, tmpStr);
                    else

                        if nArgOut == 1
                            SW.pf("// To be continued ...\n");
                            lenName = sprintf("mwca_%s_len", retValName);
                            SW.pf("Integer %s = %s.numberOfElements();\n", lenName, srcData);
                            SW.pf("%s %s = new String[%s];\n", ...
                                obj.getReturnType, retValName, lenName);
                            % SW.pf("for (int mwarr_idx = 0; mwarr_idx < %s; mwarr_idx++) {\n", lenName);
                            % SW.indent();
                            % SW.pf("MWCharArray caElem = (MWCharArray) %s.getCell(mwarr_idx+1);\n", srcData);
                            % SW.pf("%s[mwarr_idx] = caElem.toString();\n", retValName);
                            % SW.unindent();
                            % SW.pf("}\n");
                        else
                            mwarr = sprintf("mwca_%s", retValName);
                            mwarr_len = sprintf("%s_len", mwarr);
                            SW.pf("MWCellArray %s = (MWCellArray) %s;\n\n", mwarr, srcData);
                            SW.pf("Integer %s = %s.numberOfElements();\n", mwarr_len, mwarr);
                            SW.pf("%s %s = new String[%s];\n", ...
                                obj.getReturnType, retValName, mwarr_len);
                            SW.pf("for (int mwarr_idx = 0; mwarr_idx < %s; mwarr_idx++) {\n", mwarr_len);
                            SW.indent();
                            SW.pf("MWCharArray caElem = (MWCharArray) %s.getCell(mwarr_idx+1);\n", mwarr);
                            SW.pf("%s[mwarr_idx] = caElem.toString();\n", retValName);
                            SW.unindent();
                            SW.pf("}\n");
                        end
                        % SW.unindent();
                        % SW.pf("}\n");
                    end
                end
            end



            str = SW.getString();

        end


        function codeOut = convertIntermediateColumnForRuntime(obj, codeIn, lenStr) %#ok<INUSD>
            % convertIntermediateColumnForRuntime Convert columns
            %
            % See also compiler.build.spark.types.ArgType/convertIntermediateColumnForRuntime

            codeOut = codeIn;
        end

        function ret = getMATLABHelperInputConversion(obj, srcData, isArray) %#ok<INUSD>
            % getMATLABHelperInputConversion Convert from different types
            %
            % See compiler.build.spark.types.ArgType/getMATLABHelperInputConversion

            ret = sprintf("%s = string(%s);", ...
                srcData, srcData);
        end

        function ret = getMATLABHelperOutputConversion(obj, srcData, isArray) %#ok<INUSD>
            % getMATLABHelperOutputConversion Convert from different types
            %
            % See compiler.build.spark.types.ArgType/getMATLABHelperOutputConversion
            if nargin < 3
                isArray = true;
            end
            if ~isArray
                ret = "";
            else
                ret = "";
                % Python should be able to handle string datatype.
                % Being a cell array, it's already a cell array of
                % strings.
                % ret = sprintf("%s = cellstr(%s);", ...
                %     srcData, srcData);
            end
        end

        function ret = castLongColumnToValue(obj, srcData, isPython)
            if isPython
                ret = sprintf('concat(lit("%s_"), (%s %% 7).cast(%s()))', obj.Name, srcData, obj.SparkType);
            else
                ret = sprintf('concat(lit("%s_"), (%s.mod(7)).cast(%s))', obj.Name, srcData, obj.SparkType);
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
                ret = sprintf("str(%d)", num);
            else
                ret = "[";
                for m=1:count
                    ret = ret + sprintf("str(%d)%s", num+m, obj.getComma(m, count));
                end
                ret = ret + "]";
            end
        end

        function str = convertPythonValueForMW(obj, srcData)
            % convertPythonValueForMW
            %
            % See compiler.build.spark.types.ArgType/convertPythonValueForMW
            str = srcData;
        end


    end
end
