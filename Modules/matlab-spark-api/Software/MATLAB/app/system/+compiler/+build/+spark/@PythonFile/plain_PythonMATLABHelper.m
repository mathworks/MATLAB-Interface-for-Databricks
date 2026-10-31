function fullFileName = plain_PythonMATLABHelper(file)
    % plain_PythonMATLABHelper Generate helper file for plain

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    PSB = file.Parent;

    funcName = file.funcName + "_plain";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    SW = matlab.sparkutils.StringWriter(fullFileName);

    hasOutputs = file.nArgOut > 0;
    inputNames = [file.InTypes.Name];
    inputArgList = join(inputNames, ", ");
    if hasOutputs
        outputNames = [file.OutTypes.Name];
        outputArgList = join(outputNames, ", ");
    end
    if hasOutputs
        SW.pf("function [%s]= %s(%s)\n", outputArgList, funcName, inputArgList);
    else
        SW.pf("function %s(%s)\n", partitionName, inputArgList);
    end
    SW.indent();
    SW.pf('%% %s Generated function for use with "plain" method\n', funcName);
    SW.pf('%%\n');
    SW.pf('%% This version takes a plain arguments, as provided in the signature.\n');
    SW.pf('%% In some cases, datatype marshalling is performed here, e.g. for java.sql.Timestamp => datetime.\n\n');

    file.genMATLABHelperInputConversions("T_IN", SW=SW, namedArguments=inputNames, isArray=false);

    SW.pf("%% Run the actual algorithm\n");
    if hasOutputs
        SW.pf("[%s] = %s(%s);\n\n", outputArgList, file.funcName, inputArgList)
    else
        SW.pf("%s(%s);\n\n", file.funcName, inputArgList)
    end

    if hasOutputs
        file.genMATLABHelperOutputConversions("OUT_C", SW=SW, namedArguments=outputNames, isArray=false);
    end

    SW.unindent();
    SW.pf("end\n\n");
    SW.pf("%% End of file: %s\n\n", funcName);

end

