function data = runModel_spark_with_input(data,mass)
    % RUNMODEL_SPARK_WITH_INPUT
    mdl = "sldemo_suspn_3dof_with_input";
    
    % By using groupBy on the Python side it is ensured that this function
    % is called with the whole timeseries for a specific road profile as
    % input. So the only data preprocessing we have to do here is ensure
    % that it is sorted by time.
    data = sortrows(data,'Time');

    % Define a SimulationInput object
    in = Simulink.SimulationInput(mdl);
    % Set the Mb parameter
    in = in.setVariable('Mb', mass);
    % And, set the inputs
    in = in.setExternalInput([data.Time data.LeftTire data.RightTire]);

    % Configure for Simulink Compiler deployment
    in = simulink.compiler.configureForDeployment(in);
    
    % Run the simulations
    results = sim(in);

    % Get the vertical displacement as TimeSeries
    results = results.logsout.get('vertical_disp').Values;
    
    % In this example we choose to add a VerticalDisplacement column to the
    % existing data to show the VerticalDisplacement at the same timestamps
    % as at which the input road profile was provided. The actual
    % simulation result may have more data at more (minor) timesteps.
    % So, resample this result at the same timestamps as the input.
    results = results.resample(data.Time);

    % Add the VerticalDisplacement column 
    data.VerticalDisplacement = results.Data;
end