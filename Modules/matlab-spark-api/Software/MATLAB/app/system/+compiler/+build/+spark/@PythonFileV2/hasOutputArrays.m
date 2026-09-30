function ret = hasOutputArrays(file)
    % hasOutputArrays Returns true if there are arrays in the output columns

    % Copyright 2022-2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end
    ret = false;
    if file.nArgOut == 0
        return;
    end
    outTypes = file.getOutputElements(useData=true);

    ret = ~all(arrayfun(@isScalarData, outTypes));

end
