function cName = writeMATLABExample(swo)
    % writeMATLABExample Write an example to call from MATLAB code

    % Copyright 2024-2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    funcName = string(swo.CI.Name) + "_matlab_example";
    mName = funcName + ".m";

    sw = matlab.sparkutils.StringWriter(mName);


    sw.pf("function T_OUT = %s(N)\n", funcName);
    sw.indent();
    sw.pf("%% %s\n", funcName);
    sw.pf("%% Example to call shared object (.so) from MATLAB.\n")
    sw.pf("%%\n\n");

    sw.pf("arguments\n");
    sw.indent();
    sw.pf("N (1,1) double = 100\n")
    sw.unindent();
    sw.pf("end\n\n")

    inNames = [swo.Inputs.Name];
    for k=1:swo.NumInputs
        P = swo.Inputs(k);
        sw.pf("%s = %s(1:N)';\n", P.Name, P.MLType);
    end
    sw.pf("\n");
    sw.pf("%% Create MATLAB table for inputs\n")
    sw.pf("T_IN = table(%s);\n\n", inNames.join(", "));

    sw.pf("%% Convert this to a Pandas DataFrame\n");
    sw.pf("pdf_in = py.pandas.DataFrame(T_IN);\n\n");

    sw.pf("%% Call the SO through the Python package\n");
    sw.pf("pdf_out = py.%s.run_sim(pdf_in);\n\n", swo.getFullPyPkgName());

    sw.pf("%% Convert Python DataFrame to MATLAB table\n");
    sw.pf("T_OUT = table(pdf_out);\n\n", swo.getFullPyPkgName());
    
    sw.unindent();
    sw.pf('end\n\n')
    sw.pf("%% End of file: %s \n\n", mName);
end