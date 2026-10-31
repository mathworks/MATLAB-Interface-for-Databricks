classdef testNewVersionCheck < matlab.unittest.TestCase
    % testNewVersionCheck Unit tests for databricks.internal.utils.newVersionCheck

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testCallsImplSuccessfully(testCase)
            tf = databricks.internal.utils.newVersionCheck(verbose=false, forceCheck=false);
            testCase.verifyClass(tf, 'logical');
        end
    end
end
