function output = runEv1Em(data)

    %#function ConfiguredEv1EmVirtualVehicle
    if height(data) == 0
        output = table('Size', [0, 13], ...
            'VariableTypes', ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"], ...
            'VariableNames', ["Time", "AccelFdbk", "BattCurr", "BattSoc", "BattVolt", "DecelFdbk", "EMSpd", "EMTrq", "GearFdbk", "ax", "ay", "az", "xdot"]);
        return;
    end

    mdl = 'ConfiguredEv1EmVirtualVehicle';

    % Sort the time
    data = sortrows(data, 't');

    % Reset to zero starting time
    data.t = data.t - data.t(1);

    stopTime = data.t(end);

    in = Simulink.SimulationInput(mdl);

    in = in.setExternalInput([data.t, data.xdot]);

    in = in.setModelParameter('StopTime',sprintf('%.6g', stopTime));

    % Make sure it's running in Rapid Accelerator mode for Compiler
    in = simulink.compiler.configureForDeployment(in);

    results = sim(in);

    Time = results.logsout.get('<BattSoc>').Values.Time;
    AccelFdbk = results.logsout.get('<AccelFdbk>').Values.Data;
    BattCurr = results.logsout.get('<BattCurr>').Values.Data;
    BattSoc = results.logsout.get('<BattSoc>').Values.Data;
    BattVolt = results.logsout.get('<BattVolt>').Values.Data;
    DecelFdbk = results.logsout.get('<DecelFdbk>').Values.Data;
    EMSpd = results.logsout.get('<EMSpd>').Values.Data;
    EMTrq = results.logsout.get('<EMTrq>').Values.Data;
    GearFdbk = results.logsout.get('<GearFdbk>').Values.Data;

    % Only returns 1 value
    % SteerFdbk = results.logsout.get('<SteerFdbk>').Values.Data;

    ax = results.logsout.get('<ax>').Values.Data;
    ay = results.logsout.get('<ay>').Values.Data;
    az = results.logsout.get('<az>').Values.Data;
    xdot = results.logsout.get('<xdot>').Values.Data;
    output = table(Time, AccelFdbk, BattCurr, BattSoc, BattVolt, DecelFdbk, EMSpd, EMTrq, GearFdbk, ax, ay, az, xdot);

    if isdeployed
        Simulink.sdi.clear(Export=false)
    end


end