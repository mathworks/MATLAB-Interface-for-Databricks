function fullFileName = pandasSeries_PythonMATLABHelper(file)
    % pandasSeries_PythonMATLABHelper Generate helper file for Pandas series

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    PSB = file.Parent;
    
    funcName = file.funcName + "_series";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    SW = matlab.sparkutils.StringWriter(fullFileName);

    inArgs = file.generateArgNames('in', 'IN');
    outArgs = file.generateArgNames('out', 'OUT');
    SW.pf("function [%s] = %s(%s)\n", ...
        outArgs.join(", "), ...
        funcName, ...
        inArgs.join(", "));
    SW.indent();
    SW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);

    SW.pf("N = numel(%s);\n\n", inArgs(1));

    SW.pf('%% Initialize output arguments\n')
    for k=1:length(outArgs)
      SW.pf("%s = cell(1, N);\n", outArgs(k));
    end
    
    inArgsLoop = join(inArgs + "{k}", ", ");
    outArgsLoop = join(outArgs + "{k}", ", ");
    if file.nArgOut > 1
        outArgsLoop = "[" + outArgsLoop + "]";
    end
    SW.pf("\n");    
    SW.pf("%% Loop through inputs\n");
    
    SW.pf("for k=1:N\n");
    SW.indent();

    SW.pf("%s = %s(%s);\n", outArgsLoop, file.funcName, inArgsLoop);
    
    SW.unindent();
    SW.pf("end\n\n");

    SW.unindent();
    SW.pf("end\n")

    

end
