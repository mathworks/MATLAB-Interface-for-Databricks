function str = convertMWValueForPython(obj, srcData)
    % convertMWValueForPython
    %
    % Some datatypes will need to be converted from a MATLAB value
    % to the corresponding Python value.
    % In general, the function will just return the srcData string.
    % For certain datatypes, like timestamp (datetime.datetime in
    % Python), the method will be overridden in the class file
    % (Timestamp.m).

    % Copyright 2023 The MathWorks, Inc.

    if obj.isScalarData
        str = srcData;
    else
        str = sprintf("%s.tomemoryview().tolist()[0]", srcData);
    end
end
