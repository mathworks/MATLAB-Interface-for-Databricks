classdef testClusterSingleNode < matlab.unittest.TestCase
    % TESTCLUSTERSINGLENODE Unit testing for the cluster API
    % Contains unit tests for testing the Cluster API
    %
    % This unit test creates and revokes cluster(s) on the Databricks system using
    % their REST API. Failures in the test can result in cluster not being
    % cleaned up correctly on the Databricks system. Tests in this suite rely
    % on the authentication being provided.
    
    %  (c) 2020-2021 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        clusterId = getenv('DATABRICKS_CLUSTER_ID');
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            % Loop and permanentDelete each cluster whose name starts with Test
            cl = databricks.Cluster.list();
            for cCount = 1:numel(cl)
                % Check if name starts with MWUnitTestCluster
                if strncmpi(cl(cCount).cluster_name,'MWUnitTestCluster',17)
                    % Terminate it
                    cl(cCount).permanentDelete();
                end
            end
        end
    end

    methods (Test)
        function testClusterCreateSingleNode(testCase)
            % Create a cluster object
            cl = databricks.Cluster;

            % Configure it
            clName = ['MWUnitTestClusterCreateSingleNode', datestr(now)];
            cl.cluster_name = clName;
            
            % Configure a tag to denote a single node cluster
            tagSingleNode = {'ResourceClass','SingleNode'};
            tags = databricks.ClusterTag(tagSingleNode);
            cl.setCustomTags(tags);

            % Configure a SparkConfPair to denote a single node cluster
            scpSingleNode = {'spark.master','local[*,4]';'spark.databricks.cluster.profile','singleNode'};
            scps = databricks.SparkConfPair(scpSingleNode);
            cl.setSparkConf(scps);

            % No workers just a driver
            cl.setNumWorkers(0);

            % Create a cluster
            cl.create();

            % Check the cluster can be found
            cl2 = databricks.Cluster.findByName(clName);
            testCase.verifyEqual(cl2.cluster_name, clName);

            % Loop and permanentDelete each cluster whose name starts with Test
            cl3 = databricks.Cluster.list();
            for cCount = 1:numel(cl3)
                % Check if name starts with MWUnitTestCluster
                if strncmpi(cl3(cCount).cluster_name,'MWUnitTestCluster',17)
                    % Terminate it
                    cl3(cCount).permanentDelete();
                end
            end
        end


        function testClusterSetSingleNode(testCase)
            % Create a cluster object
            cl = databricks.Cluster;
    
            % Configure it
            clName = ['MWUnitTestClusterSetSingleNode', datestr(now)];
            cl.cluster_name = clName;
                
            % Configure a single node cluster
            cl.setSingleNode();
                        
            % Create a cluster
            cl.create();
    
            % Check the cluster can be found
            cl2 = databricks.Cluster.findByName(clName);
            testCase.verifyEqual(cl2.cluster_name, clName);
    
            % Loop and permanentDelete each cluster whose name starts with Test
            cl3 = databricks.Cluster.list();
            for cCount = 1:numel(cl3)
                % Check if name starts with TestCluster
                if strncmpi(cl3(cCount).cluster_name,'MWUnitTestCluster',11)
                    % Terminate it
                    cl3(cCount).permanentDelete();
                end
            end
        end
    end %method
end %classdef
