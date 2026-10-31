function ret = isPythonBuild(obj)
    % isPythonBuild Return true if build type is Python

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.types.ArgType
    end

    ret = isPythonBuild(obj.getFileParent);
end

