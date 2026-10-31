function names = generatePythonTableRestArgs(obj, options)
    % generatePythonTableRestArgs Generate arguments in code

    % Copyright 2021-2025 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonFileV2
        options.join (1,1) logical = true
    end

    names = "arg_" + obj.getInputNames(table=false);

    if options.join
        names = join(names, ", ");
    end
end
