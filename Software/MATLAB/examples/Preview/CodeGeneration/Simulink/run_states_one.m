%% run_states_one.m
% This is a simple example script for running the generated code of a
% Simulink model as part of a Spark job on Databricks.

% Copyright 2026 MathWorks, Inc.

%% Open the model
% 
% This is a very simple model, that simply shows a few different input types
% being used in a Simulink model.
% Open the model first
states_one

%% Build the model
% Now build the model, either by  clicking through the menus, pressing _CTRL+B_,
% or typing `slbuild('states_one')` in the MATLAB command window.

slbuild('states_one')

%% Run the model in Spark
% In order to see how this model can be run in Spark, the easiest way is actually
% to cd into the code generation folder, states_one_sim_pandas in this
% case, and run the function states_one_spark_example.
%
% This function will do most preparations, most importantly
%   - Add the artifact (.zip) and the shared object (.so) to the Spark session
%   - Create sample data with the right types
%   - Import the generated python library into the local python session
%   - Run the library in a mapInPandas function on Databricks
%
%  The function takes several different optional arguments to let the user
%  experiment with different use cases. Some of these options are shown but
%  commented out in this example.

cd states_one_sim_pandas

%% Now actually run the code
% The first run may take some time to initialize, but subsequent runs
% should be faster.
T_OUT = states_one_spark_example( ...
    N=1e5 ... The number of rows in the example data
    ... ,spark=spark ... Use a pre-created Spark session
    ... ,addArtifact=false ... The artifact must be added, but if a Spark session is reused, this can be left out
    ... ,forceNewSession=false ... Normally, the example will create a fresh Spark session
    )



