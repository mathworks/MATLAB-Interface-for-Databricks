classdef testGetHTTPOptions < matlab.unittest.TestCase
    % testGetHTTPOptions Unit tests for databricks.internal.getHTTPOptions

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testCallsImplSuccessfully(testCase)
            opts = databricks.internal.getHTTPOptions();
            testCase.verifyClass(opts, 'matlab.net.http.HTTPOptions');
        end
    end
end
