classdef testOauth < matlab.unittest.TestCase
    % testOauth Unit tests for databricks.internal.unifiedauthentication.Oauth

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testConstruction(testCase)
            obj = databricks.internal.unifiedauthentication.Oauth();
            testCase.verifyClass(obj, 'databricks.internal.unifiedauthentication.Oauth');
        end


        function testClientIdDefault(testCase)
            obj = databricks.internal.unifiedauthentication.Oauth();
            testCase.verifyEqual(obj.clientId, "databricks-cli");
        end


        function testGenVerifierChallengeReturnsStrings(testCase)
            [verifier, challenge] = databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge();
            testCase.verifyClass(verifier, 'string');
            testCase.verifyClass(challenge, 'string');
            testCase.verifyTrue(strlength(verifier) > 0);
            testCase.verifyTrue(strlength(challenge) > 0);
        end


        function testGenVerifierChallengeUniqueness(testCase)
            [verifier1, challenge1] = databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge();
            [verifier2, challenge2] = databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge();
            testCase.verifyNotEqual(verifier1, verifier2);
            testCase.verifyNotEqual(challenge1, challenge2);
        end


        function testGenVerifierChallengeFormat(testCase)
            [verifier, ~] = databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge();
            parts = split(verifier, "-");
            testCase.verifyGreaterThan(numel(parts), 1);
        end


        function testEpochSecondsUTCNow(testCase)
            [tString, tInt64] = databricks.internal.unifiedauthentication.Oauth.epochSecondsUTCNow();
            testCase.verifyClass(tString, 'string');
            testCase.verifyClass(tInt64, 'int64');
            testCase.verifyEqual(tString, string(tInt64));
            testCase.verifyGreaterThan(tInt64, int64(0));
        end


        function testEpochSecondsUTCNowReasonableValue(testCase)
            [~, tInt64] = databricks.internal.unifiedauthentication.Oauth.epochSecondsUTCNow();
            % Should be after 2024-01-01 (epoch 1704067200)
            testCase.verifyGreaterThan(tInt64, int64(1704067200));
        end


        function testIsTokenCachingDisabledDefault(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DISABLE_DATABRICKS_TOKEN_CACHE", ""));

            tf = databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled();
            testCase.verifyFalse(tf);
        end


        function testIsTokenCachingDisabledTrue(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DISABLE_DATABRICKS_TOKEN_CACHE", "true"));

            tf = databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled();
            testCase.verifyTrue(tf);
        end


        function testIsTokenCachingDisabledTrueUpperCase(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DISABLE_DATABRICKS_TOKEN_CACHE", "TRUE"));

            tf = databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled();
            testCase.verifyTrue(tf);
        end


        function testIsTokenCachingDisabledFalseValue(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DISABLE_DATABRICKS_TOKEN_CACHE", "false"));

            tf = databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled();
            testCase.verifyFalse(tf);
        end


        function testGetDefaultCacheFilePathU2M(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN_CACHE_FILE", ""));

            cacheFilePath = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.OauthU2M);
            testCase.verifyClass(cacheFilePath, 'string');
            testCase.verifyTrue(endsWith(cacheFilePath, ".databricksOauthTokenCache"));
        end


        function testGetDefaultCacheFilePathM2M(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN_CACHE_FILE", ""));

            cacheFilePath = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.OauthM2M);
            testCase.verifyClass(cacheFilePath, 'string');
            testCase.verifyTrue(endsWith(cacheFilePath, ".databricksOauthTokenCache"));
        end


        function testGetDefaultCacheFilePathFromEnvVar(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN_CACHE_FILE", "/tmp/custom_cache"));

            cacheFilePath = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.OauthU2M);
            testCase.verifyEqual(cacheFilePath, "/tmp/custom_cache");
        end


        function testGetDefaultCacheFilePathErrorsForPAT(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN_CACHE_FILE", ""));

            testCase.verifyError(@() databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(matlab.internal.databricks.AuthMethod.PAT), ...
                "DATABRICKS:getDefaultCacheFilePath");
        end


        function testMissingFieldWarningIssuesWarning(testCase)
            s = struct('access_token', 'abc123');
            testCase.verifyWarning(@() databricks.internal.unifiedauthentication.Oauth.missingFieldWarning(s, "refresh_token"), ...
                "DATABRICKS:getToken");
        end


        function testMissingFieldWarningNoWarningWhenPresent(testCase)
            s = struct('access_token', 'abc123');
            testCase.verifyWarningFree(@() databricks.internal.unifiedauthentication.Oauth.missingFieldWarning(s, "access_token"));
        end
    end
end
