% Step through the NYC Taxi data example

% If the preferred cluster is not set as the default consider setting it:
% updateClusterId("<clusterId>")
% Also check that the cluster is running and has a version matched MATLAB
% runtime installed.


%% Get sample data for NYC taxis
% Create a Spark session, in this case using the configured default cluster
spark = getDatabricksSession()

% Default dataset path in Databricks
nycSrc = '/databricks-datasets/nyctaxi/tables/nyctaxi_yellow';

DS = spark.read.format("delta").load(nycSrc) %#ok<*NOPTS>
fprintf("The NYC dataset has %g rows\n", DS.count);

% Choose specific columns from the dataset
nycDS = DS ...
    .select("passenger_count", "trip_distance", "fare_amount", "tip_amount") ...
    .filter("fare_amount > 80.0 AND fare_amount < 100.0")

% Show the data using Sparks show command
nycDS.show(10, false);

% Convert the data to MATLAB table
nycT = table(nycDS.limit(100));

% Call nycAlgo (without compilation) on a subset of the data for validation
OUT = nycAlgo(nycT)


%% Create a function schema for the .whl package
generateFunctionSchema("nycAlgo", {nycT});


%% Build the .whl library
% Define options for the .whl file and compile it
opts = compiler.build.PythonPackageOptions(...
    "nycAlgo.m", ...
    "OutputDir", "_build", ...
    "PackageName", "demo.nyc");

PSB = compiler.build.spark.pythonPackage(opts)


%% Upload .whl to Volumes & Notebook to Workspace
f = databricks.Files();
[wheelFile, wheelName] = PSB.getWheelFile();
f.upload(wheelFile, "/Volumes/main/default/myvolume/Scratch/" + string(wheelName));

% Upload a provided notebook
ws = databricks.Workspace();
notebookPath = "/Workspace/Users/" + string(ws.username) + "/" + "nyc_example_notebook.py";
ws.import('path', notebookPath, 'format', 'SOURCE', 'language', 'PYTHON', ...
        'file', fullfile(workDir, "nyc_example_notebook.py"), 'overwrite', true);


%% Execute the notebook on Databricks

% Switch to the Databricks UI update the notebook with the whlPath value e.g.:
% "/Volumes/main/default/myvolume/Scratch/demo_nyc-25.2.0-py3-none-any.whl"
% Select a MATLAB runtime enabled cluster and run the notebook.

% Notebook execution can also be triggered from MATLAB.
