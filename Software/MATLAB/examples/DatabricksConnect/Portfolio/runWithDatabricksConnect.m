% RUNWITHDATABRICKSCONNECT - Portfolio Optimization example using Databricks Connect
% 
% Query on a small sample dataset using Spark via Databricks Connect
% The volumesAssetsPath must be updated to use a /Volumes path where the sample
% data can be written.
%
% This dataset is too small for benchmark times to be particularly
% meaningful.
%
% This example shows the use of MATLAB to query data that is
% located on the remote storage via a Spark Session, e.g.:
%   df = spark.read.parquet(...).groupBy(...).agg(...).show()
%
% This uses Databricks Connect to run the parsing and planning of the job on the
% local machine. Then, the logical representation of the job is sent to the
% Spark server running in Databricks for execution in the cluster.

% (c) 2021-2026 MathWorks, Inc

%% Generate assets CSV from Financial Toolbox data and upload to /Volumes
srcAssetsPath = fullfile(tempdir, "assets.csv");
s = load('CAPMuniverse.mat', 'Data', 'Dates', 'Assets');
T = array2table(s.Data, 'VariableNames', s.Assets);
T.Time = datetime(s.Dates, 'ConvertFrom', 'datenum');
T = movevars(T, 'Time', 'Before', 1);
writetable(T, srcAssetsPath);

% !!! Update this path with a path you have permission to write to !!!
volumesAssetsPath = "/Volumes/main/default/myvolume/Scratch/assets.csv";
volumesDeltaPath = "/Volumes/main/default/myvolume/Scratch/assets-delta-example-" + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));

fprintf("Source assets file path: %s\n", srcAssetsPath);
fprintf("Volumes assets file path: %s\n", volumesAssetsPath);
f = databricks.Files;
f.upload(srcAssetsPath, volumesAssetsPath);

%% Create a Spark session
spark = getDatabricksSession();

% Create a dataframe by pointing to the CSV content
tic;
assetsDS = spark.read.format('csv')...
    .option('header','true')...
    .option('inferSchema','true')...
    .load(volumesAssetsPath).cache();
numRows = assetsDS.count();
toc; % Elapsed time c. 19s.


%% Write out the resulting dataframe in delta format
fprintf("Delta file path: %s\n", volumesDeltaPath);
tic;
assetsDS...
    .write.format("delta")...
    .save(volumesDeltaPath);
toc;

%% Inspect the raw parquet files in the delta format
x = f.list(volumesDeltaPath);
x.contents(1)
x.contents(2)

%% Read the Delta tables
% We reuse the dataset name
tic;
assetsDeltaDS = spark...
    .read.format('delta')...
    .load(volumesDeltaPath).cache();
totalRecords = assetsDS.count() %#ok<NOPTS> % 1471
toc; % Elapsed time 2.6s

% Inspect the first few lines
assetsDeltaDS.show(5, false)

% Convert the dataset into a MATLAB table
matlabDeltaTable = table(assetsDeltaDS) %#ok<NOPTS>

% Generate the schema file based on sample input if it does not exist
% this is required for buildPortfolioLib.m
% Having generated sample input data: matlabDeltaTable
if ~isfile(fullfile(pwd, "optimizePortfolio.schema"))
    generateFunctionSchema("optimizePortfolio", {matlabDeltaTable});
end

% Do Portfolio Optimization
result = optimizePortfolio(matlabDeltaTable) %#ok<NOPTS>