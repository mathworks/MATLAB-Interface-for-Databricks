classdef testConfigFile < matlab.unittest.TestCase
    % TESTCONFIGFILE Test Databricks ConfigFile

    % Copyright 2024-2026 The MathWorks, Inc.

    properties (TestParameter)
    end

    methods (Test)
        function testConstructor(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            testCase.verifyNotEmpty(cf.Profiles);
            testCase.verifyTrue(isProfile(cf, 'DEFAULT'));
            testCase.verifyFalse(isProfile(cf, 'NotARealProfile'));
            testCase.verifyTrue(isProfile(cf, 'ACCOUNT'));
            testCase.verifyTrue(cf.getProfile("ACCOUNT").isKey("host"));
            testCase.verifyTrue(cf.getProfile("ACCOUNT").isKey("account_id"));

            defaultProfile = cf.getProfile("DEFAULT");
            testCase.verifyTrue(isKey(defaultProfile, 'host'));
            testCase.verifyTrue(isKey(defaultProfile, 'token'));
            testCase.verifyClass(defaultProfile.getValue('token'), 'string');
            testCase.verifyClass(defaultProfile.getValue('host'), 'string');

            notThere = cf.getProfile("nothereprofile");
            testCase.verifyEmpty(notThere);
            testCase.verifyTrue(isa(notThere, 'databricks.internal.configurationprofile.Profile'));

            % Fails if DATABRICKS_CONFIG_PROFILE is set to a non "DEFAULT" value
            % skip for now
            % default = cf.getDefaultProfile();
            default = cf.getProfile("DEFAULT");
            testCase.verifyTrue(isKey(default, 'host'));
            testCase.verifyTrue(isKey(default, 'token'));

            profileList = cf.listProfiles;
            testCase.verifyEqual(sum(contains(profileList, "DEFAULT")), 1);
            testCase.verifyEqual(sum(contains(profileList, "ACCOUNT")), 1);
            testCase.verifyEqual(4, numel(profileList));
        end


        function testCfgFilePath(testCase)
            testCase.verifyNotEmpty(matlab.utils.getHomeDirectory());

            % Can't assume this is in the home directory
            % testCase.verifyEqual(databricks.internal.configurationprofile.ConfigFile.getCfgFilePath, fullfile(char(java.lang.System.getProperty('user.home')), '.databrickscfg'));

            testCase.verifyTrue(isfile(databricks.internal.configurationprofile.ConfigFile.getCfgFilePath));
        end


        function testGetDefaultProfile(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            % Fails if DATABRICKS_CONFIG_PROFILE is set to a non "DEFAULT" value
            defaultProfile = cf.getProfile("DEFAULT");
            if ~isempty(defaultProfile.Name) || strlength(defaultProfile.Name) > 0
                testCase.verifyEqual(defaultProfile.Name, "DEFAULT")
            end

            testCase.verifyTrue(isKey(defaultProfile, 'host'));
            testCase.verifyTrue(isKey(defaultProfile, 'token'));
            testCase.verifyClass(defaultProfile.getValue('host'), 'string');
            testCase.verifyClass(defaultProfile.getValue('token'), 'string');

            import matlab.unittest.fixtures.EnvironmentVariableFixture
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","ACCOUNT");
            testCase.applyFixture(fixtureCfgProfile);

            accProfile = cf.getDefaultProfile;
            testCase.verifyTrue(isKey(accProfile, 'host'));
            testCase.verifyTrue(isKey(accProfile, 'account_id'));
            testCase.verifyClass(defaultProfile.getValue('host'), 'string');
            testCase.verifyClass(defaultProfile.getValue('account_id'), 'string');
        end


        function testGetDefaultProfileName(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            % Fails if DATABRICKS_CONFIG_PROFILE is set to a non "DEFAULT" value
            envVar = getenv("DATABRICKS_CONFIG_PROFILE");
            if isempty(envVar)
                defaultResult = "DEFAULT";
            else
                defaultResult = string(envVar);
            end

            defaultProfileName = cf.getInstanceDefaultProfileName();
            testCase.verifyEqual(defaultProfileName, defaultResult);

            defaultProfileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName();
            testCase.verifyEqual(defaultProfileName, defaultResult);

            defaultProfileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(verbose=true);
            testCase.verifyEqual(defaultProfileName, defaultResult);

            % Run this last because of clean up
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            fixtureCfgProfile = EnvironmentVariableFixture("DATABRICKS_CONFIG_PROFILE","NEWTESTVALUE");
            testCase.applyFixture(fixtureCfgProfile);

            defaultProfileName = cf.getInstanceDefaultProfileName();
            testCase.verifyEqual(defaultProfileName, "NEWTESTVALUE");

            defaultProfileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(verbose=true);
            testCase.verifyEqual(defaultProfileName, "NEWTESTVALUE");
        end


        function testCommentProfile(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            p = cf.getProfile("WITHCOMMENT", enableEnvVarOverrides=false);
            testCase.verifyEqual(p.Name, "WITHCOMMENT");
            testCase.verifyTrue(isKey(p, 'host'));
            testCase.verifyTrue(isKey(p, 'token'));
            testCase.verifyClass(p.getValue('host'), 'string');
            testCase.verifyClass(p.getValue('token'), 'string');
            testCase.verifyEqual(p.getValue('host'), "https://withcomment.databricks.com");
            testCase.verifyEqual(p.getValue('token'), "commenttoken");
        end


        function testSpacedProfile(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            p = cf.getProfile("spaced profile", enableEnvVarOverrides=false);
            testCase.verifyEqual(p.Name, "spaced profile");
            testCase.verifyTrue(isKey(p, 'host'));
            testCase.verifyTrue(isKey(p, 'token'));
            testCase.verifyClass(p.getValue('host'), 'string');
            testCase.verifyClass(p.getValue('token'), 'string');
            testCase.verifyEqual(p.getValue('host'), "https://myhost");
            testCase.verifyEqual(p.getValue('token'), "dapi567");
        end


        function testAccountProfile(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            p = cf.getProfile("ACCOUNT", enableEnvVarOverrides=false);
            testCase.verifyEqual(p.Name, "ACCOUNT");
            
            testCase.verifyTrue(isKey(p, 'host'));
            testCase.verifyClass(p.getValue('host'), 'string');
            testCase.verifyEqual(p.getValue('host'), "https://accounts.cloud.databricks.com");
            
            testCase.verifyTrue(isKey(p, 'username'));
            testCase.verifyClass(p.getValue('username'), 'string');
            testCase.verifyEqual(p.getValue('username'), "someone@example.com");
            
            testCase.verifyTrue(isKey(p, 'password'));
            testCase.verifyClass(p.getValue('password'), 'string');
            testCase.verifyEqual(p.getValue('password'), "MyP25");

            testCase.verifyTrue(isKey(p, 'account_id'));
            testCase.verifyClass(p.getValue('account_id'), 'string');
            testCase.verifyEqual(p.getValue('account_id'), "ab0cd1");
        end


        function testDefaultProfile(testCase)
            cfgFile = databricksRoot("test", "fixtures", "ConfigFile", ".databrickscfg1");
            testCase.verifyTrue(isfile(cfgFile));
            cf = databricks.internal.configurationprofile.ConfigFile(cfgFile);
            
            p = cf.getProfile("DEFAULT", enableEnvVarOverrides=false);
            testCase.verifyEqual(p.Name, "DEFAULT");
            
            testCase.verifyTrue(isKey(p, 'host'));
            testCase.verifyClass(p.getValue('host'), 'string');
            testCase.verifyEqual(p.getValue('host'), "https://dbc-a1b2345c-d6e7.cloud.databricks.com");
            
            testCase.verifyTrue(isKey(p, 'token'));
            testCase.verifyClass(p.getValue('token'), 'string');
            testCase.verifyEqual(p.getValue('token'), "dapi123");
        end
    end
end