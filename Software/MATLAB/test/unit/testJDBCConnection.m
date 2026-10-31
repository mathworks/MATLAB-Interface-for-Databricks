classdef testJDBCConnection < matlab.unittest.TestCase
    % testJDBCConnection Unit tests for the JDBCConnection operations
    
    % Copyright 2024-2026 The MathWorks, Inc.

    properties(Constant)
        JavaVersion = databricks.JDBCConnectionImpl.getJavaVersion()
    end

    methods (Test)
        function testConstructor(testCase)
            testCase.assumeFalse(testCase.JavaVersion > 8, "Filtered until #885 is fixed.");

            % Default constructor
            disp('Running testConstructor');

            jc = databricks.JDBCConnection('jarFilePath', databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar"));
            
            testCase.verifyInstanceOf(jc, 'databricks.JDBCConnection');

            testCase.verifyClass(jc.Connection, 'database.jdbc.connection');
            testCase.verifyClass(jc.ConnectionURL, 'string');
            jc.close();
        end


        function testGetDefaultDriver(testCase)
            % ODBC static method test - to be moved
            driver = databricks.ODBCConnection.getDefaultDriver();
            testCase.verifyNotEmpty(driver);
            testCase.verifyEqual(driver, "{Simba Spark ODBC Driver}");
        end

        function testBackticks(testCase)
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("catalog"), "catalog");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("cat-alog"), "`cat-alog`");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("`catalog`"), "`catalog`");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName(" catalog "), "catalog");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("cat alog"), "`cat alog`");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName(" cat alog "), "`cat alog`");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("`cat  alog`"), "`cat  alog`");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName("` cat  alog `"), "` cat  alog `");
            testCase.verifyEqual(databricks.JDBCConnection.escapeUCName(""), "");
        end


        function testisOSSDriver(testCase)
            if databricks.JDBCConnection.isOSSDriver
                testCase.verifyTrue(databricks.JDBCConnection.isOSSDriver);
            else
                testCase.verifyFalse(databricks.JDBCConnection.isOSSDriver);
            end
        end

        function testcheckDataSources(testCase)
            % Verify that calling the function does not throw an error by wrapping in a function handle
            testCase.verifyWarningFree(@() databricks.JDBCConnection.checkDataSources);
        end

        function testgetDefaultJarFilePath(testCase)
            % Returns the settings-configured path when a valid jar is set
            import matlab.unittest.fixtures.EnvironmentVariableFixture
            tmpDir = testCase.createTemporaryFolder();

            % Use a temporary copy of the settings file so the shared file is not modified
            tmpSettingsFile = fullfile(tmpDir, "databricks-settings.json");
            settingsFile = databricks.internal.settings.Settings.getSettingsFileReadPath();
            if isfile(settingsFile)
                copyfile(settingsFile, tmpSettingsFile);
            else
                fid = fopen(tmpSettingsFile, 'w'); fwrite(fid, '{}'); fclose(fid);
            end
            testCase.applyFixture(EnvironmentVariableFixture("DATABRICKS_SETTINGS_FILE", tmpSettingsFile));

            dummyJar = fullfile(tmpDir, "TestDriver.jar");
            fid = fopen(dummyJar, 'w'); fwrite(fid, 'dummy'); fclose(fid);
            databricks.internal.settings.Settings.writeDatabricksSettingsFields(jarFilePath=string(dummyJar), verbose=false);

            p = databricks.JDBCConnection.getDefaultJarFilePath();
            testCase.verifyEqual(string(p), string(dummyJar));
        end

        function testvalidateDriverVersion(testCase)
            testCase.verifyTrue(databricks.JDBCConnection.validateDriverVersion("oss", matlab.utils.SemVer("3")));
            testCase.verifyTrue(databricks.JDBCConnection.validateDriverVersion("oss", matlab.utils.SemVer("3.1")));
            testCase.verifyFalse(databricks.JDBCConnection.validateDriverVersion("oss", matlab.utils.SemVer("2.1")));

            testCase.verifyTrue(databricks.JDBCConnection.validateDriverVersion("simba", matlab.utils.SemVer("2.7")));
            testCase.verifyTrue(databricks.JDBCConnection.validateDriverVersion("simba", matlab.utils.SemVer("3.8")));
            testCase.verifyFalse(databricks.JDBCConnection.validateDriverVersion("simba", matlab.utils.SemVer("2.1")));
        end

        function testgetEnableTokenCache(testCase)
            testCase.assumeFalse(testCase.JavaVersion > 8, "Filtered until #885 is fixed.");
            version = databricks.JDBCConnection.getDriverVersion();
            % Simba >= 2.7 disables token caching on non-Windows platforms
            testCase.verifyEqual(databricks.JDBCConnection.getEnableTokenCache(version, "simba"), ispc);
            testCase.verifyEqual(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("2.8"), "simba"), ispc);
            testCase.verifyEqual(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("2.7"), "simba"), ispc);
            testCase.verifyFalse(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("1"), "simba"));
            testCase.verifyTrue(databricks.JDBCConnection.getEnableTokenCache(version, "oss"));
        end

        function testgetJavaVersion(testCase)
            % Only check in older releases assume newer releases may be
            % using > 8
            if isMATLABReleaseOlderThan("R2026a")
                [numericVersion, fullVersion] = databricks.JDBCConnection.getJavaVersion();
                testCase.verifyEqual(numericVersion, 8);
                testCase.verifyEqual(fullVersion, "1.8.0_202");
            end
        end
    end
end