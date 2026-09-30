%% Driver_RunModelOnDatabricks.m

%% Overview

% 1. Create compiled artifacts

% 2. Upload compiled artifacts to /Volumes

% 3. Upload notebooks to the Databricks Workspace

% 4. Run notebooks as notebook tasks from a databricks job

% 5. Check the results

% Copyright 2022-2026 The MathWorks, Inc.


%% Begin Code


%% For organizational purposes, keep all the demo info in one place
DI = DemoInfo;


%% 1. Create compiled artifacts
% If we want to call or use MATLAB (or Simulink) on Databricks, we need to
% compile our code so it can be invoked from a Databricks Python
% notebook.  In order to do this we need to develop a wrapper function that
% calls our MATLAB (or Simulink) code. The wrapper function is what gets
% compiled.

% The MATLAB function we will compile in this example is called
% "predOutcomes.m".  Let's have a quick look before we begin.

edit predOutcomes.m

% Compile to be called from python
% In this step we will create a .whl file from the MATLAB function
% "predOutcomes.m" that we will invoke from a Python notebook on Databricks.

PSB = deploy.createWhl(DI.FuncFileName, DI.BuildDir, DI.PythonPkgName);


%% 2. Upload compiled artifacts to /Volumes
% Now that we have compiled our MATLAB (or Simulink) function(s), we need to
% move them to a place that our cluster can "see" them so they can be used.

% .whl file
f = databricks.Files;
if ~f.directoryExists(DI.VolumesUploadFolder)
    if ~f.create(DI.VolumesUploadFolder)
        error("Directory creation failed for: %s", DI.VolumesUploadFolder)
    end
end

[wheelFile, wheelName] = PSB.getWheelFile();
tf = f.upload(wheelFile, string(DI.VolumesUploadFolder) + "/" + string(wheelName));
assert(tf, "Upload failed for wheel file: " + wheelFile);

% Assuming a file must be uploaded initially to /Volumes for use by the notebook
dataFile = fullfile(".", "data", "diabetes_data.csv");
assert(isfile(dataFile), "File not found: " + dataFile + ". Please download diabetes_data.csv from https://www.kaggle.com/andrewmvd/early-diabetes-classification and place it in the data folder.");
tf = f.upload(dataFile, string(DI.VolumesUploadFolder) + "/" + "diabetes_data.csv");
assert(tf, "Upload failed for data file: " + dataFile);

% Confirm we successfully uploaded the compiled artifacts
l = f.list(DI.VolumesUploadFolder);
l.contents(:).path

%% Workflow Status
% What have we done so far?

% So far in this example we have created a compiled artifact, a .whl file,
% from our MATLAB function called "predOutcomes.m" and we uploaded it /Volumes
% so it can be "seen" by clusters for future work.


%% 3 - Notebooks...
% The rest of this demo assumes you have a notebook you want to run on
% Databricks that invokes a MATLAB function(s). Creation of these
% notebooks is out of scope for this example, we are starting from a point
% where a notebook already exists and you just want to use it.

% To get a sense of what our example notebooks look like we will briefly
% take a look at them now.
% Customize the /Volumes paths
edit ./notebook/MachineLearningExample.py


%% 3. Upload notebooks to Databricks workspace
% We need to upload these notebooks to Databricks so they can be used.
[PythonNotebookURLString, PythonNotebookURLHyperlink] = deploy.pushNotebookToDBWorkspace(DI);
fprintf("\nThe notebook can be viewed here: %s\n", PythonNotebookURLHyperlink);


%% 4. Run notebooks as notebook tasks from a databricks job
% These notebooks are run as jobs which means a new (job) cluster is
% created for each notebook.

% A cluster takes approximately 6 minutes to start.
% For repeated a notebook can/should be run on already created cluster.

% Python
[PyJob, PyJobRun] = runMachineLearningNotebookJob();
databricks.internal.run.waitForRunStatus(PyJobRun)

%% 5. Check the results
% You can get at your results in several ways.  Here we will consider 2
% options

% Option 1 - (does not require an active cluster)
% Pull the result files from /Volumes (or wherever you saved them - s3, blob,
% etc) down to this MATLAB session and process them.  This is a good option
% if the file(s) are not very big and not very many.

% Option 2 - (requires an active cluster)
% Create a spark context to read the data from Databricks into a Dataframe
% and pull that Dataframe into MATLAB.  This could be a good option if your
% results are BIG and you need to do server side filtering work before you
% bring results back into MATLAB.


%% Option 1 - download the resultant .parquet files from the notebook jobs

LocalResultsFolder = "./NotebookResults";

if ~isfolder(LocalResultsFolder)
    mkdir(LocalResultsFolder)
end

% Python Notebook results
[PythonResultsDirRemote, PythonResultsFileLocal] = utils.getNotebookResults(PyJobRun, LocalResultsFolder);


% Read the resultant .parquet files and compare
PythonResults = parquetread(PythonResultsFileLocal);


%% Compare the resultant tables
head(PythonResults, 5)


%% Option 2 - use the Spark API to pull Dataframes from Databricks into MATLAB
% NOTE: this option requires a running cluster.

% The results are the dataframe of predicted values we created on
% Databricks and wrote to new .parquet files.  Here we are pulling the
% results of our notebook work back into MATLAB to confirm what we did.

spark = getDatabricksSession()


%% Python results
PythonResultsDF = spark.read.format('parquet')...
    .option('header', 'true')...
    .option('inferSchema', 'true')...
    .load(PythonResultsDirRemote);

PythonResultsDF.show(5)

PythonResultsFromSpark = PythonResultsDF.table();


%% Original (local) MATLAB results
FilePath = "./data/diabetes_data.csv";
data = utils.readDiabetesFile(FilePath);
MATLABResults = predOutcomes(data);


%% Compare the resultant tables
head(PythonResults, 5)
head(MATLABResults, 5)

% Compare all results from all 3 approaches
Comp_Python_v_MATLAB = isequal(double(PythonResults.PredictedVals), MATLABResults.PredictedVals);


% Report comparison work.
if ~Comp_Python_v_MATLAB
    disp("Results do not match!!!  Error!")
else
    disp("Results match!")
end

% Doc link for the MATLAB function "isequal"
% https://www.mathworks.com/help/matlab/ref/isequal.html
% tf = isequal(A,B) returns logical 1 (true) if A and B are equivalent; otherwise, it returns logical 0 (false).


%% Conclusion
% Different ways of running compiled MATLAB code --> Same answers.
