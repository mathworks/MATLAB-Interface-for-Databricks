function str = convertMWValueForPython(obj, srcData)
    % convertMWValueForPython
    %
    % Special handling for timestamps.
    % See compiler.build.spark.types.ArgType/convertMWValueForPython

    % Copyright 2023 The MathWorks, Inc.

    str = sprintf('datetime.datetime.fromtimestamp(%s/1000)', srcData);

end
