function tOut = prepareOutputTable(tIn, PredictedVals)
    % PREPAREOUTPUTTABLE Helper function to clean up / format a table

    % Copyright 2021-2024 The MathWorks, Inc.

    % Sanity check
    assert( ...
        height(tIn) == size(PredictedVals, 1), ...
        "Input table height & length of Predicted Values must be equal.")

    % Format
    % Decide what to pass back out
    tOut = tIn(:, ["age", "gender", "class"]);

    % Add an ID column
    tOut.PatientID = (1:height(tIn))';

    % Add a new col to the table
    tOut.PredictedVals = PredictedVals;

    % Do a little clean up work (visual only)
    tOut = movevars(tOut, "PatientID", 'Before','age');
end