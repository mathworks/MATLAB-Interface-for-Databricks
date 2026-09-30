function [results] = RunAllTests(testLocations, testName, options)
    %RUNALLTESTS CI/CD Entry point to run all tests
    % Entry stub for the CI/CD pipeline to run all tests
    
    % Copyright 2021-2026, The MathWorks, Inc.

    arguments
        testLocations string
        testName (1,1) string
        options.outputDirectory (1,1) string
    end


    import matlab.unittest.TestRunner;
    import matlab.unittest.TestSuite;
    import matlab.unittest.plugins.XMLPlugin;
    
    % Define the test suite
    if ~iscell(testLocations)
        testLocations = {testLocations};
    end
    suite = [];
    for lCount = 1:numel(testLocations)
        testFolder = testLocations{lCount};
        suite = [suite TestSuite.fromFolder(testFolder)]; %#ok<AGROW> 
    end
    
    % Setup the runner
    runner = TestRunner.withNoPlugins;
    %     runner = TestRunner.withTextOutput('OutputDetail',3);
    % import matlab.unittest.plugins.TestReportPlugin

    runner.addPlugin(matlab.unittest.plugins.DiagnosticsRecordingPlugin);

    % Add JUnit style reports
    xmlFileName = [char(testName), '.xml'];
    if isfield(options, 'outputDirectory')
        if ~isfolder(options.outputDirectory)
            mkdir(options.outputDirectory)
        end
        xmlFile = fullfile(options.outputDirectory, xmlFileName);
    else
        drTmpDir = databricksRoot('tmp');
        [status, msg] = mkdir(drTmpDir);
        if status ~= 1
            error("Unable to create temporary directory: %s", drTmpDir, msg);
        end
        xmlFile = fullfile(drTmpDir, xmlFileName);
    end
    p = XMLPlugin.producingJUnitFormat(xmlFile);
    runner.addPlugin(p);
    
    % Run the tests and display results
    results = runner.run(suite);
    table(results)
    displayFailures(results)
end

function displayFailures(results)
    idx = find([results.Failed]);
    for k=idx
        R = results(k);
        fprintf('+++++++++++++++++++++++++++++++++++++++\n')
        fprintf("Failure: %s\n", R.Name);
        if isfield(R.Details, 'DiagnosticRecord')
            fprintf('%s\n', R.Details.DiagnosticRecord.Report)
        end
    end
end