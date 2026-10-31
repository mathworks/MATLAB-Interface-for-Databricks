function name = getHelperFcnName(obj, mt)
    % getHelperFcnName Return name of helper function (MATLAB)

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.File
        mt (1,1) compiler.build.spark.MethodType
    end

    name = obj.funcName + "_" + string(mt);

end