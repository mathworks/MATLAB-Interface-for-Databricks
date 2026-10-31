function output = runEvRefApp(data)
    % runEvRefApp

    % Debug output
    
    if height(data) == 0
        output = table('Size', [0, 7], ...
            'VariableTypes', ["double", "double", "double", "double", "double", "double", "double"], ...
            'VariableNames', ["Time", "BattSoc", "MotorSpeed", "USFuelEco", "MotorTorguq", "BattCurrent", "xdot"]);
        return;
    end

    mdl = 'EvReferenceApplication';

    if isdeployed
        tmpDirName = tempname('/local_disk0/tmp');
        mkdir(tmpDirName);
        removeAfter = onCleanup(@() rmdir(tmpDirName, 's'));
        setenv('TMPDIR', tmpDirName)
        % Could also be 
        % setenv('TMPDIR', getenv('RAY_TMPDIR'));

        % This will not work
        % Simulink.sdi.setAutoArchiveMode(true)
        % Simulink.sdi.setArchiveRunLimit(0)
    end
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

    Time = results.logsout.get('Battery SOC (%)').Values.Time;
    BattSoc = results.logsout.get('Battery SOC (%)').Values.Data;
    MotorSpeed = results.logsout.get('Motor Speed (RPM)').Values.Data;
    USFuelEco = results.logsout.get('US Fuel Economy (MPGe)').Values.Data;
    MotorTorguq = results.logsout.get('Motor Torque (Nm)').Values.Data;
    BattCurrent = results.logsout.get('Battery Current (A)').Values.Data;
    xdot = resample(results.logsout.get('VelocityRef').Values, Time);
    xdot = xdot.Data;

    output = table(Time, BattSoc, MotorSpeed, USFuelEco, MotorTorguq, BattCurrent, xdot);

    fprintf('Starting cleanup ...\n');
    % srcDMR = Simulink.sdi.getSource()
    Simulink.sdi.clear()

    % This seems to have no effect.
    % runIds = Simulink.sdi.getAllRunIDs();
    % if ~isempty(runIds)
    %     Simulink.sdi.deleteRun(runIds(end));
    % end

    % This will break simulation, and make logsout disappear
    % delete(srcDMR);
    % dmrDir = fileparts(srcDMR);
    % dmrFiles = fullfile(dmrDir, '*.dmr');
    % delete(dmrFiles);

end