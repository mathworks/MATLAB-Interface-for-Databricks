function funcName = applyInPandas_PythonWrapper(file)
    % applyInPandas_PythonWrapper Generate applyInPandas function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_applyInPandas", file.funcName);
    fieldName = "applyInPandas";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;
    isDebug = PSB.Debug == true;

    OUT_ARGS = file.getOutputElements();
    N_OUT = numel(OUT_ARGS);

    % Add one to the nargout string, as we're returning the num rows too.
    NARGOUT_STR = ", nargout=" + (N_OUT + 1);


    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    if file.TableInterface
        tblArg = file.InData(1);
        numCols = numel(tblArg.fields);
        colArgs = "cols[" + (0:(numCols-1)) + "]";
        colArgsStr = join(colArgs, ", ");

        if file.ScopedTables

            extraArgs = file.getInputElements(table=false, individual=true, useData=true);

            extraArgNames = file.getInputNames(table=false, individual=true) + "_";
            extraArgsStr = join(extraArgNames, ", ");

            SW.pf("def %s(%s):\n", funcName, extraArgsStr);
            SW.indent();
            SW.pf('""" A function to be used with applyInPandas.\n');
            SW.pf('This function takes additional arguments, which create\n')
            SW.pf('a local scope for this function. """\n')
            innerName = sprintf("%s_applyInPandas_inner", file.funcName);
            SW.pf("def %s(pdf : pd.DataFrame):\n", innerName);
            SW.indent();
            SW.pf("nonlocal %s\n", extraArgsStr);
            for k=1:length(extraArgNames)
                xArg = extraArgs(k);
                xArgName = extraArgNames(k);
                
                conv_Spark_to_IMPY = xArg.val_Spark_to_IMPY();
                if ~isempty(conv_Spark_to_IMPY)
                    % SW.pf("%s = %s(%s)\n", xArgName, conv_Spark_to_IMPY, xArgName);
                    extraArgNames(k) =sprintf("%s(%s)", conv_Spark_to_IMPY, extraArgNames(k));
                end
    
                conv_IMPY_to_IMML = xArg.val_IMPY_to_IMML();
                if ~isempty(conv_IMPY_to_IMML)
                    % SW.pf("%s = %s(%s)\n", xArgName, conv_IMPY_to_IMML, xArgName);
                    extraArgNames(k) =sprintf("%s(%s)", conv_IMPY_to_IMML, extraArgNames(k));
                end
            end
            SW.pf("if pdf.shape[0] == 0:\n")
            SW.indent();
            SW.pf("return pd.DataFrame([], columns=%s)\n", file.outputNames_PythonWrapper());
            SW.unindent();

            SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
            SW.pf("cols = %s(pdf)\n", file.API.pandasToCols);
            convArgsStr = join(extraArgNames, ", ");
            SW.pf("result = instance.RT.%s(%s, %s%s)\n", ...
                file.API.applyInPandas, colArgsStr, convArgsStr, NARGOUT_STR);
            SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
            SW.pf("pdf_out = %s(result)\n", file.API.colsToPandas)
            SW.pf("return pdf_out\n\n");
            SW.unindent();
            SW.pf("return %s\n\n", innerName);
            SW.unindent();

        else
            % Non-scoped table
            SW.pf("def %s(pdf : pd.DataFrame):\n", funcName);
            SW.indent();
            SW.pf('""" A function to be used with applyInPandas."""\n');
            if isDebug
                SW.pf("print(f'XYZDebug pdf.shape: {pdf.shape}')\n")
            end
            SW.pf("if pdf.shape[0] == 0:\n")
            SW.indent();
            SW.pf("return pd.DataFrame([], columns=%s)\n", file.outputNames_PythonWrapper());
            SW.unindent();

            SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
            SW.pf("cols = %s(pdf)\n", file.API.pandasToCols);

            SW.pf("result = instance.RT.%s(%s%s)\n", ...
                file.API.applyInPandas, colArgsStr, NARGOUT_STR);


            SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
            SW.pf("pdf_out = %s(result)\n", file.API.colsToPandas)

            SW.pf("return pdf_out\n\n");
            SW.unindent();
        end

    else
        SW.pf("# Create pandas for scalar function too\n")

        inputElems = file.getInputElements(main=true, useData=true);
        numCols = numel(inputElems);
        colArgs = "cols[" + (0:(numCols-1)) + "]";
        colArgsStr = join(colArgs, ", ");
        SW.pf("def %s(pdf : pd.DataFrame):\n", funcName);
        SW.indent();
        SW.pf('""" A function to be used with applyInPandas."""\n');
        SW.pf("if pdf.shape[0] == 0:\n")
        SW.indent();
        SW.pf("return pd.DataFrame([], columns=%s)\n", file.outputNames_PythonWrapper());
        SW.unindent();

        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
        SW.pf("cols = %s(pdf)\n", file.API.pandasToCols);

        SW.pf("result = instance.RT.%s(%s%s)\n", ...
            file.API.applyInPandas, colArgsStr, NARGOUT_STR);


        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        SW.pf("pdf_out = %s(result)\n", file.API.colsToPandas)

        SW.pf("return pdf_out\n\n");
        SW.unindent();
    end
    SW.pf('%s_pandas = %s\n\n', file.funcName, funcName)

    PyW.addMethod(SW);
end
