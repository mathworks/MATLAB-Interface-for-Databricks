classdef testTasks < matlab.unittest.TestCase
    % testTasks Unit test stub for the tasks API (JOBS 2.1 API)
    %
    % This class tests different aspects of the Tasks API

    % Copyright 2021-2026 MathWorks, Inc.

    properties
        sparkJarTask
        notebookTask
    end


    methods (TestMethodSetup)
        function testSetup(testCase)
            MCRROOT = "MATLAB_Runtime";
            sparkApp = "dbfs:/example/myapp.jar";
            saveLocation = "dbfs:/some/output";
            mass = 500;
            SJT = databricks.SparkJarTask;
            SJT.Application = sparkApp;
            SJT.Arguments = [...
                MCRROOT ...
                saveLocation,...
                mass ...
                ];
            SJT.main_class_name = 'com.mathworks.mlspark.mlsubmit.MatlabSubmit';

            NT = databricks.NotebookTask();
            nbPath = '/Shared/UnitTests/Simulink_3DOFs';
            baseParams = struct('massLow', '1200', 'massHigh', '1400');
            NT.notebook_path = nbPath;
            NT.base_parameters = baseParams;

            testCase.sparkJarTask = SJT;
            testCase.notebookTask = NT;
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase)
        end
    end

    methods (Test)

        function testConstructor(testCase)
            tasks = databricks.Tasks();
            testCase.verifyClass(tasks, 'databricks.Tasks')
        end

        function testAPIVersion(testCase)
            job = databricks.Job;
            tasks = databricks.Tasks();
            jobs20 = job.getURI('jobs', 'create');
            job.setTask(tasks);
            jobs21 = job.getURI('jobs', 'create');
            testCase.verifyTrue(jobs20.EncodedURI.contains("2.0"))
            testCase.verifyFalse(jobs20.EncodedURI.contains("2.1"))
            testCase.verifyTrue(jobs21.EncodedURI.contains("2.1"))
            testCase.verifyFalse(jobs21.EncodedURI.contains("2.0"))

        end

        function testJobNewClusters(testCase)
            job = databricks.Job;
            job.name = ['test_tasks_new_clusters_',datestr(now,30)];

            cl1 = databricks.Cluster();
            cl1.setNumWorkers(2);

            tasks = databricks.Tasks;
            tasks.addTask(testCase.sparkJarTask, "my_spark_jar_task", ...
                "description", "A SparkJar task", ...
          
            
            tasks.addTask(testCase.notebookTask, "my_notebook_task", ...
                "description", "My NotebookTask", ...
                "depends_on", ["my_spark_jar_task"], ...
                "new_cluster", cl1)

            job.setTask(tasks);

            job.create()
            pause(2);
            job.remove();

        end
        
        function testLibrariesArgument(testCase)
            job = databricks.Job;
            job.name = ['test_tasks_libraries_',datestr(now,30)];

            cl1 = databricks.Cluster();
            cl1.setNumWorkers(2);

            tasks = databricks.Tasks;
            libs = {...
                struct('jar', 'file:/usr/local/MATLAB/MATLAB_Runtime/v910/toolbox/javabuilder/jar/javabuilder.jar'), ...
                struct('jar', 'dbfs:/example/SL_PumpDemo/v3_3/pumpmodel_v3_3_R2021a_Spark3.x_glnxa64.jar') ...
                };
            tasks.addTask(testCase.sparkJarTask, "my_spark_jar_task", ...
                "description", "A SparkJar task", ...
                "libraries", libs, ...
                "new_cluster", cl1);
            
            tasks.addTask(testCase.notebookTask, "my_notebook_task", ...
                "description", "My NotebookTask", ...
                "depends_on", ["my_spark_jar_task"], ...
                "new_cluster", cl1)

            job.setTask(tasks);

            job.create()
            pause(2);
            job.remove();

        end

        function testJobExistingCluster(testCase)

            % Asking the config/profile will also get environment variables if needed.
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id");
            testCase.assumeFalse(databricks.internal.cluster.isJobCluster(clusterId), 'Ignore when cluster is Job Cluster');

            job = databricks.Job;
            job.name = ['test_tasks_new_clusters_',datestr(now,30)];

            tasks = databricks.Tasks;
            tasks.addTask(testCase.sparkJarTask, "my_spark_jar_task", ...
                "description", "A SparkJar task", ...
                "existing_cluster_id", clusterId);
            tasks.addTask(testCase.notebookTask, "my_notebook_task", ...
                "description", "My NotebookTask", ...
                "depends_on", "my_spark_jar_task", ...
                "existing_cluster_id", clusterId)

            job.setTask(tasks);

            job.create()
            pause(2);
            job.remove();

        end

        function testJobNoCluster(testCase)
            job = databricks.Job;
            job.name = ['test_tasks_new_clusters_',datestr(now,30)];

            tasks = databricks.Tasks;
            tasks.addTask(testCase.sparkJarTask, "my_spark_jar_task", ...
                "description", "A SparkJar task");
            tasks.addTask(testCase.notebookTask, "my_notebook_task", ...
                "description", "My NotebookTask", ...
                "depends_on", "my_spark_jar_task")

            job.setTask(tasks);
    
            jobCreate = @() job.create();
            testCase.assertError(jobCreate, "DATABRICKS:ERROR", ...
                "job.create() should error out when no cluster is specified");

        end

        function testExtendedOptions(testCase)
            job = databricks.Job;
            job.name = ['test_tasks_new_clusters_',datestr(now,30)];

            cl1 = databricks.Cluster();
            cl1.setNumWorkers(2);

            tasks = databricks.Tasks;
            tasks.addTask(testCase.sparkJarTask, "my_spark_jar_task", ...
                "description", "A SparkJar task", ...
                "timeout_seconds", 40000, ...
                "new_cluster", cl1);
          
            tasks.addTask(testCase.notebookTask, "my_notebook_task", ...
                "description", "My NotebookTask", ...
                "depends_on", ["my_spark_jar_task"], ...
                "min_retry_interval_millis", 5000, ...
                "new_cluster", cl1)
            tasks.addTask(testCase.notebookTask, "my_notebook_task2", ...
                "description", "My NotebookTask", ...
                "depends_on", ["my_spark_jar_task"], ...
                "retry_on_timeout", true, ...
                "new_cluster", cl1)

            job.setTask(tasks);

            job.create()
            pause(2);
            job.remove();
        end
    end
end

