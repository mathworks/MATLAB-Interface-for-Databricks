function names = generatePythonTableHelperArgs(file, options)
    % generatePythonTableHelperArgs Generate arguments in code

    % Copyright 2021-2025 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
        options.join (1,1) logical = true
    end

    mainInputs = file.getInputElements(main=true, useData=true);
    names = mainInputs.colName();

    if file.ScopedTables
        names = [names, file.generatePythonTableRestArgs(join=false)];
    end
    if options.join
        names = join(names, ", ");
    end
end