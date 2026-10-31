classdef testCluster < matlab.unittest.TestCase
    % TESTCLUSTER Unit testing for the cluster API
    % Contains unit tests for testing the Cluster API
    %
    % This unit test creates and revokes cluster on the Databricks system using
    % their REST API. Failures in the test can result in cluster not being
    % cleaned up correctly on the Databricks system. Tests in this suite rely
    % on the authentication being provided.
    %
    % The environment variable DATABRICKS_CLUSTER_ID should be defined

    %  (c) 2019-2021 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        % Asking the config/profile will also get environment variables if needed.
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id")
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
            
            cl = databricks.Cluster(); %#ok<NASGU> % Using Auth file
            
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testConstruction(testCase)
            cl1 = databricks.Cluster(); % using default auth (env vars or auth file)

            % Compare with a manually specified auth for a cluster
            cl2 = databricks.Cluster("Host", "https://some-databricks-host.databricks.com", "Token", "dapi012340123401243");

            % Assert that they are set correctly
            % testCase.assertEqual(cl1, cl2);
            % This assertion fails in the presence of dynamically set properties.
            testCase.assertEqual(cl1.node_type_id, cl2.node_type_id);
            testCase.assertEqual(cl1.spark_version, cl2.spark_version);
            testCase.assertEqual(cl1.spark_conf, cl2.spark_conf);
        end

        function testISVString(testCase)
            cl = databricks.Cluster();
            
            % Assert that they are set correctly
            testCase.assertClass(cl.spark_conf, 'containers.Map');
        end

        
        
        function testCreateCluster(testCase)
            % Create a cluster object
            cl = databricks.Cluster;

            % Configure it
            cl.cluster_name = ['TestCluster', char(datetime)];
            cl.setNumWorkers([2 10]);

            % Create a cluster
            cl.create();

            testCase.verifyEqual(cl.autoscale.min_workers,2);
            testCase.verifyEqual(cl.autoscale.max_workers,10);

            pause(2.0);

            cl.permanentDelete();
        end

        function testListClusters(testCase) %#ok<MANU>
            % List all clusters
            cl = databricks.Cluster.list(); %#ok<NASGU>
        end

        function testClusterPolicy(testCase)
            % Basic test of policy_id support
            cl = databricks.Cluster;
            policyVal = 'ABC123456789';
            policyValStr = string(policyVal);
            cl.setPolicyId(policyVal);
            testCase.verifyEqual(cl.policy_id, policyVal);
            cl.setPolicyId(policyValStr);
            testCase.verifyEqual(cl.policy_id, policyVal);
        end

        function testTerminateClusters(testCase) %#ok<MANU>
            % List all clusters
            cl = databricks.Cluster.list();

            % Loop and terminate each cluster whose name starts with Test
            for cCount = 1:numel(cl)
                clName = cl(cCount).cluster_name; %#ok<NASGU>

                % Check if name starts with TestCluster
                if strncmpi(cl(cCount).cluster_name,'TestCluster',11)
                    % Terminate it
                    cl(cCount).terminate();
                end
            end

        end % function

        function testStartTerminatedCluster(testCase) %#ok<MANU>
            % List all clusters
            cl = databricks.Cluster.list();

            % Loop and terminate each cluster whose name starts with Test
            for cCount = 1:numel(cl)
                clName = cl(cCount).cluster_name; %#ok<NASGU>

                % Check if name starts with TestCluster
                if strncmpi(cl(cCount).cluster_name,'TestCluster',11)
                    if strcmpi(cl(cCount).state,'TERMINATED')
                        % Start it
                        cl(cCount).start();
                    else
                        % Do nothing for this test
                        % TODO: Waitfor it to get to the terminated state
                        % and then start it.

                    end
                end
            end
        end

        function testRestartRunningCluster(testCase) %#ok<MANU>
            % List all clusters
            cl = databricks.Cluster.list();

            % Loop and terminate each cluster whose name starts with Test
            for cCount = 1:numel(cl)
                clName = cl(cCount).cluster_name; %#ok<NASGU>

                % Check if name starts with TestCluster
                if strncmpi(cl(cCount).cluster_name,'TestCluster',11)
                    if strcmpi(cl(cCount).state,'RUNNING')
                        % Start it
                        cl(cCount).restart();
                    else
                        % Do nothing for this test
                        % TODO: Waitfor it to get to the running state
                        % and then start it.

                    end
                end
            end
        end

        function testPermanentDelete(testCase) %#ok<MANU>
        
            fprintf('testCluster/testPermanentDelete\n');
            % List all clusters
            cl = databricks.Cluster.list();

            % Loop and terminate each cluster whose name starts with Test
            for cCount = 1:numel(cl)
                clName = cl(cCount).cluster_name;
                fprintf('Checking if we should delete %s\n', clName)
                % Check if name starts with TestCluster
                if strncmpi(cl(cCount).cluster_name,'TestCluster',11)
                    % Terminate it permanently
                    fprintf('Deleting %s (%s)\n', clName, cl(cCount).cluster_id)
                    cl(cCount).permanentDelete();
                end
            end
        end

        function testInitScript(testCase)

            % Start a new cluster
            cl = databricks.Cluster;

            testCase.assumeTrue(cl.getClusterVersionSemVer().lt(17), ...
                'Init scripts are not supported on runtime 17 and later.')
            
            cl.enableMATLABRuntime();

            cl.setDataSecurityMode(databricks.datastructures.DataSecurityMode.SINGLE_USER);

            % Configure it
            cl.cluster_name = ['TestCluster', char(datetime)];
            cl.setNumWorkers([2 10]);
            %cl.setInitScriptInfo(is);

            % Create a cluster
            cl.create();
            deleteAfter = onCleanup(@() cl.permanentDelete());
            pause(2);
            cl.refresh();
            testCase.verifyEqual('PENDING', cl.state);
            testCase.verifyTrue(isprop(cl, 'init_scripts'), ...
                'init_scripts should be a property');
            % DBFS no longer the default to be removed in the future
            %testCase.verifyTrue(isfield(cl.init_scripts, 'dbfs'), ...
            %    'init_scripts should have a dbfs field');
            %testCase.verifyTrue(isfield(cl.init_scripts.dbfs, 'destination'), ...
            %    'init_scripts should have a dbfs field with a destination field');
            %testCase.verifyNotEmpty(cl.init_scripts.dbfs.destination, ...
            %    'destination field in init_scripts should not be empty');

            testCase.verifyTrue(isfield(cl.init_scripts, 'volumes'), ...
                'init_scripts should have a volumes field');
            testCase.verifyTrue(isfield(cl.init_scripts.volumes, 'destination'), ...
                'init_scripts should have a volumes field with a destination field');
            testCase.verifyNotEmpty(cl.init_scripts.volumes.destination, ...
                'destination field in init_scripts should not be empty');

        end

        function testLogConf(testCase) %#ok<MANU>

            % Start a new cluster
            cl = databricks.Cluster;

            % Specify a cluster log location
            cli = databricks.ClusterLogConf;
            cli.setDestination('dbfs:/home/cluster_logs');
            cl.setClusterLogConf(cli);

            % Configure it
            cl.setNumWorkers([2 10]);
            cl.cluster_name = ['TestCluster', char(datetime)];

            % Create a cluster
            cl.create();

            pause(2);

            cl.permanentDelete();

        end

        function testEventAPI(testCase)
            % Wait for the previous cluster to be created
            pause(15);

            % Find a cluster/ any cluster will do
            clusterList = databricks.Cluster.list();

            % Found it
            if ~isempty(clusterList)
                % Pick the first item
                cl = clusterList(1);

                % Fetch the events
                ev = cl.getEvents();

                testCase.assertNotEmpty(ev);
            end

        end

        function testEnableMATLABMethod(testCase)
            % Create a cluster and enable the installation of the MATLAB
            % runtime.
            fprintf('Testing testEnableMATLABMethod\n');
            cl = databricks.Cluster;

            testCase.assumeTrue(cl.getClusterVersionSemVer().lt(17), ...
                'Init scripts are not supported on runtime 17 and later.')

            cl.enableMATLABRuntime();

            testCase.assertTrue(isprop(cl,'init_scripts'));
            testCase.assertTrue(isprop(cl,'spark_env_vars'));

        end

        function testAddTags(testCase)
            % Create a cluster and add tags to it
            cl = databricks.Cluster;
            tags = databricks.ClusterTag('owner','arvind');
            cl.setCustomTags(tags);

            testCase.verifyEqual(cl.custom_tags, tags.tags);

        end

        function testFindByName(testCase)

            clusters = databricks.Cluster.list();
            testCase.assertNotEmpty(clusters, ...
                'No clusters were found');

            clName = clusters(1).cluster_name;

            % Find a cluster by name
            cl = databricks.Cluster.findByName(clName);
            testCase.assertNotEmpty(cl, ...
                sprintf('Cluster %s was not found', clName));

            % Handle the case when there are more than one clusters with
            % the same name
            cl = cl(1);

            testCase.verifyEqual(cl.cluster_name, clName, ...
                sprintf(['Name of cluster found is not correct\n', ...
                'Found: %s\nExpected: %s\n'], cl.cluster_name, clName));

        end


        function testFindById(testCase)

            % Find a cluster by name
            cl = databricks.Cluster.findById(testCase.clusterId);
            % cl will be empty if DATABRICKS_CLUSTER_ID is not set
            if ~isempty(cl)
                testCase.verifyEqual(string(cl.cluster_id), string(testCase.clusterId));
            end

        end

    end %method
end %classdef
