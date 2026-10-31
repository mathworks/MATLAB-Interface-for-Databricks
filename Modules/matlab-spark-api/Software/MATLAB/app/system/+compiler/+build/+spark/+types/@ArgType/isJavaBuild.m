function ret = isJavaBuild(obj)
    % isJavaBuild Return true if build type is Java

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.types.ArgType
    end

    ret = isJavaBuild(obj.getFileParent);
end

