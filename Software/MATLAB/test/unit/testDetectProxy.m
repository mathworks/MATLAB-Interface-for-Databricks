classdef testDetectProxy < matlab.unittest.TestCase
    % testDetectProxy Unit tests for matlab.databricks.detectProxy delegation

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testReturnsLogicalAndURI(testCase)
            [tf, proxyURI] = matlab.databricks.detectProxy();
            testCase.verifyClass(tf, 'logical');
            testCase.verifyTrue(isa(proxyURI, 'matlab.net.URI') || isempty(proxyURI));
        end

        function testDelegatesToInternal(testCase)
            [tf, proxyURI] = matlab.databricks.detectProxy();
            [tfInternal, proxyURIInternal] = matlab.internal.databricks.detectProxy();
            testCase.verifyEqual(tf, tfInternal);
            testCase.verifyEqual(proxyURI, proxyURIInternal);
        end
    end
end
