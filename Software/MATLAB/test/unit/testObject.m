classdef testObject < matlab.unittest.TestCase
    % testObject Unit tests for databricks.Object composition delegation

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testConstruction(testCase)
            obj = databricks.Object();
            testCase.verifyClass(obj, 'databricks.Object');
        end

        function testUserAgentSetOnConstruction(testCase)
            obj = databricks.Object();
            testCase.verifyNotEmpty(obj.UserAgent);
            testCase.verifyTrue(startsWith(obj.UserAgent, "MathWorks_MATLAB/"));
        end

        function testGetUserAgentDefault(testCase)
            ua = databricks.Object.getUserAgent();
            testCase.verifyTrue(startsWith(ua, "MathWorks_MATLAB/"));
        end

        function testGetUserAgentCustomRelease(testCase)
            ua = databricks.Object.getUserAgent(release="R2025b");
            testCase.verifyEqual(ua, "MathWorks_MATLAB/25.2.0");
        end

        function testGetUserAgentDelegatesToInternal(testCase)
            ua = databricks.Object.getUserAgent(release="R2025a");
            internalUa = databricks.internal.Object.getUserAgent(release="R2025a");
            testCase.verifyEqual(ua, internalUa);
        end

        function testSanitizeHostTrailingSlash(testCase)
            result = databricks.Object.sanitizeHost("https://example.com/");
            testCase.verifyEqual(result, "https://example.com");
        end

        function testSanitizeHostNoTrailingSlash(testCase)
            result = databricks.Object.sanitizeHost("https://example.com");
            testCase.verifyEqual(result, "https://example.com");
        end

        function testSanitizeHostEmpty(testCase)
            result = databricks.Object.sanitizeHost("");
            testCase.verifyEqual(result, "");
        end

        function testSanitizeHostDelegatesToInternal(testCase)
            result = databricks.Object.sanitizeHost("https://test.com/");
            internalResult = databricks.internal.Object.sanitizeHost("https://test.com/");
            testCase.verifyEqual(result, internalResult);
        end

        function testEpochToTimestamp(testCase)
            ts = databricks.Object.epochToTimestamp(0);
            testCase.verifyClass(ts, 'datetime');
        end

        function testEpochToTimestampDelegatesToInternal(testCase)
            ts = databricks.Object.epochToTimestamp(1000000);
            internalTs = databricks.internal.Object.epochToTimestamp(1000000);
            testCase.verifyEqual(ts, internalTs);
        end

        function testTokenPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Token = 'test-token-123';
            testCase.verifyEqual(obj.Token, 'test-token-123');
        end

        function testHostPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Host = 'https://myhost.databricks.com';
            testCase.verifyEqual(obj.Host, 'https://myhost.databricks.com');
        end

        function testVersionPropertyDelegates(testCase)
            obj = databricks.Object();
            testCase.verifyEqual(obj.Version, '2.0');
            obj.Version = '2.1';
            testCase.verifyEqual(obj.Version, '2.1');
        end

        function testAuthMethodPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.AuthMethod = matlab.databricks.AuthMethod.PAT;
            testCase.verifyEqual(obj.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end

        function testAuthMethodEmptyByDefault(testCase)
            obj = databricks.Object();
            testCase.verifyEmpty(obj.AuthMethod);
        end

        function testGetURIDelegatesToInternal(testCase)
            obj = databricks.Object();
            obj.Host = 'https://example.databricks.com';
            uri = obj.getURI('clusters', 'list');
            testCase.verifyClass(uri, 'matlab.net.URI');
            testCase.verifyTrue(contains(string(uri), 'clusters/list'));
        end

        function testGetURIWithParams(testCase)
            obj = databricks.Object();
            obj.Host = 'https://example.databricks.com';
            uri = obj.getURI('clusters', 'get', 'cluster_id', '123');
            testCase.verifyTrue(contains(string(uri), 'cluster_id'));
        end

        function testIsPreviewScim(testCase)
            obj = databricks.Object();
            testCase.verifyTrue(obj.isPreview('scim'));
        end

        function testIsPreviewNonScim(testCase)
            obj = databricks.Object();
            testCase.verifyFalse(obj.isPreview('clusters'));
        end

        function testGetAuthLegacyPath(testCase)
            obj = databricks.Object();
            obj.getAuth('Host', 'https://example.com/', 'Token', 'abc123', 'Org_id', '456');
            testCase.verifyEqual(obj.Token, 'abc123');
            testCase.verifyEqual(obj.Host, 'https://example.com');
            testCase.verifyEqual(obj.Org_id, '456');
        end

        function testGetAuthorizationField(testCase)
            obj = databricks.Object();
            obj.Host = 'https://example.databricks.com';
            obj.Token = 'dapi_test_token';
            authField = obj.getAuthorizationField();
            testCase.verifyClass(authField, 'matlab.net.http.field.AuthorizationField');
        end

        function testGetRequestMessage(testCase)
            obj = databricks.Object();
            obj.Host = 'https://example.databricks.com';
            obj.Token = 'dapi_test_token';
            req = obj.getRequestMessage();
            testCase.verifyClass(req, 'matlab.net.http.RequestMessage');
        end

        function testGetRequestMessageWithMethod(testCase)
            obj = databricks.Object();
            obj.Host = 'https://example.databricks.com';
            obj.Token = 'dapi_test_token';
            req = obj.getRequestMessage('POST');
            testCase.verifyClass(req, 'matlab.net.http.RequestMessage');
            testCase.verifyEqual(string(req.Method), "POST");
        end

        function testOrgIdPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Org_id = '12345';
            testCase.verifyEqual(obj.Org_id, '12345');
        end

        function testProfilePropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Profile = 'MYPROFILE';
            testCase.verifyEqual(obj.Profile, 'MYPROFILE');
        end

        function testAccountIdPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.AccountId = 'acc-abc123';
            testCase.verifyEqual(obj.AccountId, 'acc-abc123');
        end

        function testUsernamePropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Username = 'user@example.com';
            testCase.verifyEqual(obj.Username, 'user@example.com');
        end

        function testPasswordPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.Password = 'secret123';
            testCase.verifyEqual(obj.Password, 'secret123');
        end

        function testClientIdPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.ClientId = 'my-client-id';
            testCase.verifyEqual(obj.ClientId, 'my-client-id');
        end

        function testClientSecretPropertyDelegates(testCase)
            obj = databricks.Object();
            obj.ClientSecret = 'my-client-secret';
            testCase.verifyEqual(obj.ClientSecret, 'my-client-secret');
        end

    end
end
