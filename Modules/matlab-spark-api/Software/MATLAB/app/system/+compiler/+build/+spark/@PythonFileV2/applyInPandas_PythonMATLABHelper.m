function fullFileName = applyInPandas_PythonMATLABHelper(file)
    % applyInPandas_PythonMATLABHelper Helper file for applyInPandas

    % Copyright 2023-2025 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    PSB = file.Parent;

    usePartialTables = PSB.PartialTables;

    useMetrics = PSB.useMetrics;

    if PSB.Debug
        SEMICOLON=" %#ok<NOPRT>";
    else
        SEMICOLON=";";
    end
    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>


    funcName = file.funcName + "_applyInPandas";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    MW = matlab.sparkutils.MATLABWriter(fullFileName);
    PSB.setMATLABWriter(MW);
    removeMWAfter = onCleanup(@() PSB.clearMATLABWriter());

    % Pandas is in table format
    OUT_ARGS = file.getOutputElements(useData=true);
    N_OUT = numel(OUT_ARGS);

    OUTARG_NAMES = "O" + OUT_ARGS.colName();
    OUTARG_COLS = "OUT_T.('" + file.getOutputNames() + "')";
    OUTARG_CONV = strings(1, N_OUT);
    for k=1:N_OUT
        OUTARG_CONV(k) = OUT_ARGS(k).convertMATLABToIntermediate(OUTARG_COLS(k));
        % OUTARG_CONV(k) = OUTARG_COLS(k);
    end

    OUTARG_STR = "[" + join(OUTARG_NAMES, ", ") + ", NUM_ROWS]";


    MW.pf("function %s = %s(%s)\n", OUTARG_STR, funcName, file.generatePythonTableHelperArgs());
    MW.indent();
    MW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);

    MW.pf("import compiler.build.spark.converters.*\n");
    if PSB.Debug
        MW.pf('whos\n');
    end


    ARGS =  file.getInputElements(main=true, useData=true);

    N_COLS = numel(ARGS);
    N_ARGS = numel(ARGS);
    IN_ENTRIES = file.generatePythonTableHelperArgs(join=false);

    if PSB.Debug
        MW.pf("if isdeployed()\n");
        MW.indent();
        MW.pf("if strlength(getenv('DATABRICKS_RUNTIME_VERSION')) == 0\n");
        MW.indent();
        MW.pf("%% Only create these files on local runs\n")
        MW.pf("timeExt = string(datetime('now', 'Format', 'uuuuMMdd_HHmmss_SSS'));\n")
        MW.pf("fileName = sprintf('ap_%s_inputs_%%s.mat', timeExt);\n", file.funcName);
        MW.pf("baseDir = '%s';\n", PSB.OutputDir);
        MW.pf("save(fullfile(baseDir, fileName));\n");
        MW.unindent();
        MW.pf("end\n");
        
        MW.unindent();
        MW.pf("end\n\n");
    end


    if file.TableInterface

        if useMetrics
            ttTotal = file.ticTocHelper(MW, "applyInPandas_total", 'total');
            ttInConv = file.ticTocHelper(MW, "applyInPandas_inConv", 'inConv');
        end
        if usePartialTables
            MW.pf('usedArgNames = {};\n');
            MW.pf('usedArgConversions = {};\n');
            for k=1:N_ARGS
                ARG = ARGS(k);
                entry = IN_ENTRIES(k);
                MW.pf("if iscell(%s) && isempty(%s)\n", entry, entry);
                MW.indent();
                MW.pf("%% Empty column %s, ignoring.\n", entry);
                MW.unindent();
                MW.pf("else\n");
                MW.indent();

                converterClassCtor = ARG.getMLPandasSeriesConverterCtor();
                doConversionCode = compose("%s.toMATLAB(%s)", converterClassCtor, entry);
                MW.pf("usedArgConversions{end+1} = %s;\n", doConversionCode);
                MW.pf("usedArgNames{end+1} = '%s';\n", ARG.Name);
                MW.unindent();
                MW.pf("end\n\n")
            end
            MW.pf("IN = table(usedArgConversions{:}, 'VariableNames', usedArgNames);\n\n")
        else
            % No partial tables
            MW.pf("tableData = cell([1 %d]);\n", N_ARGS);
            MW.pf("tableVarNames = strings([1 %d]);\n", N_ARGS);

            for k=1:N_ARGS
                ARG = ARGS(k);
                entry = IN_ENTRIES(k);
                converterClassCtor = ARG.getMLPandasSeriesConverterCtor();
                doConversionCode = compose("%s.toMATLAB(%s)", converterClassCtor, entry);
                MW.pf("tableData{%d} = %s;\n", k, doConversionCode);
                MW.pf("tableVarNames(%d) = ""%s\"";\n", k, ARG.Name);
            end
            MW.pf("IN = table(tableData{:}, VariableNames=tableVarNames);\n");
        end
        if useMetrics
            ttInConv.endMeasurement();
        end


        if file.ScopedTables
            extraArgs = file.getInputElements(table=false,individual=true, useData=true);
            extraArgNames = file.generatePythonTableRestArgs(join=false);
            for kex = 1:numel(extraArgs)
                exa = extraArgs(kex);
                convFunc = exa.val_IMML_to_ML();
                if ~isempty(convFunc)
                    ean = extraArgNames(kex);
                    MW.pf("%s = %s(%s);\n", ean, convFunc, ean);
                end
            end
            callArgsExtra = ", " + join(extraArgNames, ", ");
        else
            callArgsExtra = "";
        end
        MW.pf("%% Run the actual algorithm\n");

        if useMetrics
            ttAlgo = file.ticTocHelper(MW, "applyInPandas_runAlgo", 'runAlgo');
        end

        if PSB.TryCatch
            MW.pf("try\n");
            MW.indent();
        end

        MW.pf("OUT_T = %s(IN%s)%s\n", ...
            file.funcName, ...
            callArgsExtra, ...
            SEMICOLON);

        if PSB.TryCatch
            MW.unindent();
            MW.pf("catch ME\n");
            MW.indent();
            MW.pf("%% Create an empty table. Also create some output and print it to stderr\n")            
            MW.pf('locErrMsg = sprintf("%s - Message: %%s\\n", ME.message);\n', mfilename);
            MW.pf('locErrMsg = locErrMsg + sprintf("Exception: \\n%%s\\n", formattedDisplayText(ME));\n')
            MW.pf('fprintf(2, "%%s\\n", locErrMsg);\n')
            varOutNames = sprintf("{'%s'}", join(file.getOutputNames(), "', '"));
            if strlength(PSB.TryCatchErrorColumn) == 0
                errColumns = join(repmat("{}", 1, N_OUT), ", ");
            else
                errColumns = strings(1, N_OUT);
                for k=1:N_OUT
                    OA = OUT_ARGS(k);
                    if OA.Name == PSB.TryCatchErrorColumn
                        errColumns(k) = "locErrMsg";
                    else
                        errColumns(k) = OA.instantiateMATLABExampleValue(0);
                    end
                end
                errColumns = join(errColumns, ", ");
            end
            MW.pf("OUT_T = table( ...\n");
            MW.indent();
            MW.pf("%s, ...\n", errColumns);
            MW.pf("'VariableNames', %s ...\n", varOutNames);
            MW.unindent();
            MW.pf(")%s\n", SEMICOLON);
            MW.unindent();
            MW.pf("end %% try/catch\n\n");
        else
            MW.pf("\n")
        end

        if useMetrics
            ttAlgo.endMeasurement();
        end

        MW.pf("NUM_ROWS = int64(height(OUT_T))%s\n\n", SEMICOLON);

        if useMetrics
            ttOutConv = file.ticTocHelper(MW, "applyInPandas_outConv", 'outConv');
        end

        for k=1:N_OUT
            curElem = OUT_ARGS(k);

            codeIn = OUTARG_COLS(k);
            converterClassCtor = curElem.getMLPandasSeriesConverterCtor();
            MW.pf("converter = %s;\n", converterClassCtor);
            MW.pf("%s = converter.fromMATLAB(%s);\n", OUTARG_NAMES(k), codeIn);
        end

        MW.pf("\n");
        
        if useMetrics
            ttOutConv.endMeasurement();
            ttTotal.endMeasurement();
        end

        if PSB.Debug
            MW.pf('whos\n');
        end

    else
        % Not table interface
        MW.pf("%% Conversions, if necessary\n");
        for k=1:N_COLS
            ARG = ARGS(k);
            entry = IN_ENTRIES(k);
            converterClassCtor = ARG.getMLPandasSeriesConverterCtor();
            MW.pf("converter = %s;\n", converterClassCtor);
            MW.pf("%s = %s.toMATLAB(%s);\n", entry, converterClassCtor, entry);
        end
        MW.pf("NUM_ROWS = numel(%s);\n\n", IN_ENTRIES(1));

        MW.pf("\n");
        
        MW.pf("%% Preallocate outputs\n")
        for k=1:N_OUT
            % TODO: types may not always be cells
            ARG = OUT_ARGS(k);
            MW.pf("%s = %s;\n", OUTARG_NAMES(k), ARG.preAllocateMATLABColumn("NUM_ROWS"));
        end
        MW.pf("\n");

        OUT_ASSIGNS = strings(1, N_OUT);
        for k=1:N_OUT
            ARG = OUT_ARGS(k);
            OUT_ASSIGNS(k) = ARG.getMATLABColumnEntry(OUTARG_NAMES(k), "k");
        end
        OUT_ASSIGN_STR = "[" + join(OUT_ASSIGNS, ", ") + "]";
        IN_ARGS = file.getInputElements(main=true, useData=true);
        IN_ARG_NAMES = string.empty;
        for k=1:numel(IN_ARGS)
            IN_ARG_NAMES(k) = getMATLABColumnEntry(IN_ARGS(k), IN_ENTRIES(k), "k");
        end
        IN_ARGS_STR = join(IN_ARG_NAMES, ", ");
        MW.pf("for k=1:NUM_ROWS\n")
        MW.indent();
        MW.pf("%% Calculating ...\n")
        MW.pf("%s = %s(%s);\n\n", OUT_ASSIGN_STR, file.funcName, IN_ARGS_STR );

        MW.pf("%% Change some outputs\n");

        MW.unindent();
        MW.pf("end\n\n")

        % SW.pf("k=1; Q = %s, W = %s\n", OUT_ASSIGNS(1), OUT_ASSIGNS(2));
        % SW.pf("whos\n")
        for k=1:N_OUT
            arg = OUT_ARGS(k);
            converterClassCtor = arg.getMLPandasSeriesConverterCtor();
            MW.pf("converter = %s;\n", converterClassCtor);
            MW.pf("%s = converter.fromMATLAB(%s);\n", OUTARG_NAMES(k), OUTARG_NAMES(k));
        end

    end

    MW.unindent();
    MW.pf("end\n")
    MW.pf("\n");

end
