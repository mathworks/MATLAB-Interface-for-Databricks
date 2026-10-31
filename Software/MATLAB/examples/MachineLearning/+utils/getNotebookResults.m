function [ResultsDir, ResultsFileLocal] = getNotebookResults(JobRun, LocalFolder)
    % GETNOTEBOOKRESULTS Download and parse results from a Databricks notebook job run

    % Copyright 2021-2026 The MathWorks, Inc.

    ResultsDir = JobRun.getOutput.notebook_output.result;
    f = databricks.Files();
    files = f.list(ResultsDir);
    files = [files.contents.path];
    % Move to download folder
    oldPwd = cd(LocalFolder);
    goBack = onCleanup(@() cd(oldPwd));
    for oneFile = files
        f.download(oneFile);
    end
    clear('goBack');

    % Parse the local directory of resultant files (could be more than 1?)
    d = dir(LocalFolder + "/*.parquet");
    tOut = struct2table(d);

    % Format data types
    tOut.name   = string(tOut.name);
    tOut.folder = string(tOut.folder);
    tOut.date   = string(tOut.date);

    % Assumes a single file as written but can be expanded if need be
    ResultsFileLocal = fullfile(tOut.folder{1}, tOut.name{1});

    DisplayPath = (LocalFolder + "/" + tOut.name{1});
    fprintf("\nNotebook results have been downloaded here: %s\n", DisplayPath);
end

