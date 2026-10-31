classdef testJob < matlab.unittest.TestCase
    % TESTJOB Unit tests for the Jobs API

    % (c) 2019-2026 MathWorks, Inc.

    properties
        jobPrefix = 'UnitTestJobPrefix';
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
        function testConstructor(testCase) %#ok<MANU>
            jh = databricks.Job; %#ok<NASGU>
        end

        function testSetCluster(testCase)
            % String based cluster_id
            jb = databricks.Job;
            jb.name = [testCase.jobPrefix, datestr(now)];
            jb.setCluster('0716-182237-eta530');

            testCase.assertTrue(isprop(jb,'existing_cluster_id'));

            % Cluster object based configuration
            cl = databricks.Cluster;
            cl.cluster_name = 'NewCluster';
            cl.setNumWorkers([2 10]);

            jb = databricks.Job;
            jb.name = 'Example';
            jb.setCluster(cl);

            testCase.assertTrue(isprop(jb,'new_cluster'));

        end

        function testJobCreationNewCluster(testCase)
            % Cluster object based configuration
            cl = databricks.Cluster;
            cl.setNumWorkers([2 10]);
            % Note: do not specify cluster name

            jb = databricks.Job;
            jb.name = [testCase.jobPrefix,datestr(now)];
            jb.setCluster(cl);
            jb.create();

            % Make sure a job_id was assigned
            testCase.assertTrue(ismember('job_id', fieldnames(jb)));

            % Remove this unused job
            jb.remove();
        end

        function testJobListing(testCase)
            % List all existing jobs
            jb = databricks.Job.list();

            % Make sure we get job objects back.
            testCase.assertClass(jb,'databricks.Job');
        end

        function testSetEmailNotification(testCase)

            % Cluster object based configuration
            cl = databricks.Cluster;
            cl.setNumWorkers([2 10]);
            % Note: do not specify cluster name

            % Create a job and configure
            jb = databricks.Job;
            jb.name = [testCase.jobPrefix,datestr(now)];
            jb.setCluster(cl);
            jb.create();

            pause(5);

            jb.remove();

        end

        function testVectorizedJobOperations(testCase)

            cl = databricks.Cluster();
            cl.setNumWorkers(4)

            % Create a few job definitions
            jobSize = 10;
            for vCount = 1:jobSize
                jb(vCount) = databricks.Job; %#ok<AGROW>
                jb(vCount).name = [testCase.jobPrefix, datestr(now)]; %#ok<AGROW>
                jb(vCount).setCluster(cl)
            end

            % Vectorized creation and deletion
            jb.create();
            % Pause shortly, to allow for lag in system
            pause(5)
            jb.remove();
        end

        function testGetJobHandle(testCase)

            % Create a job
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id");
            testCase.assumeFalse(databricks.internal.cluster.isJobCluster(clusterId), 'Ignore when cluster is Job Cluster');

            testCase.verifyNotEmpty(clusterId);
            testCase.verifyGreaterThan(strlength(clusterId), 0);
            jb = databricks.Job;
            jb.name = [testCase.jobPrefix, datestr(now)];
            jb.setCluster(clusterId);
            jb.create();

            jobId = jb.job_id;
            testCase.verifyClass(jobId, 'int64');

            % Create a new job
            jNew = databricks.Job();
            jNew.setJobId(jobId);
            jNew.refresh();
            disp(jNew);

            % Assertions
            expected = {'name',...
                'timeout_seconds',...
                'max_retries',...
                'created_time',...
                'existing_cluster_id',...
                'max_concurrent_runs',...
                'job_id',...
                'email_notifications',...
                'creator_user_name',...
                'run_as_user_name'}';
            testCase.assertEqual( ...
                numel(intersect(fieldnames(jNew), expected)), ...
                numel(expected));

            % Clean up
            jb.remove();
        end

    end
end
