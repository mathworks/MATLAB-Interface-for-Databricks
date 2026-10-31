classdef testServerless < matlab.unittest.TestCase
    % testServerless
    % Some minimal tests to verify serverless connections

    %  (c) 2024 MathWorks, Inc.

    properties
        HasServerless (1,1) logical
    end
    methods (TestClassSetup)
        function testClsSetup(testCase)
            [~,Sdbc] = databricks.internal.databricksConnect.getPyDatabricksConnectVersion;
            if isempty(Sdbc) || ~isstruct(Sdbc)
                error('DATABRICKS:NO_DATABRICKS_CONNECT_PYTHON_INSTALLED', ...
                    'databricks-connect must be installed in the Python version used.')
            end
            testCase.HasServerless = Sdbc.Major == 15 && Sdbc.Minor == 1;
        end
    end
    methods (Test)
        function testConnection(testCase)
            if ~testCase.HasServerless
                fprintf("Skipping testConnection, currently only supported with DatabricksConnect 15.1\n")
                return;
            end
            fprintf("Running testConnection\n")
            spark = getDatabricksSession(serverless=true);
            testCase.assertClass(spark, 'databricks.PySparkSession');
            N = 10;
            RT = spark.range(N).table();
            testCase.assertClass(RT, 'table');
            testCase.assertEqual(height(RT), N);
            testCase.assertEqual(RT.id, int64(1:N)'-1);
        end

    end % methods

end % class
