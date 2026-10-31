function names = generatePythonTableHelperArgs(obj, name, doConversion)
    % generatePythonTableHelperArgs Generate arguments in code

    % Copyright 2021-2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonFile
        name (1,1) string = "IN"
        doConversion (1,1) logical = false
    end

    if obj.ScopedTables
        names = name + ", " + obj.generatePythonTableRestArgs(doConversion);
    else
        names = name;
    end
end