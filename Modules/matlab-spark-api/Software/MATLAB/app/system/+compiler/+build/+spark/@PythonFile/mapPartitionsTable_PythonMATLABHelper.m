function fullFileName = mapPartitionsTable_PythonMATLABHelper(file)
    % mapPartitionsTable_PythonMATLABHelper Generate helper file for mapPartitions
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        file (1,1) compiler.build.spark.PythonFile
    end
    
    PSB = file.Parent;
    
    useMetrics = PSB.Metrics;
    
    funcName = file.funcName + "_mapPartitions";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);
    
    SW = matlab.sparkutils.StringWriter(fullFileName);
    
    SW.pf("function OUT = %s(%s)\n", funcName, file.generatePythonTableHelperArgs());
    SW.indent();
    SW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);
    
    SW.pf("%% In this version, the IN argument is a cell array with the different columns\n")
    
    % DEBUG stuff, remove 2 next rows later
    ARGS = file.InTypes(1).TableCols;
    N_COLS = numel(ARGS);
    ARG_NAMES = [ARGS.Name];
    % if PSB.Debug
    %     for k=1:N_COLS
    %         SW.pf('TEMP_%d = IN{%d}\n', k, k);
    %     end
    % end
    
    IN_ENTRIES(N_COLS) = "";
    
    for k=1:N_COLS
        IN_ENTRIES(k) = ARGS(k).getMATLABInputColumn("IN", k);
    end
    % IN_ENTRIES = "IN{" + (1:N_COLS) + "}'";
    
    % if PSB.Debug
    %     SW.pf('whos\n');
    % end
    
    if useMetrics
        ttTotal = file.ticTocHelper(SW, "mapPartitions_total", 'total');
        ttInConv = file.ticTocHelper(SW, "mapPartitions_inConv", 'inConv');
    end
    
    SW.pf("IN = table( ...\n");
    SW.indent();
    for k=1:N_COLS
        conv = ARGS(k).convertIntermediatelColumnToMATLAB(IN_ENTRIES(k));
        % conv = IN_ENTRIES(k);
        SW.pf("%s, ...\n", conv);
    end
    
    % SW.pf("%s, ...\n", join(IN_ENTRIES_CONV + "'", ", "));
    SW.pf("'VariableNames', {'%s'} ...\n", join(ARG_NAMES, "', '"));
    SW.unindent();
    SW.pf(");\n\n")
   
    if useMetrics
        ttInConv.endMeasurement();
    end

    if PSB.Debug
        SW.pf('%% Output some debug info\n')
        SW.pf('infoStr = sprintf("Input table for %%s", mfilename());\n')
        SW.pf('compiler.build.spark.internal.tableDebugInfo(IN, infoStr);\n\n')
    end

    if PSB.Debug
        SW.pf('whos\n');
    end
    
    SW.pf("%% Run the actual algorithm\n");
    SW.pf("IN = %s(%s);\n\n", file.funcName, file.generatePythonTableHelperArgs("IN", true));
    
    if useMetrics
        ttOutConv = file.ticTocHelper(SW, "mapPartitions_outConv", "outConv");
    end
    
    file.genMATLABHelperOutputConversions("IN", SW=SW);
    
    SW.pf("%% The output table may have a different number of rows\n");
    SW.pf("N_OUT = height(IN);");
    SW.pf("%% Create a cell array with the same size as the table\n")
    SW.pf("IN = table2cell(IN);\n\n");
    
    SW.pf("%% Repackage the cell array in the format expected by Spark\n")
    SW.pf("OUT = cell(1, N_OUT);\n")
    SW.pf("for k=1:N_OUT\n");
    SW.indent();
    SW.pf("OUT{k} = IN(k,:);\n");
    SW.unindent();
    SW.pf("end\n\n");

    SW.pf('%% Clear IN variable to reclaim memory\n')
    SW.pf("clear('IN')\n\n")
    
    if useMetrics
        ttOutConv.endMeasurement();
        ttTotal.endMeasurement();
    end
    
    if PSB.Debug
        SW.pf('whos\n');
    end
    
    SW.unindent();
    SW.pf("end\n")
    
end
