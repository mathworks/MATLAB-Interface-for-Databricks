function name = getBuildType(obj)
    % getBuildType Return type of build, "java" or "python"

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.File
    end

    if obj.isJavaBuild
        name = "java";
    elseif obj.isPythonBuild
        name = "python";
    else
        error("SPARKAPI:unkwown_sparkbuilder_type", ...
            "The build type can only be java or python.");
    end

end