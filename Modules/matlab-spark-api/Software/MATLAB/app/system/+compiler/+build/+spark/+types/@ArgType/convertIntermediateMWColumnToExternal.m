function code = convertIntermediateMWColumnToExternal(obj, srcData, varName, idx)
    % convertIntermediateMWColumnToExternal Convert MW Column to external type
    %
    % Functions like x_mapPartitions will return the columns of a specific
    % table. These columns must be converted to an array of rows for the
    % external platform, which can then be changed to an iterator.
    % This is a general solution, and if needed, subclasses will provide
    % their own implementations.

    % Copyright 2023 The MathWorks, Inc.

    SW = matlab.sparkutils.StringWriter();

    if obj.isScalarData
        SW.pf("%s %s = %s.%s(%s);\n", ...
            obj.getReturnType, varName, ...
            srcData, obj.RowGet, idx);
    else
        mwArr = sprintf("%s.getCell(k)", srcData);
        SW.pf("%s %s = %s;\n", ...
            obj.getReturnType, varName, obj.convertMWToRetValue(mwArr));
    end

    code = SW.getString();
end