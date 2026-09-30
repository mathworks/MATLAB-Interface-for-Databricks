function mName = writeUnitTest(swo)
    % writeUnitTest Write a unit test file
    %
    % This file will run the simulation and the MATLAB/Pandas test with the
    % same input data. The results should be the same.

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    funcName = string(swo.CI.Name) + "_unit_test";
    mName = funcName + ".m";

    mw = matlab.sparkutils.MATLABWriter(mName);


    mw.pf("function RESULT = %s(N)\n", funcName);
    mw.indent();
    mw.pf("%% %s\n", funcName);
    mw.pf("%% Example to call DLL from MATLAB.\n")
    mw.pf("%%\n\n");

    mw.pf("arguments\n");
    mw.indent();
    mw.pf("N (1,1) double = 100\n")
    mw.unindent();
    mw.pf("end\n\n")

    inputsFunc = generateMATLABInputs(swo, mw);
    mw.pf("T_IN = %s(N);\n", inputsFunc);

    simulationFunc = generateSimulationFunction(swo, mw);

    mw.pf("%% Convert this to a Pandas DataFrame\n");
    mw.pf("pdf_in = py.pandas.DataFrame(T_IN);\n\n");

    mw.pf("%% Call the SO through the Python package\n");
    mw.pf("pdf_out = py.%s.run_sim(pdf_in);\n\n", swo.getFullPyPkgName());

    mw.pf("%% Convert Python DataFrame to MATLAB table\n");
    mw.pf("T_OUT = table(pdf_out);\n\n", swo.getFullPyPkgName());
    
    mw.pf("SIM_OUT = %s(T_IN);\n\n", simulationFunc);

    mw.pf("RESULT = isequal(T_OUT, SIM_OUT);\n")
    mw.pf("%% assert(RESULT, 'The Pandas simulation should equal the Simulink simulation for the model ''%s''');\n\n", swo.ModelName);

    mw.unindent();
    mw.pf('end\n\n')
    mw.pf("%% End of file: %s \n\n", mName);
end

function funcName = generateMATLABInputs(swo, mw)
    funcName = sprintf("%s_inputs_table", swo.CI.Name);

    sw = matlab.sparkutils.StringWriter();
    sw.pf("function T_IN = %s(N)\n", funcName);
    sw.indent();
    sw.pf("%% %s Create example inputs for %s\n\n", funcName, swo.CI.Name)
    inNames = [swo.Inputs.Name];
    for k=1:swo.NumInputs
        P = swo.Inputs(k);
        sw.pf("%s = %s(1:N)';\n", P.Name, P.MLType);
    end
    sw.pf("\n");
    sw.pf("%% Create MATLAB table for inputs\n")
    sw.pf("T_IN = table(%s);\n\n", inNames.join(", "));

    sw.unindent();
    sw.pf("end\n\n")

    mw.addSubFun(sw);
end


function funcName = generateSimulationFunction(swo, mw)
    funcName = sprintf("%s_simulate", swo.CI.Name);

    sw = matlab.sparkutils.StringWriter();
    sw.pf("function output = %s(T)\n", funcName);
    sw.indent();
    sw.pf("%% %s Run simulation for %s\n\n", funcName, swo.ModelName)

    sw.pf("oldPWD = cd('..');\n");
    sw.pf("goBack = onCleanup(@() cd(oldPWD));\n")
    sw.pf("numRows = height(T);\n")
    sw.pf("Time = (1:numRows)'-1;\n");
    inNames = [swo.Inputs.Name];
    % sw.pf("INPUTS = [Time, %s];\n", join("T." + inNames, ", "));
    sw.pf("INPUTS = Simulink.SimulationData.Dataset();\n")
    for k=1:swo.NumInputs
        sw.pf("INPUTS = INPUTS.addElement(timeseries(T.%s, Time), '%s');\n", swo.Inputs(k).Name, swo.Inputs(k).Name);
    end
    sw.pf("stopTime = numRows - 1;\n")
    sw.pf("in = Simulink.SimulationInput('%s');\n", swo.ModelName);
    sw.pf("in = in.setExternalInput(INPUTS);\n")
    sw.pf("in = in.setModelParameter('StopTime', num2str(stopTime));\n")
    sw.pf("in = in.setModelParameter('FixedStep',num2str(1));\n\n")
    
    sw.pf("results = sim(in);\n")

    sw.pf("output = table( ...\n ");
    sw.indent();
    for k=1:swo.NumOutputs
        sw.pf("results.yout.get(%d).Values.Data, ...\n", k);
    end
    sw.pf("'VariableNames', {'%s'} ...\n", join([swo.Outputs.Name], "', '"));
    sw.unindent();
    sw.pf(");\n");

    sw.unindent();
    sw.pf("end\n\n")

    mw.addSubFun(sw);

end