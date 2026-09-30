classdef testJDBCConnectionDocExample < matlab.unittest.TestCase
    % testJDBCConnectionDocExample Unit tests for the JDBCConnection doc example
    % Tests in this file rely on the authentication being provided in the
    % form of a .databrickscfg file in the users home directory.
    % Tests assumes a table called airlinesmall_csv in a database called
    % default. Table size is checked against sample data shipped with
    % MATLAB.

    %  (c) 2021-2026 MathWorks, Inc.

    properties(ClassSetupParameter)
        % Disable as we only have 1 jar
        % driverJars = {fullfile(databricksRoot,'lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')}
    end

    methods (TestClassSetup, ParameterCombination = 'sequential')
        % function ConfigureClassPath(testCase, driverJars)
        %     % Remove all drivers from the classpath
        %     javarmpath(testCase.driverJars{:});
        %     % Add the one we are currently testing
        %     javaaddpath(driverJars);
        % end
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
        function JDBCDocExampleTest(testCase)
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id");
            testCase.assumeFalse(databricks.internal.cluster.isJobCluster(clusterId), 'Ignore when cluster is Job Cluster');

            disp('Running testJDBCBuilderDocExample/JDBCDocExampleTest');
            javaclasspath('-dynamic')

            j = databricks.JDBCConnection();
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
