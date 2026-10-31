classdef testOauthService < matlab.unittest.TestCase
    % testOauthService Unit tests for the OauthService enumeration

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testEnumMembers(testCase)
            testCase.verifyClass(matlab.databricks.OauthService.Databricks, 'matlab.databricks.OauthService');
            testCase.verifyClass(matlab.databricks.OauthService.EntraID, 'matlab.databricks.OauthService');
            testCase.verifyClass(matlab.databricks.OauthService.Unspecified, 'matlab.databricks.OauthService');
        end

        function testEnumEquality(testCase)
            testCase.verifyEqual(matlab.databricks.OauthService.Databricks, matlab.databricks.OauthService.Databricks);
            testCase.verifyNotEqual(matlab.databricks.OauthService.Databricks, matlab.databricks.OauthService.EntraID);
            testCase.verifyNotEqual(matlab.databricks.OauthService.EntraID, matlab.databricks.OauthService.Unspecified);
        end

        function testInternalImpl(testCase)
            d = matlab.databricks.OauthService.Databricks;
            testCase.verifyEqual(d.OauthServiceImpl, matlab.internal.databricks.OauthService.Databricks);

            e = matlab.databricks.OauthService.EntraID;
            testCase.verifyEqual(e.OauthServiceImpl, matlab.internal.databricks.OauthService.EntraID);

            u = matlab.databricks.OauthService.Unspecified;
            testCase.verifyEqual(u.OauthServiceImpl, matlab.internal.databricks.OauthService.Unspecified);
        end
    end
end
