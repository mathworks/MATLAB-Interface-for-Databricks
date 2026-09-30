classdef testLibrary < matlab.unittest.TestCase
    % TESTLIBRARY Unit tests for the databricks.Libary
    
    
    %                 (c) 2019 MathWorks, Inc.
    %                 $Id$
   
    % Cluster to use for the tests
    properties
        % clusterId = '0000-000000-demo000';
        % Asking the config/profile will also get environment variables if needed.
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id")
        
        % library = 'dbfs:/test/test.jar';
        libSource = databricksRoot("test", "fixtures", "simple.whl")
        library = '/Volumes/main/default/myvolume/UnitTestFilesFixtureDir/simple.whl';
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        % Create the library
        function testConstructor(testCase)
            lib = databricks.Library;
            testCase.verifyClass(lib,'databricks.Library');
        end
        
        % Set the type
        function testGetSetType(testCase)
            validOptions = {'jar','egg','whl','pypi','maven','cran'};
            for option = validOptions
                lib = databricks.Library;
                
                % Verify that the obj comes up as type
                testCase.verifyEmpty(lib.getType);
                
                % Set the type
                lib.setType(option{1});
                
                % Check that what we set is being set
                testCase.verifyTrue(isprop(lib,option{1}));
                
                % Check if the property is being setup correctly
                testCase.verifyTrue(isprop(lib,option{1}));
            end
        end
        
        % Install the library
        function testInstall(testCase)
            
            % Create a library
            lib = databricks.Library;
            lib.setType('whl');
            lib.whl = testCase.library;
            
            % First upload the file:
            % Verify it was actually created
            io = databricks.internal.io.IO();
            io.upload(testCase.libSource, testCase.library);

            testCase.verifyTrue(io.isfile(testCase.library));

            % Specify the cluster and call the method 
            try 
                lib.install(testCase.clusterId);
            catch ME
                testCase.verifyTrue(false);
            end
        end
        
        % Install the library
        function testUninstall(testCase)
            
            % Create a library
            lib = databricks.Library;
            lib.setType('jar');
            lib.jar = testCase.library;
            
            % Specify the cluster and call the method 
            lib.uninstall(testCase.clusterId);
            
        end
        
        % Check the library status
        function testClusterStatus(testCase)
            lib = databricks.Library;
            lib.getClusterStatus(testCase.clusterId);
        end
        
    end
    
end

