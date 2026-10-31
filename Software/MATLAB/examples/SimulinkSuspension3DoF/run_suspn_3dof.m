function [meanY, stdY] = run_suspn_3dof(Cf)
    % run_suspn_3dof Running suspn_3dof model with one parameter

    % Copyright 2026 The MathWorks, Inc.

    mdl = 'sldemo_suspn_3dof';

    in = Simulink.SimulationInput(mdl);

    % Configure for deployment
    in = simulink.compiler.configureForDeployment(in);

    % in = in.setBlockParameter(cfBlock, 'Cf', num2str(Cf));
    in = in.setVariable('Cf', Cf, 'Workspace', mdl);

    fprintf("Running simulation ...\n");
    % Run the simulation
    out = sim(in);

    % T = out.ScopeData.time;
    % Y = out.ScopeData.signals.values;
    T = out.logsout.get(1).Values.Time;
    Y = out.logsout.get(1).Values.Data;

    TABLE = table(T, Y);

    if isdeployed
        outName = strrep("/tmp/output-" + Cf, ".", "_") + ".parquet";
    else
        outName = "." + strrep("/output-" + Cf, ".", "_") + ".parquet";
    end
    parquetwrite(outName, TABLE);
    if isdeployed
        movefile(outName, "/mab");
    end

    meanY = mean(Y);
    stdY = std(Y);
end