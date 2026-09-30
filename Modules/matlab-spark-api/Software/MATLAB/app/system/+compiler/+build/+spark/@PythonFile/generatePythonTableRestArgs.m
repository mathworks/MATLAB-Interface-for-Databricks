function names = generatePythonTableRestArgs(obj, doConversion)
    % generatePythonTableRestArgs Generate arguments in code

    % Copyright 2021-2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonFile
        doConversion (1,1) logical = false
    end

    names = "arg" + (1:(obj.nArgIn-1));
    if doConversion
        for k=1:length(names)
            arg = obj.InTypes(k+1);
            names(k) = arg.convertIntermediateToMATLAB(names(k));
        end
    end
    names = join(names, ", ");
end
