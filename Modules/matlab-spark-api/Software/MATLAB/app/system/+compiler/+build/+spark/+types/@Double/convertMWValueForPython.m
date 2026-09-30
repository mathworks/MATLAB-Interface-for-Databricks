function str = convertMWValueForPython(obj, srcData)
    % convertMWValueForPython
    %
    % See compiler.build.spark.types.ArgType/convertMWValueForPython

    % Copyright 2021-2023 The MathWorks, Inc.

    if obj.isScalarData
        str = srcData;
    else
        str = sprintf("[%s] if isinstance(%s, float) else %s.tomemoryview().tolist()[0]", ...
            srcData, srcData, srcData);
    end
end
