function fullFileName = mapPartitions_PythonMATLABHelper(file)
    % mapPartitions_PythonMATLABHelper Generate helper file for mapPartitions

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    PSB = file.Parent;

    usePartialTables = PSB.PartialTables;

    funcName = file.funcName + "_mapPartitions";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    MW = matlab.sparkutils.MATLABWriter(fullFileName);
    PSB.setMATLABWriter(MW);
    removeMWAfter = onCleanup(@() PSB.clearMATLABWriter());

    IN_ARGS = file.getInputElements(main=true, useData=true);
    N_ARGS = numel(IN_ARGS);

    OUT_ARGS = file.getOutputElements(useData=true);
    N_OUT = numel(OUT_ARGS);
    outputNames = file.getOutputNames();
    % outArgNames = "out_" + outputNames;
    outArgNames = "O" + OUT_ARGS.colName();

    MW.pf("function [%s, NUM_ROWS] = %s(%s)\n", ...
        join(outArgNames, ", "), ...
        funcName, file.generatePythonTableHelperArgs());
    MW.indent();
    MW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);

    if PSB.Debug
        saveName = fullfile(PSB.OutputDir, sprintf("mp_%s_inputs.mat", file.funcName));
        MW.pf("if isdeployed()\n");
        MW.indent();
        MW.pf("if strlength(getenv('DATABRICKS_RUNTIME_VERSION')) == 0\n");
        MW.indent();
        MW.pf("%% Only create these files on local runs\n")
        MW.pf("save('%s')\n", saveName)
        MW.unindent();
        MW.pf("end\n");
        MW.unindent();
        MW.pf("end\n\n");
    end

    if file.TableInterface
        ARG_NAMES = file.getInputNames(main=true);
        IN_ENTRIES = file.generatePythonTableHelperArgs(join=false);

        if usePartialTables
            MW.pf('usedArgNames = {};\n');
            MW.pf('usedArgConversions = {};\n');
            for k=1:N_ARGS
                ARG = IN_ARGS(k);
                entry = IN_ENTRIES(k);
                MW.pf("if iscell(%s) && isempty(%s)\n", entry, entry);
                MW.indent();
                MW.pf("%% Empty column %s, ignoring.\n", entry);
                MW.unindent();
                MW.pf("else\n");
                MW.indent();
                newConvCode = ARG.table_IMML_to_ML(entry);
                MW.pf("usedArgNames{end+1} = '%s';\n", ARG.Name);
                MW.pf("usedArgConversions{end+1} = %s;\n", newConvCode);
                MW.unindent();
                MW.pf("end\n\n")
            end
            MW.pf("IN = table(usedArgConversions{:}, 'VariableNames', usedArgNames);\n\n")            
        else
            MW.pf("IN = table( ...\n");
            MW.indent();
            for k=1:N_ARGS
                ARG = IN_ARGS(k);
                entry = IN_ENTRIES(k);
                newConvCode = ARG.table_IMML_to_ML(entry) + sprintf(", ...\n");
                % qq = ARG.convertStructColumn(entry)
                MW.insertLines(newConvCode);
            end

            % SW.pf("%s, ...\n", join(IN_ENTRIES_CONV + "'", ", "));
            MW.pf("'VariableNames', {'%s'} ...\n", join(ARG_NAMES, "', '"));
            MW.unindent();
            MW.pf(");\n\n")
        end

        if PSB.Debug
            MW.pf("IN %%#ok<NOPRT>\n\n\n");
        end

        MW.pf("%% Run the actual algorithm\n");
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
            callArgs = "IN, " + join(extraArgNames, ", ");
        else
            callArgs = "IN";
        end
        if PSB.TryCatch
            MW.pf("try\n");
            MW.indent();
        end
        MW.pf("IN = %s(%s);\n", file.funcName, callArgs);
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
            MW.pf("IN = table( ...\n");
            MW.indent();
            MW.pf("%s, ...\n", errColumns);
            MW.pf("'VariableNames', %s ...\n", varOutNames);
            MW.unindent();
            MW.pf(");\n");
            MW.unindent();
            MW.pf("end %% try/catch\n\n");
        else
            MW.pf("\n")
        end

        if PSB.Debug
            MW.pf("IN %%#ok<NOPRT>\n\n\n");
        end

        MW.pf("%% The output table may have a different number of rows\n");
        MW.pf("NUM_ROWS = int64(height(IN));\n");

        for k=1:N_OUT
            curElem = OUT_ARGS(k);

            codeIn = "IN.('" + outputNames(k) + "')";
            codeOut = curElem.col_ML_to_IMML(codeIn);
            MW.pf("%s = %s;\n", outArgNames(k), codeOut);

            MW.pf("\n")

        end

        MW.pf('%% Clear IN variable to reclaim memory\n')
        MW.pf("clear('IN')\n\n")

    else
        % Scalar (non-table) interface
        COL_NAMES = file.generatePythonTableHelperArgs(join=false);
        convNeeded = false;
        for k=1:N_ARGS
            ARG = IN_ARGS(k);
            entry = COL_NAMES(k);
            newConvCode = ARG.col_IMML_to_ML(entry);
            MW.pf("%s = %s;\n", entry, newConvCode);
            convEntry = ARG.convertIntermediateToMATLAB(entry);
            if entry ~= convEntry
                if ~convNeeded
                    convNeeded = true;
                    MW.pf("%% Convert certain input columns\n");
                end
                MW.pf("%% Old style\n")
                MW.pf("%% %s = %s;\n", entry, convEntry);
            end
        end
        if convNeeded
            MW.pf("\n");
        end

        if PSB.Debug
            MW.pf("whos\n");
            for k=1:numel(COL_NAMES)
                MW.pf("%s\n", COL_NAMES(k));
            end
        end
        MW.pf("NUM_ROWS = int64(numel(%s));\n\n", COL_NAMES(1));

        outArgNamesEntries = outArgNames + getIndexString(OUT_ARGS, "k");
        % outArgs = "out_" + (1:file.nArgOut);
        % outArgsStr = join(outArgs, ", ");
        inArgs = COL_NAMES + getIndexString(IN_ARGS, "k");
        inArgsStr = inArgs.join(", ");

        MW.pf("%% Preallocate\n");
        for k=1:N_OUT
            MW.pf("%s = %s;\n", outArgNames(k), genMATLABArray(OUT_ARGS(k), "NUM_ROWS"));
        end

        MW.pf("for k=1:NUM_ROWS\n");
        MW.indent();

        if file.nArgOut == 0
            MW.pf("%s(%s);\n", file.funcName, inArgsStr);
        elseif file.nArgOut == 1
            MW.pf("%s = %s(%s);\n", outArgNamesEntries, file.funcName, inArgsStr);
        else
            MW.pf("[%s] = %s(%s);\n", join(outArgNamesEntries, ", "), file.funcName, inArgsStr);
        end
        MW.unindent();

        MW.pf("end\n\n");

        for k=1:N_OUT
            curElem = OUT_ARGS(k);
            convCode = curElem.col_ML_to_IMML(outArgNames(k));
            if ~isempty(convCode)
                MW.pf("%s = %s;\n", outArgNames(k), convCode);
            end
        end

    end
    MW.unindent();
    MW.pf("end\n")
    MW.pf("\n");

end

function showOne(SW, name)
    SW.pf("fprintf('%s:\\n')\n", name);
    SW.pf("%s\n", name);
    SW.pf("if iscell(%s)\n", name)
    SW.indent()
    SW.pf("fprintf('%s{1}:\\n')\n", name);
    SW.pf("%s{1}\n", name);
    SW.unindent()
    SW.pf('end\n');
end