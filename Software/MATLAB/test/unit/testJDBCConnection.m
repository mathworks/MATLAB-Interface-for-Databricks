classdef testJDBCConnection < matlab.unittest.TestCase
    % testJDBCConnection Unit tests for the JDBCConnection operations
    
    %  (c) 2024 MathWorks, Inc.

    properties(ClassSetupParameter)
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    properties
    end

    methods (Test)
        function testConstructor(testCase)
            % Default constructor
            disp('Running testConstructor');
            
            jc = databricks.JDBCConnection();
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
            p = databricks.JDBCConnection.getDefaultJarFilePath("simba");
            e = databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar");
            testCase.verifyEqual(p,e);
            testCase.verifyError(@() databricks.JDBCConnection.getDefaultJarFilePath("Simba"), 'MATLAB:validators:mustBeMember');            
            testCase.verifyError(@() databricks.JDBCConnection.getDefaultJarFilePath("INVALID"), 'MATLAB:validators:mustBeMember');

            p = databricks.JDBCConnection.getDefaultJarFilePath('simba');
            e = databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar");
            testCase.verifyEqual(p,e);

            p = databricks.JDBCConnection.getDefaultJarFilePath("oss");
            e = databricksRoot("lib", "jar", "Databricks-JDBC-OSS-Driver-0.0.1.jar");
            testCase.verifyEqual(p,e);
            testCase.verifyError(@() databricks.JDBCConnection.getDefaultJarFilePath("OSS"), 'MATLAB:validators:mustBeMember');            
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
            simbaPath = databricks.JDBCConnection.getDefaultJarFilePath('simba');
            version = databricks.JDBCConnection.getDriverVersion();
            testCase.verifyTrue(databricks.JDBCConnection.getEnableTokenCache(version, "simba", simbaPath));
            testCase.verifyTrue(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("2.8"), "simba", simbaPath));
            testCase.verifyTrue(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("2.7"), "simba", simbaPath));
            if ~ispc
                testCase.verifyFalse(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("2.7"), "simba", "InvalidPath"));
            end
            testCase.verifyFalse(databricks.JDBCConnection.getEnableTokenCache(matlab.utils.SemVer("1"), "simba", simbaPath));

            testCase.verifyTrue(databricks.JDBCConnection.getEnableTokenCache(version, "oss", simbaPath));
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