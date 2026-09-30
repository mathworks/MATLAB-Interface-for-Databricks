classdef testAutoTerminate < matlab.unittest.TestCase
% TESTAUTOTERMINATE This test Autotermination settings

% (c) 2021 MathWorks, Inc. 

    properties
        clusterId = getenv('DATABRICKS_CLUSTER_ID');
    end
    
    methods (TestClassSetup)
        function testSetup(testCase)
            fprintf('Setup of %s, clusterId == %s\n', mfilename("class"), testCase.clusterId);
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase)
            fprintf('Teardown of %s, clusterId == %s\n', mfilename("class"), testCase.clusterId);
        end
    end

    methods (Test)
        function testDefaultConstructor(testCase)

            cl = databricks.Cluster;
            cl.setAutoterminationMinutes(0);
            
            % Test that it has autotermination set by default
            testCase.assertTrue(isprop(cl,'autotermination_minutes'));
            
            % Stomp on the autotermination to test
            cl.autotermination_minutes = 100;
            testCase.assertEqual(cl.autotermination_minutes,100);
            
            cl.autotermination_minutes = 101;
            testCase.assertEqual(cl.autotermination_minutes,101);

        end

        function testSetAutoTerminationMinutes(testCase)
            % Create a cluster and set the autotermination minutes
            cl = databricks.Cluster;
            cl.setAutoterminationMinutes(100);
            
            % Check
            testCase.verifyEqual(cl.autotermination_minutes, 100);
        end
        
        function testInvalidSetting(testCase)
            % Create a cluster
            cl = databricks.Cluster;
            
            % Set an invalid setting
            try
                cl.setAutoterminationMinutes('INVALIDSETTING');
            catch ME
                disp('Successfully caught validation error in autotermination settings');
            end
        end

    end
    
end

