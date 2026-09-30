classdef testClusterEnableRuntime < matlab.unittest.TestCase
    % TESTCLUSTERENABLERUNTIME Unit testing for the enableMATLABRuntime method
    %
    % Failures in the test can result in directories not being
    % cleaned up correctly on the Databricks system. Tests in this suite rely
    % on the authentication being provided.

    %  (c) 2020-2024 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
        tmpDirName = '';
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            % create a unique scope name
            ws = databricks.Workspace;
            testCase.tmpDirName = "/Users/" + string(ws.username) + "/UnitTestEnableRuntime" + matlab.lang.internal.uuid();
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase)
            ws = databricks.Workspace;
            try
                ws.getStatus(testCase.tmpDirName);
                ws.delete(testCase.tmpDirName, true);            
            catch EX
                % Doesn't exist, just ignore
            end
        end
    end

    methods (Test)

        function testLogging(testCase)
            % Create a cluster object
            cl = databricks.Cluster;
            
            % Check the property doesn't exist
            testCase.verifyFalse(isprop(cl, 'cluster_log_conf'));

            cl.setClusterLogConf('dbfs:/cluster-logs')
            testCase.verifyTrue(isprop(cl, 'cluster_log_conf'));
            
            % Check the default value was assigned
            testCase.verifyTrue(strcmp(cl.cluster_log_conf.dbfs.destination, 'dbfs:/cluster-logs'));
            
            % Set a non default directory note leading dbfs:
            cl.setClusterLogConf('dbfs:/mylogs')
            testCase.verifyTrue(strcmp(cl.cluster_log_conf.dbfs.destination, 'dbfs:/mylogs'));
        end

        function testInstall(testCase)
            % Create a cluster object
            cl = databricks.Cluster;
            % Check the property doesn't exist
            testCase.verifyFalse(isprop(cl, 'init_scripts'));
            
            % Enable the runtime install and check that the property is created
            cl.enableMATLABRuntime();
            testCase.verifyTrue(isprop(cl, 'init_scripts'));

            interfaceDirectory = char(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
            initPath = [interfaceDirectory, '/runtimes/runtime_install.sh'];
            testCase.verifyTrue(strcmp(cl.init_scripts.volumes.destination, initPath));
        end

        function testUploadWS(testCase)
            cl = databricks.Cluster;
            initPath = testCase.tmpDirName + "/" + "runtime_install.sh";

            % Create and install script and upload it, do not use the
            % default directory to avoid trampling on a production script
            cl.enableMATLABRuntime('initscriptPath', initPath);
            ws = databricks.Workspace;
            status = ws.getStatus(initPath);
            testCase.verifyTrue(isstruct(status));
            testCase.verifyTrue(isfield(status, 'path'));
            testCase.verifyEqual(string(status.path), initPath);
            testCase.verifyTrue(isfield(status, 'object_type'));
            testCase.verifyEqual(status.object_type, 'FILE');

            result = ws.export(initPath, 'SOURCE', false);
            testCase.verifyTrue(isstruct(result));
            testCase.verifyTrue(isfield(result, 'content'));
            testCase.verifyTrue(isfield(result, 'file_type'));
            testCase.verifyTrue(strcmp(result.content(1:11), '#!/bin/bash'));
        end

        function testExpectedPathError(testCase)
            cl = databricks.Cluster;
            % DBFS not supported
            initPath = "dbfs://" + "unittestdir/" + "runtime_install.sh";          
            testCase.verifyError(@() cl.enableMATLABRuntime('initscriptPath', initPath), 'DATABRICKS:ENABLEMATLABRUNTIME');
            
            initPath = "s3://" + "unittestdir/" + "runtime_install.sh";
            testCase.verifyWarning(@() cl.enableMATLABRuntime('initscriptPath', initPath), 'DATARBICKS:INITSCRIPTINFO');

            initPath = "abfss://" + "unittestdir/" + "runtime_install.sh";
            cl.enableMATLABRuntime('initscriptPath', initPath);

            initPath = "abfss://" + "unittestdir/" + "runtime_install.sh";
            cl.enableMATLABRuntime('initscriptPath', initPath);

            testCase.verifyError(@() cl.enableMATLABRuntime('initscriptPath', '/Users/username@example.com/MathWorks/runtime_install.sh'), 'DATABRICKS:ERROR')
        end
    end %method
end %classdef
