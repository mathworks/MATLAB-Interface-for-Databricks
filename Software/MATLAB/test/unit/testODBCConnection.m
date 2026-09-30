classdef testODBCConnection < matlab.unittest.TestCase
    % testODBCConnection Unit tests for the ODBCConnection operations
    
    %  (c) 2024 MathWorks, Inc.

    properties(ClassSetupParameter)
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    properties
    end

    methods (Test)
        function testConstructor(testCase)
            % Default constructor
            
            % For the moment, this is not run in the CI/CD pipeline
            if ~isempty(getenv("GITLAB_CI")) || databricks.internal.isOnDatabricks()
                fprintf("Skipping ODBC test (on gitlab or on a Databricks cluster)\n");
                return;
            end

            disp('Running testConstructor');
            
            oc = databricks.ODBCConnection();
            testCase.verifyInstanceOf(oc, 'databricks.ODBCConnection');

            testCase.verifyClass(oc.Connection, 'database.odbc.connection');
            testCase.verifyClass(oc.dsnless, 'string');
            oc.close();
        end
    end
end