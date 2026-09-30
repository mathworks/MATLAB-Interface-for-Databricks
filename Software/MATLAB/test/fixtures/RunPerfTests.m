function [results] = RunPerfTests(testPath,outDir)
%RUNPERFTESTS CI/CD Entry point to run perf tests
%   testPath  - Path to performance tests
%   outDir    - Path to store perf test results

% Copyright 2026 The MathWorks, Inc.

outPerf = runperf(testPath);
testRunSummary = outPerf.sampleSummary;

% Check the status of failed tests only. The runperf command considers both
% filtered and failed tests as invalid, so using TestActivity data below to
% extract the failed test summary only.
results = vertcat(outPerf.TestActivity);

% Generate date, MATLAB release, and CI Branch columns, and add them to test results
% table.
nRows = height(testRunSummary);
currRelease = matlabRelease;
dateCol = repelem(datetime('now'),nRows,1);
releaseCol = repelem(currRelease.Release,nRows,1);
branchCol = repelem(string(getenv('CI_COMMIT_BRANCH')),nRows,1);
testRunInfo = table(dateCol,releaseCol,branchCol,'VariableNames',{'Date','Release','Branch'});
finalTable = [testRunInfo testRunSummary];

% Store perf test results in Databricks.
sparkSession = getDatabricksSession();
sparkDataset = matlab.sparkutils.table2dataset(finalTable,sparkSession);
sparkDataset.write.format('delta').mode('append').option('mergeSchema','true').save(outDir);
end