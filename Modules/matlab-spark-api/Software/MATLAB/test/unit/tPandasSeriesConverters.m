classdef tPandasSeriesConverters < matlab.unittest.TestCase
%

% Copyright 2026 The MathWorks, Inc.


    methods (TestClassSetup)

        function checkMATLABEngine(testCase)
            try 
                ml = py.importlib.import_module("matlab"); %#ok<NASGU>
            catch ME
                testCase.assumeTrue(false, "matlabengine python package is not installed");
            end
        end
    end

    methods (Test)
        function TestPandasSeriesConverters(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture
            fixture = testCase.applyFixture(WorkingFolderFixture); %#ok<NASGU>

            sparkRoot = getSparkApiRoot();
            sourceCodeFile = fullfile(sparkRoot, "app", "system", ...
                "+compiler", "+build", "+spark", "@PythonSparkBuilder", ...
                "converters.py");
            copyfile(sourceCodeFile, pwd);

            testCodeFile = fullfile(sparkRoot, "test", "fixtures", ...
                "pandas_series_converters_tests.py");
            copyfile(testCodeFile, pwd);

            [status, msg] = system(compose("%s pandas_series_converters_tests.py", pyenv().Executable));
            testCase.verifyEqual(status, 0, compose("Failure Report:\n%s", msg))    
         end
    end
end
