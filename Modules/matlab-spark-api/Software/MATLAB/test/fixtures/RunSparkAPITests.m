function [results] = RunSparkAPITests(testLocations)
    % RunSparkAPITests CI/CD Entry point to run all tests
    
    % Copyright 2026 The MathWorks, Inc.
    
    arguments
        testLocations cell = {getSparkApiRoot('test', 'unit')}
    end

    testName = "matlab-spark-api";

    import matlab.unittest.TestRunner;
    import matlab.unittest.TestSuite;
    import matlab.unittest.plugins.XMLPlugin;
    
    % Define the test suite

    suite = [];
    for lCount = 1:numel(testLocations)
        testFolder = testLocations{lCount};
        suite = [suite TestSuite.fromFolder(testFolder, IncludeSubfolders=true)]; %#ok<AGROW> 
    end
    
    % Setup the runner
    runner = TestRunner.withNoPlugins;

    runner.addPlugin(matlab.unittest.plugins.DiagnosticsRecordingPlugin);

    % Add JUnit style reports
    xmlFile = getSparkApiRoot('tmp',[char(testName), '.xml']);
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