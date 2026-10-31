classdef testIsOnDatabricks < matlab.unittest.TestCase
    % testIsOnDatabricks Unit tests for databricks.internal.isOnDatabricks

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testCallsImplSuccessfully(testCase)
            tf = databricks.internal.isOnDatabricks();
            testCase.verifyClass(tf, 'logical');
        end
    end
end
