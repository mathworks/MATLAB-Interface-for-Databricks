classdef testSparkJDBCBinary < matlab.unittest.TestCase
    % TESTSPARKJDBCBINARY This is a test stub for a unit testing

    %   (c) 2020-2021 MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>

        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testReadJDBC(testCase) %#ok<MANU>
            disp('Running testSparkJDBCBinary/testReadJDBC');
            % Disable this test by default
            % It requires temporal database resources on the cloud and will
            % fail if run by itself
            if isempty(getenv("GITLAB_CI"))
                disp('Not in GITLAB, disabling test, requires credentials');
            else
                disp('Test disabled temporarily'); % TODO
                if 0
                % Imports
                import java.util.Properties; %#ok<SIMPT,UNRCH>

                % Create properties for the connection
                connectionProperties = Properties();

                % Derived from CI vars test database with no value
                connectionProperties.put("user", getenv("MYSQL_USER"));
                connectionProperties.put("password", getenv("MYSQL_PASSWORD"));


                % This will create a singleton SparkSession using the getOrCreate() method
                spark = getDatabricksSession();

                % Create the Dataset object
                df = spark.read.jdbc(['jdbc:mysql://', char(getenv("MYSQL_SERVER")), '/test_database?useSSL=true&requireSSL=false'],...
                    'test_binary', connectionProperties);

                % Marshal to a table
                mlTable = table(df);

                % Verify the binary types
                testCase.verifyClass(mlTable.val{1},'int8');
                testCase.verifySize(mlTable.val{1},[1, 3412]);
                end
            end
        end
    end

end
