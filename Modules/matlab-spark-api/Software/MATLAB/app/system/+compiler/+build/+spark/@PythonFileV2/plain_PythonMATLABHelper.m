function fullFileName = plain_PythonMATLABHelper(file)
    % plain_PythonMATLABHelper Generate helper file for plain

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    PSB = file.Parent;

    funcName = file.funcName + "_plain";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    MW = matlab.sparkutils.MATLABWriter(fullFileName);
    PSB.setMATLABWriter(MW);
    removeMWAfter = onCleanup(@() PSB.clearMATLABWriter());

    hasOutputs = file.nArgOut > 0;

    inputNames = file.getInputNames(main=true);
    inputArgList = join(inputNames, ", ");
    if hasOutputs
        outputNames = file.getOutputNames;
        outputArgList = join(outputNames, ", ");
    end
    if hasOutputs
        MW.pf("function [%s]= %s(%s)\n", outputArgList, funcName, inputArgList);
    else
        MW.pf("function %s(%s)\n", partitionName, inputArgList);
    end
    MW.indent();
    MW.pf('%% %s Generated function for use with "plain" method\n', funcName);
    MW.pf('%%\n');
    MW.pf('%% This version takes a plain arguments, as provided in the signature.\n');
    MW.pf('%% In some cases, datatype marshalling is performed here, e.g. for java.sql.Timestamp => datetime.\n\n');

    inputElems = file.getInputElements(main=true, useData=true);
    numIn = numel(inputElems);
    inArgs = inputNames;
    for k=1:numIn
        curElem = inputElems(k);
        funcName = curElem.val_IMML_to_ML();
        if ~isempty(funcName)
            inArgs(k) = sprintf("%s(%s)", funcName, inputNames(k));
        end
    end

    inArgsStr = join(inArgs, ", ");

    MW.pf("%% Run the actual algorithm\n");
    if hasOutputs
        % SW.pf("%% [%s] = %s(%s);\n\n", outputArgList, file.funcName, inputArgList)
        MW.pf("[%s] = %s(%s);\n\n", outputArgList, file.funcName, inArgsStr)
    else
        % SW.pf("%% %s(%s);\n\n", file.funcName, inputArgList)
        MW.pf("%s(%s);\n\n", file.funcName, inArgsStr)
    end

    outElems = file.getOutputElements(useData=true);
    for k=1:numel(outElems)
        curElem = outElems(k);
        convFunc = curElem.val_ML_to_IMML();
        if ~isempty(convFunc)
            MW.pf("%s = %s(%s);\n", outputNames(k), convFunc, outputNames(k));
        end
    end


    MW.unindent();
    MW.pf("end\n\n");
    MW.pf("%% End of file: %s\n\n", funcName);

end

