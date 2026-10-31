function resultType = getMWResultType(obj)
    % getMWResultType  Get the result type
    %
    % This returns the type, as a call to a compiled Jar would return the
    % type. In general, it's the 

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.types.ArgType %#ok<INUSA> 
    end

    if obj.isScalarData
        resultType = obj.getMWArgType;
    else
        resultType = "MWCellArray";
    end

end