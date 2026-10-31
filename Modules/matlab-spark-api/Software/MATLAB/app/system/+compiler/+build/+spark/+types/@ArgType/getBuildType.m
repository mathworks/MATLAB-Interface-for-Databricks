function name = getBuildType(obj)
    % getBuildType Return type of build, "java" or "python"

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.types.ArgType
    end

    parent = obj.getFileParent();

    name = parent.getBuildType();

end