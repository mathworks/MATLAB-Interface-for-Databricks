function funcName = applyInPandas_PythonWrapper(file)
    % applyInPandas_PythonWrapper Generate applyInPandas function

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
    end

    funcName = sprintf("%s_applyInPandas", file.funcName);
    fieldName = "applyInPandas";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    OUT_ARGS = file.getOutputElements();
    N_OUT = numel(OUT_ARGS);

    % Add one to the nargout string, as we're returning the num rows too.
    NARGOUT_STR = ", nargout=" + (N_OUT + 1);


    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    if file.ScopedTables

        extraArgs = file.getInputElements(table=false, individual=true);
        extraArgNames = [extraArgs.Name]+ "_";
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
        SW.pf("if pdf.shape[0] == 0:\n")
        SW.indent();
        SW.pf("return pd.DataFrame([])\n")
        SW.unindent();

        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
        SW.pf("cols = %s(pdf)\n", file.API.pandasToCols);
        for k=1:length(extraArgNames)
            convArgs(k) = convertPythonValueForMW(extraArgs(k), extraArgNames(k));
        end
        convArgsStr = join(convArgs, ", ");
        SW.pf("result = instance.RT.%s(cols, %s%s)\n", file.API.applyInPandas, convArgsStr, NARGOUT_STR);
        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        SW.pf("pdf_out = %s(result)\n", file.API.colsToPandas)
        SW.pf("return pdf_out\n\n");
        SW.unindent();
        SW.pf("return %s\n\n", innerName);
        SW.unindent();

    else

        SW.pf("def %s(pdf : pd.DataFrame):\n", funcName);
        SW.indent();
        SW.pf('""" A function to be used with applyInPandas."""\n');
        SW.pf("if pdf.shape[0] == 0:\n")
        SW.indent();
        SW.pf("return pd.DataFrame([])\n")
        SW.unindent();

        SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
        SW.pf("cols = %s(pdf)\n", file.API.pandasToCols);

        SW.pf("result = instance.RT.%s(cols%s)\n", file.API.applyInPandas, NARGOUT_STR);


        SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);
        SW.pf("pdf_out = %s(result)\n", file.API.colsToPandas)

        SW.pf("return pdf_out\n\n");
        SW.unindent();
    end
    SW.pf('%s_pandas = %s\n\n', file.funcName, funcName)

    PyW.addMethod(SW);
end
