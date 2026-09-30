function createDataSets
    % createDataSets Create parquet files to use on Databricks
    %
    % This file reads in the data from the shipsldemo_suspn_3dofping demo,
    % converts it into tables, and saves these as parquet files.
    % 
    % This data can then be uploaded to Databricks, either
    % by using the Databricks Workspace, or by using the uploadDatasets
    % function in this directory.
    %
    % The sldemo_suspn_3dof_sigData.mat in the current directory is used as the
    % source for the .parquet data.
    
    % Copyright 2022-2025 The MathWorks, Inc.

    % Clean-up any old data which may exist
    if isfolder("data")
        rmdir("data","s");
    end
    % Ensure the data directory exists
    mkdir data
    % Load example road data
    mlData = load("sldemo_suspn_3dof_sigData");
    % For all the roads in this dataset
    roads = fieldnames(mlData);
    for road = string(roads)'
        % Get the data
        tt = extractTimetable(mlData.(road));
        tt = timetable2table(tt);
        tt.Time = seconds(tt.Time);
        tt.Properties.VariableNames = ["Time","LeftTire","RightTire"];
        tt.ID = repmat(road,height(tt),1);
        % Save as parquet file
        parquetwrite(fullfile("data",road),tt);
    end
end