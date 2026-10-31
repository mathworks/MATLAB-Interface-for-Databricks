classdef testJDBCConnectionDocExample < matlab.unittest.TestCase
    % testJDBCConnectionDocExample Unit tests for the JDBCConnection doc example
    % Tests in this file rely on the authentication being provided in the
    % form of a .databrickscfg file in the users home directory.
    % Tests assumes a table called airlinesmall_csv in a database called
    % default. Table size is checked against sample data shipped with
    % MATLAB.

    % Copyright 2021-2026 The MathWorks, Inc.

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    properties(Constant)
        JavaVersion = databricks.JDBCConnectionImpl.getJavaVersion()
    end

    methods (Test)
        function JDBCDocExampleTest(testCase)
            testCase.assumeFalse(testCase.JavaVersion > 8, "Filtered until #885 is fixed.");
            
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id");
            testCase.assumeFalse(databricks.internal.cluster.isJobCluster(clusterId), 'Ignore when cluster is Job Cluster');

            disp('Running testJDBCBuilderDocExample/JDBCDocExampleTest');
            javaclasspath('-dynamic')

            j = databricks.JDBCConnection('jarFilePath', databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar"));
            testCase.verifyNotEmpty(j.Connection);
            testCase.verifyTrue(strcmp(j.Connection.DataSource, 'default'));

            conn = j.Connection;
            testCase.verifyClass(conn, 'database.jdbc.connection');

            % Just read the first 100 rows
            data = sqlread(conn, 'samples.nyctaxi.trips', 'MaxRows', 100);
            testCase.verifyTrue(istable(data));

            [nrows, ncols] = size(data);
            testCase.verifyEqual(nrows, 100);
            testCase.verifyEqual(ncols, 6);

            % clean up
            j.Connection.close;

        end

    end % methods

end % class
