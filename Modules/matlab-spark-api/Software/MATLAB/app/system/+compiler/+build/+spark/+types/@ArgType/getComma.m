function comma = getComma(obj, idx, maxIdx)
    % getComma Return a comma unless last idx

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.types.ArgType %#ok<INUSA> 
        idx (1,1) double
        maxIdx (1,1) double
    end

    if idx == maxIdx
        comma = "";
    else
        comma = ", ";
    end

end