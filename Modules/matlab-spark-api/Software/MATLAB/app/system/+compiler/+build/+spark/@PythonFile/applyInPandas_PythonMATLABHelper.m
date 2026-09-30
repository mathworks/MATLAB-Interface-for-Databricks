function fullFileName = applyInPandas_PythonMATLABHelper(file)
    % applyInPandas_PythonMATLABHelper Helper file for applyInPandas
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        file (1,1) compiler.build.spark.PythonFile
    end
    
    PSB = file.Parent;
    
    if PSB.Debug
        SEMICOLON=" %#ok<NOPRT>";
    else
        SEMICOLON=";";
    end
    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>
    
    useMetrics = PSB.Metrics;
    
    funcName = file.funcName + "_applyInPandas";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);
    
    SW = matlab.sparkutils.StringWriter(fullFileName);
    
    OUT_ARGS = file.getOutputElements();
    N_OUT = numel(OUT_ARGS);
    OUTARG_NAMES = [OUT_ARGS.Name];
    OUTARG_COLS = "OUT_T." + OUTARG_NAMES;
    OUTARG_CONV(N_OUT) = "";
    for k=1:N_OUT
        OUTARG_CONV(k) = OUT_ARGS(k).convertMATLABToIntermediate(OUTARG_COLS(k));
        % OUTARG_CONV(k) = OUTARG_COLS(k);
    end
    
    OUTARG_STR = "[" + join(OUTARG_NAMES, ", ") + ", NUM_ROWS]";
    
    
    SW.pf("function %s = %s(%s)\n", OUTARG_STR, funcName, file.generatePythonTableHelperArgs());
    SW.indent();
    SW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);
    
    SW.pf("%% In this version, the IN argument is a cell array with the different columns\n")
    
    % DEBUG stuff, remove 2 next rows later
    
    ARGS = file.InTypes(1).TableCols;
    N_COLS = numel(ARGS);
    ARG_NAMES = [ARGS.Name];
    IN_ENTRIES(N_COLS) = "";
    for k=1:N_COLS
        IN_ENTRIES(k) = ARGS(k).getMATLABInputColumn("IN", k);
    end
    % IN_ENTRIES = "IN{" + (1:N_COLS) + "}'";
    
    if PSB.Debug
        SW.pf("whos\n\n");
    end
    
    if useMetrics
        ttTotal = file.ticTocHelper(SW, "applyInPandas_total", 'total');
        ttInConv = file.ticTocHelper(SW, "applyInPandas_inConv", 'inConv');
    end
    SW.pf("IN = table( ...\n");
    SW.indent();
    for k=1:N_COLS
        % conv = ARGS(k).convertIntermediateToMATLAB(IN_ENTRIES(k));
        conv = ARGS(k).convertIntermediatelColumnToMATLAB(IN_ENTRIES(k));
        % conv = IN_ENTRIES(k);
        SW.pf("%s, ...\n", conv);
    end
    
    % SW.pf("%s, ...\n", join(IN_ENTRIES_CONV + "'", ", "));
    SW.pf("'VariableNames', {'%s'} ...\n", join(ARG_NAMES, "', '"));
    SW.unindent();

    SW.pf(")%s\n\n", SEMICOLON)
    
    % file.genMATLABHelperInputConversions("IN", SW=SW);
    
    if useMetrics
        ttInConv.endMeasurement();
    end
    
    
    
    % DEBUG, show IN_T
    % SW.pf('IN_T\n\n');
    % There are 2 use cases, either table output or scalar output. The
    % output data handling differs in theses cases.
    SW.pf("%% Run the actual algorithm\n");
    SW.pf("OUT_T = %s(%s)%s\n\n", ...
        file.funcName, ...
        file.generatePythonTableHelperArgs("IN", true), ...
        SEMICOLON);
    
    if useMetrics
        ttOutConv = file.ticTocHelper(SW, "applyInPandas_outConv", "outConv");
    end
    
    SW.pf("NUM_ROWS = int64(height(OUT_T))%s\n", SEMICOLON);

    %     file.genMATLABHelperOutputConversions("OUT_T", SW=SW);
    %
    %     SW.pf("%% The output table may have a different number of rows\n");
    %     SW.pf("N_OUT = height(OUT_T);");
    %     SW.pf("%% Create a cell array with the same size as the table\n")
    %     SW.pf("OUT_T = table2cell(OUT_T);\n\n");
    %
    %     SW.pf("%% Repackage the cell array in the format expected by Spark\n")
    %     SW.pf("OUT = cell(1, N_OUT);\n")
    %     SW.pf("for k=1:N_OUT\n");
    %     SW.indent();
    %     SW.pf("OUT{k} = OUT_T(k,:);\n");
    %
    %     SW.unindent();
    %     SW.pf("end\n\n");
    
    SW.pf("%% New outputs style\n");
    for k=1:N_OUT
        SW.pf("%s = %s;\n", OUTARG_NAMES(k), OUTARG_CONV(k));
    end
    
    if PSB.Debug
        SW.pf('whos\n');
    end
    
    if useMetrics
        ttOutConv.endMeasurement();
    end
    
    if useMetrics
        ttTotal.endMeasurement();
    end
    
    SW.unindent();
    SW.pf("end\n")
    
end
