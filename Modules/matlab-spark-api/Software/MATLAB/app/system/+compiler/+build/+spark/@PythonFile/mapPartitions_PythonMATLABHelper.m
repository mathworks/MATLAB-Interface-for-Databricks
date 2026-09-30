function fullFileName = mapPartitions_PythonMATLABHelper(F)
    % mapPartitions_PythonMATLABHelper Generate helper file for mapPartitions
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        F (1,1) compiler.build.spark.PythonFile
    end
    
    PSB = F.Parent;
    
    funcName = F.funcName + "_mapPartitions";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);
    
    SW = matlab.sparkutils.StringWriter(fullFileName);
    
    SW.pf("function OUT = %s(IN)\n", funcName)
    SW.indent();
    SW.pf("%% %s Helper function for %s\n\n", funcName, F.funcName);
    
    
    ARGS = F.getInputElements(table=false, individual=true);
    N_ARGS = numel(ARGS);
    
    COL_NAMES = "COL_" + (1:N_ARGS);
    SW.pf("%% Get the columns to use\n")
    for k=1:N_ARGS
        ARG = ARGS(k);
        inCol = "IN{" + k + "}";
            SW.pf("%s = %s;\n", COL_NAMES(k), ARG.convertIntermediateToMATLAB(inCol));
    end

    SW.pf("N = numel(%s);\n\n", COL_NAMES(1));
    
    SW.pf("OUT = cell(1, N);\n")
    outArgs = "out_" + (1:F.nArgOut);
    outArgsStr = join(outArgs, ", ");
    inArgs(N_ARGS) = "";
    for k=1:N_ARGS
        if ARGS(k).isScalarData
            inArgs(k) = COL_NAMES(k) + "(k)";
        else
            inArgs(k) = COL_NAMES(k) + "{k}";
        end
    end
    inArgsStr = inArgs.join(", ");
    SW.pf("for k=1:N\n");
    SW.indent();
    
    if F.nArgOut == 0
        SW.pf("%s(%s);\n", F.funcName, inArgsStr);
    elseif F.nArgOut == 1
        SW.pf("OUT{k} = %s(%s);\n", F.funcName, inArgsStr);
        F.genMATLABHelperOutputConversions("", SW=SW, namedArguments="OUT{k}", isArray=false);
    else
        SW.pf("[%s] = %s(%s);\n", outArgsStr, F.funcName, inArgsStr);
        F.genMATLABHelperOutputConversions("", SW=SW, namedArguments=outArgs, isArray=false);
        SW.pf("OUT{k} = {%s};\n", outArgsStr);
    end
    SW.unindent();
    
    SW.pf("end\n");
    SW.unindent();
    SW.pf("end\n")
    
end

