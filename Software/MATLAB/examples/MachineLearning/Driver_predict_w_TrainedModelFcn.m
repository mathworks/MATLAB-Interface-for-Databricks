% Driver_predict_w_TrainedModelFcn.m
%
% This script shows how to exercise the predict function locally and is
% designed to help you debug and understand how it works (before we get to
% the cluster).

% Copyright 2021-2026 The MathWorks, Inc.

% Load data (to test this out)
% Assumes a local path rather than a /volumes path
FilePath = "./data/diabetes_data.csv";
assert(isfile(FilePath), "File not found: " + FilePath + ". Please download diabetes_data.csv from https://www.kaggle.com/andrewmvd/early-diabetes-classification and place it in the data folder.");
data = utils.readDiabetesFile(FilePath);
SampleInputTable = head(data, 3) %#ok<*NOPTS>

% Predict
PredictedValues = predOutcomes(data);
SampleOutputTable = head(PredictedValues, 3)

% (Optional) Make some statement about how the trained model performed
acc = 100*nnz(PredictedValues.PredictedVals == PredictedValues.class)/height(PredictedValues);
fprintf('\nModel accuracy on this data set = %0.2f%%\n', acc)

% Record sample input and output tables for use in deployment later on
save("+deploy/SampleInputOutputTables.mat", "SampleInputTable", "SampleOutputTable")
