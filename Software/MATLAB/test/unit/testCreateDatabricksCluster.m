classdef testCreateDatabricksCluster < matlab.unittest.TestCase
    % testCreateDatabricksCluster Unit testing for createDatabricksCluster
    %
    % This unit test creates and revokes cluster on the Databricks system using
    % their REST API. Failures in the test can result in cluster not being
    % cleaned up correctly on the Databricks system. Tests in this suite rely
    % on the authentication being provided.
    %
    % The environment variable DATABRICKS_CLUSTER_ID should be defined

    % Copyright (c) 2022-2023 MathWorks, Inc.

    properties
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU> 
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU> 
        end
    end

    methods (Test)
        function testBasic(testCase)
            name = "my_cluster";
            numWorkers = 5;
            cl = createDatabricksCluster(name, numWorkers, create=false);

            testCase.assertClass(cl, 'databricks.Cluster');
            testCase.assertEqual(name, cl.cluster_name);
            testCase.assertEqual(numWorkers, cl.num_workers);
        end

        function testSingleNode(testCase)
            name = "my_cluster";
            numWorkers = 0;
            cl = createDatabricksCluster(name, numWorkers, create=false);

            testCase.assertClass(cl, 'databricks.Cluster');
            testCase.assertEqual(name, cl.cluster_name);
            testCase.assertEqual(numWorkers, cl.num_workers);
            sparkConf = cl.spark_conf;
            profileVal = sparkConf('spark.databricks.cluster.profile');
            profileExpected = 'singleNode';
            testCase.assertEqual(profileVal, profileExpected);

        end
        
        function testSparkVersion(testCase)
            % Get all possible supported Spark Versions via Clusters API
            availableVersions = databricks.Cluster.getSparkVersions;
            availableVersions = availableVersions.key;

            % The default version a just created Cluster object should have
            defaultSparkVersion = databricks.internal.cluster.getDefaultSparkVersion('ML', false, 'GPU', false, 'photon', false);
            c = databricks.Cluster();
            % Verify that the expected default value is set and that it is
            % an available version
            testCase.verifyTrue(strcmp(c.spark_version, defaultSparkVersion));
            testCase.verifyTrue(any(contains(availableVersions, defaultSparkVersion)));

            % Pick a different version value
            otherVersions = setdiff(availableVersions, {char(defaultSparkVersion)});
            candidateVersionIdx = randi([1,numel(otherVersions)]);
            candidateVersion = string(otherVersions{candidateVersionIdx});
            % Create a cluster using it
            if startsWith(candidateVersion, "17.") || startsWith(candidateVersion, "18.") || startsWith(candidateVersion, "19.")
                testCase.verifyError(@()createDatabricksCluster('other-version', 20, create=false, sparkVersion=candidateVersion), ...
                    'DATABRICKS:CREATEDATABRICKSCLUSTER:INIT17')
            else
                cl = createDatabricksCluster('other-version', 20, create=false, sparkVersion=candidateVersion);
                % Check the new version is set in the new cluster object
                testCase.assertEqual(cl.spark_version, candidateVersion  );
                testCase.assertNotEqual(cl.spark_version, string(defaultSparkVersion));
            end
        end

        function testNodeType(testCase)
            availableNodeTypes = databricks.Cluster.getNodeTypes;
            availableNodeTypes = availableNodeTypes.node_type_id;
            settings = databricks.internal.settings.Settings.getSettingsStruct();
            vendor = lower(string(matlab.databricks.vendor.getVendor()));

            defaultNodeType = settings.(vendor).node_type_id;
            otherVersions = setdiff(availableNodeTypes, defaultNodeType);
            candidateNodeIdx = randi([1,numel(otherVersions)]);
            candidateNode = string(otherVersions{candidateNodeIdx});

            cl = createDatabricksCluster('other-version', 20, create=false, nodeTypeId=candidateNode);

            testCase.assertEqual(cl.node_type_id, candidateNode);
            testCase.assertNotEqual(cl.spark_version, string(defaultNodeType));
        end

        function testDockerImage(testCase)
            img = "repo.azurecr.io/mathworks/databricks:9.12-10.4";
            username = "mupp";
            password = "kermit";

            cl = createDatabricksCluster('using-docker', 2, ...
                create=false, sparkVersion="16.4.x-scala2.12",...
                dockerURL=img, dockerUsername=username, dockerPassword=password);

            testCase.assertNotEmpty(cl.docker_image)
            testCase.assertEqual(cl.docker_image.url, img);
            testCase.assertEqual(cl.docker_image.basic_auth.username, username);
            testCase.assertEqual(cl.docker_image.basic_auth.password, password);
        end

        function testBadCombo(testCase)
            testCase.verifyError(@() createDatabricksCluster('isolation1', 1, create=false, accessMode="USER_ISOLATION", initScriptPath="dbfs:/somedir/someinit.sh"),...
                'DATABRICKS:ENABLEMATLABRUNTIME');

            testCase.verifyError(@() createDatabricksCluster('isolation2', 1, create=false, accessMode="USER_ISOLATION", initScriptPath="/Users/username@example.com/MathWorks/runtime_install.sh"),...
                'DATABRICKS:ERROR');

            testCase.verifyError(@() createDatabricksCluster('isolation3', 1, create=false, accessMode="NONE"),...
                'DATABRICKS:ENABLEMATLABRUNTIME');
            
        end
    end %methods
end %classdef
