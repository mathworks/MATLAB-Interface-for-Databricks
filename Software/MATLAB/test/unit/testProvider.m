
classdef testProvider < matlab.unittest.TestCase
    % testProvider Test Databricks testProvider

    % Copyright 2024 The MathWorks, Inc.

    properties (TestParameter)
    end

    methods (Test)
        function testConstructor(testCase)
            if isempty(getenv("DATABRICKS_HOST"))

                % First handle environment variables cleanly
                import matlab.unittest.fixtures.EnvironmentVariableFixture
                
                cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
                fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
                testCase.applyFixture(fixtureCfgFile)

                fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
                testCase.applyFixture(fixtureCfgProfile);

                % Actual tests
                p = databricks.internal.unifiedauthentication.Provider(verbose=true);
                testCase.verifyTrue(p.Populated);
                testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
                testCase.verifyEqual(p.Source, cfgFile);

                testCase.verifyTrue(isKey(p.Profile, 'host'));
                testCase.verifyTrue(isKey(p.Profile, 'token'));
                testCase.verifyClass(p.Profile.getValue('token'), 'string');
                testCase.verifyClass(p.Profile.getValue('host'), 'string');

                [tf, cfgFileNew] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile;
                testCase.verifyTrue(tf);
                testCase.verifyEqual(string(cfgFileNew), cfgFile);
            else
                p = databricks.internal.unifiedauthentication.Provider(verbose=true);
                testCase.verifyTrue(p.Populated);
                testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
                testCase.verifyEqual(p.Source, "Environment");

                testCase.verifyTrue(isKey(p.Profile, 'host'));
                testCase.verifyTrue(isKey(p.Profile, 'token'));
                testCase.verifyClass(p.Profile.getValue('token'), 'string');
                testCase.verifyClass(p.Profile.getValue('host'), 'string');
            end
        end


        function testBasic(testCase)
            % Basic is not populated in the gitlab environment so this should work

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)

            p = databricks.internal.unifiedauthentication.Provider(RequestedAuthMethod=matlab.databricks.AuthMethod.Basic);
            testCase.verifyNotEqual(p.AuthMethod, matlab.databricks.AuthMethod.Basic);
            testCase.verifyFalse(p.Populated);
            testCase.verifyEqual(strlength(p.Source), 0);
            testCase.verifyEmpty(keys(p.Profile));
        end


        function testGetSetHost(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.Host, "");
            p.Host = "https://my-workspace.cloud.databricks.com";
            testCase.verifyEqual(p.Host, "https://my-workspace.cloud.databricks.com");
        end


        function testGetSetToken(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.Token, "");
            p.Token = "dapi1234567890abcdef";
            testCase.verifyEqual(p.Token, "dapi1234567890abcdef");
        end


        function testGetSetUsername(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.Username, "");
            p.Username = "testuser@example.com";
            testCase.verifyEqual(p.Username, "testuser@example.com");
        end


        function testGetSetPassword(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.Password, "");
            p.Password = "secretpassword";
            testCase.verifyEqual(p.Password, "secretpassword");
        end


        function testGetSetAccountId(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.AccountId, "");
            p.AccountId = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";
            testCase.verifyEqual(p.AccountId, "a1b2c3d4-e5f6-7890-abcd-ef1234567890");
        end


        function testGetSetClientId(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.ClientId, "");
            p.ClientId = "my-client-id";
            testCase.verifyEqual(p.ClientId, "my-client-id");
        end


        function testGetSetClientSecret(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.ClientSecret, "");
            p.ClientSecret = "my-client-secret";
            testCase.verifyEqual(p.ClientSecret, "my-client-secret");
        end


        function testGetSetSource(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.Source, "");
            p.Source = "Environment";
            testCase.verifyEqual(p.Source, "Environment");
        end


        function testGetSetPopulated(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyFalse(p.Populated);
            p.Populated = true;
            testCase.verifyTrue(p.Populated);
        end


        function testGetSetAuthenticated(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyFalse(p.Authenticated);
            p.Authenticated = true;
            testCase.verifyTrue(p.Authenticated);
        end


        function testGetSetAuthMethod(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEmpty(p.AuthMethod);
            p.AuthMethod = matlab.databricks.AuthMethod.PAT;
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end


        function testGetSetRequestedAuthMethod(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEqual(p.RequestedAuthMethod, matlab.databricks.AuthMethod.Chain);
            p.RequestedAuthMethod = matlab.databricks.AuthMethod.OauthM2M;
            testCase.verifyEqual(p.RequestedAuthMethod, matlab.databricks.AuthMethod.OauthM2M);
        end


        function testGetSetProfile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            testCase.verifyEmpty(keys(p.Profile));
            p.Host = "https://test.databricks.com";
            p.Token = "dapi_test_token";
            testCase.verifyEqual(p.Host, "https://test.databricks.com");
            testCase.verifyEqual(p.Token, "dapi_test_token");
        end


        function testPopulatePATFromCfgFile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
            testCase.verifyEqual(p.Host, "https://dbc-a1b2345c-d6e7.cloud.databricks.com");
            testCase.verifyEqual(p.Token, "dapi123");
            testCase.verifyEqual(p.Source, cfgFile);
        end


        function testPopulatePATFromEnvVars(testCase)

            import matlab.unittest.fixtures.EnvironmentVariableFixture

            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://env-host.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", "dapi_env_token"));
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
            testCase.verifyEqual(p.Host, "https://env-host.databricks.com");
            testCase.verifyEqual(p.Token, "dapi_env_token");
            testCase.verifyEqual(p.Source, "Environment");
        end


        function testPopulateChainFallsThroughToPAT(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.Chain, verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end


        % function testPopulateFailsWithNoCredentials(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        % 
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", "/nonexistent/path/.databrickscfg"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
        % 
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, verbose=false);
        % 
        %     testCase.verifyFalse(tf);
        %     testCase.verifyFalse(p.Populated);
        % end


        function testPopulateWithNamedProfile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, profileName="WITHCOMMENT", verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyEqual(p.Host, "https://withcomment.databricks.com");
            testCase.verifyEqual(p.Token, "commenttoken");
        end


        function testAuthenticatePATSuccess(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, verbose=false);
            tf = p.authenticate(verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Authenticated);
            testCase.verifyTrue(strlength(p.Token) > 0);
        end


        function testAuthenticateFailsWhenNotPopulated(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.authenticate(verbose=false);

            testCase.verifyFalse(tf);
            testCase.verifyFalse(p.Authenticated);
        end


        function testAuthenticateFullPATWorkflow(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://test-workflow.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", "dapi_workflow_token"));
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            p.populate(requestedAuthMethod=matlab.databricks.AuthMethod.PAT, verbose=false);
            tf = p.authenticate(verbose=false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Authenticated);
            testCase.verifyEqual(p.Token, "dapi_workflow_token");
            testCase.verifyEqual(p.Host, "https://test-workflow.databricks.com");
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end


        function testChainPopResolvesPATFromEnvVars(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://chain-env.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", "dapi_chain_token"));

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            [tf, actualAuthMethod] = p.chainPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyEqual(actualAuthMethod, matlab.databricks.AuthMethod.PAT);
            testCase.verifyEqual(p.Host, "https://chain-env.databricks.com");
            testCase.verifyEqual(p.Token, "dapi_chain_token");
        end


        function testChainPopResolvesPATFromCfgFile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            [tf, actualAuthMethod] = p.chainPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyEqual(actualAuthMethod, matlab.databricks.AuthMethod.PAT);
            testCase.verifyEqual(p.Host, "https://dbc-a1b2345c-d6e7.cloud.databricks.com");
            testCase.verifyEqual(p.Token, "dapi123");
        end


        % function testChainPopFailsWithNoCredentials(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        % 
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", "/nonexistent/path/.databrickscfg"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
        % 
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     [tf, actualAuthMethod] = p.chainPop("DEFAULT", false);
        % 
        %     testCase.verifyFalse(tf);
        %     testCase.verifyEmpty(actualAuthMethod);
        % end


        function testChainPopWithNamedProfile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            [tf, actualAuthMethod] = p.chainPop("WITHCOMMENT", false);

            testCase.verifyTrue(tf);
            testCase.verifyEqual(actualAuthMethod, matlab.databricks.AuthMethod.PAT);
            testCase.verifyEqual(p.Host, "https://withcomment.databricks.com");
            testCase.verifyEqual(p.Token, "commenttoken");
        end


        function testPatPopFromEnvVars(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://patpop-env.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", "dapi_patpop_env"));
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.patPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://patpop-env.databricks.com");
            testCase.verifyEqual(p.Token, "dapi_patpop_env");
            testCase.verifyEqual(p.Source, "Environment");
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end


        function testPatPopFromCfgFileDefaultProfile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.patPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://dbc-a1b2345c-d6e7.cloud.databricks.com");
            testCase.verifyEqual(p.Token, "dapi123");
            testCase.verifyEqual(p.Source, cfgFile);
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.PAT);
        end


        function testPatPopFromCfgFileNamedProfile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.patPop("WITHCOMMENT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://withcomment.databricks.com");
            testCase.verifyEqual(p.Token, "commenttoken");
            testCase.verifyEqual(p.Source, cfgFile);
        end


        function testPatPopEnvVarsOverrideCfgFile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://env-override.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", "dapi_env_override"));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.patPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyEqual(p.Host, "https://env-override.databricks.com");
            testCase.verifyEqual(p.Token, "dapi_env_override");
            testCase.verifyEqual(p.Source, "Environment");
        end


        % function testPatPopFailsWithNoCredentials(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        %
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", "/nonexistent/path/.databrickscfg"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        %
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.patPop("DEFAULT", false);
        %
        %     testCase.verifyFalse(tf);
        %     testCase.verifyFalse(p.Populated);
        %     testCase.verifyEqual(p.Source, "");
        % end

        % TODO:FIXME: Uncomment this test after fixing
        % https://gitlab.mathworks.com/dev/external/matlab/mlio/databricks/-/issues/70
        % in IDP
        % function testOauthM2MPopFromEnvVars(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        % 
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://m2m-env.databricks.com"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", "env-client-id"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", "env-client-secret"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.oauthM2MPop("DEFAULT", false);
        % 
        %     testCase.verifyTrue(tf);
        %     testCase.verifyTrue(p.Populated);
        %     testCase.verifyEqual(p.Host, "https://m2m-env.databricks.com");
        %     testCase.verifyEqual(p.ClientId, "env-client-id");
        %     testCase.verifyEqual(p.ClientSecret, "env-client-secret");
        %     testCase.verifyEqual(p.Source, "Environment");
        %     testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.OauthM2M);
        % end

        % TODO:FIXME: Uncomment this test after fixing
        % https://gitlab.mathworks.com/dev/external/matlab/mlio/databricks/-/issues/70
        % in IDP
        % function testOauthM2MPopFromEnvVarsWithAccountId(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        % 
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://accounts.cloud.databricks.com"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", "acct-client-id"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", "acct-client-secret"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", "acc-99999"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        % 
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.oauthM2MPop("DEFAULT", false);
        % 
        %     testCase.verifyTrue(tf);
        %     testCase.verifyTrue(p.Populated);
        %     testCase.verifyEqual(p.Host, "https://accounts.cloud.databricks.com");
        %     testCase.verifyEqual(p.ClientId, "acct-client-id");
        %     testCase.verifyEqual(p.ClientSecret, "acct-client-secret");
        %     testCase.verifyEqual(p.AccountId, "acc-99999");
        %     testCase.verifyEqual(p.Source, "Environment");
        % end


        function testOauthM2MPopFromCfgFile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg_m2m");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.oauthM2MPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://dbc-m2m-workspace.cloud.databricks.com");
            testCase.verifyEqual(p.ClientId, "test-client-id-123");
            testCase.verifyEqual(p.ClientSecret, "test-client-secret-456");
            testCase.verifyEqual(p.Source, cfgFile);
        end


        function testOauthM2MPopFromCfgFileAccountLevel(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg_m2m");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.oauthM2MPop("ACCOUNT_LEVEL", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://accounts.cloud.databricks.com");
            testCase.verifyEqual(p.ClientId, "account-client-id");
            testCase.verifyEqual(p.ClientSecret, "account-client-secret");
            testCase.verifyEqual(p.AccountId, "acc-12345");
        end


        % function testOauthM2MPopFailsWithNoCredentials(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        %
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", "/nonexistent/path/.databrickscfg"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        %
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.oauthM2MPop("DEFAULT", false);
        %
        %     testCase.verifyFalse(tf);
        %     testCase.verifyFalse(p.Populated);
        %     testCase.verifyEqual(p.Source, "");
        % end


        function testOauthU2MPopFromEnvVarsWorkspaceLevel(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://u2m-workspace.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);
            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.oauthU2MPop("DEFAULT", false);
            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://u2m-workspace.databricks.com");
            testCase.verifyEqual(p.AccountId, "");
            testCase.verifyEqual(p.Source, "Environment");
            testCase.verifyEqual(p.AuthMethod, matlab.databricks.AuthMethod.OauthU2M);
        end


        function testOauthU2MPopFromEnvVarsAccountLevel(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", "https://accounts.cloud.databricks.com"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", "acc-u2m-12345"));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            fixtureCfgFile = EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE",cfgFile);
            testCase.applyFixture(fixtureCfgFile)
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","");
            testCase.applyFixture(fixtureCfgProfile);

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.oauthU2MPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://accounts.cloud.databricks.com");
            testCase.verifyEqual(p.AccountId, "acc-u2m-12345");
            testCase.verifyEqual(p.Source, "Environment");
        end


        function testOauthU2MPopFromCfgFile(testCase)
            import matlab.unittest.fixtures.EnvironmentVariableFixture

            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", cfgFile));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));

            p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
            tf = p.oauthU2MPop("DEFAULT", false);

            testCase.verifyTrue(tf);
            testCase.verifyTrue(p.Populated);
            testCase.verifyEqual(p.Host, "https://dbc-a1b2345c-d6e7.cloud.databricks.com");
            testCase.verifyEqual(p.Source, cfgFile);
        end


        % function testOauthU2MPopFailsWithNoHost(testCase)
        %     import matlab.unittest.fixtures.EnvironmentVariableFixture
        % 
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_HOST", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_ACCOUNT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_TOKEN", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_ID", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CLIENT_SECRET", ""));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_FILE", "/nonexistent/path/.databrickscfg"));
        %     testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE", ""));
        % 
        %     p = databricks.internal.unifiedauthentication.Provider(enablePopulate=false, enableAuthenticate=false);
        %     tf = p.oauthU2MPop("DEFAULT", false);
        % 
        %     testCase.verifyFalse(tf);
        %     testCase.verifyFalse(p.Populated);
        %     testCase.verifyEqual(p.Source, "");
        % end
    end
end

