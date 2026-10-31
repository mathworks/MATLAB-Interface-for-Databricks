function fullFileName = pandasSeries_PythonMATLABHelper(file)
    % pandasSeries_PythonMATLABHelper Generate helper file for Pandas series

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    PSB = file.Parent;
    
    funcName = file.funcName + "_series";
    fileName = funcName + ".m";
    fullFileName = fullfile(PSB.GenMatlabDir, fileName);

    MW = matlab.sparkutils.MATLABWriter(fullFileName);
    PSB.setMATLABWriter(MW);
    removeMWAfter = onCleanup(@() PSB.clearMATLABWriter());

    % Change context
    changeBack = PSB.setScopedCallContext('TablePandas'); %#ok<NASGU>


    ARGS = file.getInputElements(main=true, useData=true);
    OUT_ARGS = file.getOutputElements(useData=true);
    
    N_OUT = numel(OUT_ARGS);

    inArgNames = "arg_" + file.getInputNames();
    outArgNames = "ret_" + file.getOutputNames();
    MW.pf("function [%s] = %s(%s)\n", ...
        outArgNames.join(", "), ...
        funcName, ...
        inArgNames.join(", "));
    MW.indent();
    MW.pf("%% %s Helper function for %s\n\n", funcName, file.funcName);

    if PSB.Debug
        saveName = fullfile(PSB.OutputDir, sprintf("ps_%s_inputs.mat", file.funcName));
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

    MW.pf("import compiler.build.spark.converters.*\n");

    % Convert inputs
    for k=1:numel(ARGS)

        ARG = ARGS(k);
        entry = inArgNames(k);
        converterClassCtor = ARG.getMLPandasSeriesConverterCtor();
        doConversionCode = compose("%s.toMATLAB(%s)", converterClassCtor, entry);
        MW.pf("%s = %s;\n", entry, doConversionCode);
    end

    MW.pf("N = numel(%s);\n\n", inArgNames(1));

    MW.pf('%% Initialize output arguments\n')
    for k=1:N_OUT
        % MW.pf("%s = transpose(%s);\n", outArgNames(k), OUT_ARGS(k).preAllocateMATLABColumn("N"));
        MW.pf("%s = %s;\n", outArgNames(k), OUT_ARGS(k).preAllocateMATLABColumn("N"));
    end
    
    inArgString = join(inArgNames + ARGS.getIndexString("k"), ", ");
    outArgString = join(outArgNames + OUT_ARGS.getIndexString("k"), ", ");
    if file.nArgOut > 1
        outArgString = "[" + outArgString + "]";
    end
    MW.pf("\n");    
    MW.pf("%% Loop through inputs\n");
    
    MW.pf("for k=1:N\n");
    MW.indent();

    MW.pf("%s = %s(%s);\n", outArgString, file.funcName, inArgString);
    
    MW.unindent();
    MW.pf("end\n\n");


    MW.pf("%% Convert outputs here\n");
    for k=1:N_OUT
        arg = OUT_ARGS(k);
        converterClassCtor = arg.getMLPandasSeriesConverterCtor();
        MW.pf("converter = %s;\n", converterClassCtor);
        MW.pf("%s = converter.fromMATLAB(%s);\n", outArgNames(k), outArgNames(k));
    end
    MW.pf("\n");

    MW.unindent();
    MW.pf("end\n\n")

end

