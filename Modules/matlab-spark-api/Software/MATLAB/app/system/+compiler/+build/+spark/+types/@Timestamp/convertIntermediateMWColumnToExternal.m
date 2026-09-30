function code = convertIntermediateMWColumnToExternal(obj, srcData, varName, idx)
    % convertIntermediateMWColumnToExternal Convert MW Column to external type
    %
    % See compiler.build.spark.types.ArgType/convertIntermediateMWColumnToExternal

    % Copyright 2023 The MathWorks, Inc.

    SW = matlab.sparkutils.StringWriter();

    if obj.isScalarData
        SW.pf("%s %s = new %s(%s.getLong(%s));\n", ...
            obj.getReturnType, varName, obj.getReturnType, ...
            srcData, idx);
    else
        SW.pf("%s %s;\n", obj.getReturnType, varName);
    end

    code = SW.getString();
end