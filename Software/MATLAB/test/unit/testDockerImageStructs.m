classdef testDockerImageStructs < matlab.unittest.TestCase
    % TESTDOCKERIMAGESTRUCTS Unit tests for specifying Docker Images
        
    %  (c) 2022 MathWorks, Inc.
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Test)
        function testDockerBasicAuthConstructor(testCase)
            dbaStruct = struct;
            dbaStruct.username = "myusername";
            dbaStruct.password = "mypassword";
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
            % Verifications
            testCase.verifyClass(dba, 'databricks.datastructures.DockerBasicAuth');
            testCase.verifyEqual(dba.username, "myusername");
            testCase.verifyEqual(dba.password, "mypassword");
            
            dbaStruct = struct;
            dbaStruct.username = 'myusername';
            dbaStruct.password = 'mypassword';
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
            testCase.verifyClass(dba, 'databricks.datastructures.DockerBasicAuth');
            testCase.verifyEqual(dba.username, "myusername");
            testCase.verifyEqual(dba.password, "mypassword");
            
            dbaStruct = struct;
            dbaStruct.username = 'myusername';
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
            testCase.verifyClass(dba, 'databricks.datastructures.DockerBasicAuth');
            testCase.verifyEqual(dba.username, "myusername");
            testCase.verifyTrue(ismissing(dba.password));
            
            dbaStruct = struct;
            dbaStruct.password = "mypassword";
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
            testCase.verifyClass(dba, 'databricks.datastructures.DockerBasicAuth');
            testCase.verifyEqual(dba.password, "mypassword");
            testCase.verifyTrue(ismissing(dba.username));
        end
        
        function testDockerImageConstructor(testCase)
            dbaStruct = struct;
            dbaStruct.username = "myusername";
            dbaStruct.password = "mypassword";
            dba = databricks.datastructures.DockerBasicAuth(dbaStruct);

            diStruct.url = "http://mydockerrepourl.example.com";
            diStruct.basic_auth = dba;
            di = databricks.datastructures.DockerImage(diStruct);

            testCase.verifyClass(di, 'databricks.datastructures.DockerImage');
            testCase.verifyClass(di.basic_auth, 'databricks.datastructures.DockerBasicAuth');
            testCase.verifyEqual(di.basic_auth.password, "mypassword");
            testCase.verifyEqual(di.basic_auth.username, "myusername");
            testCase.verifyEqual(di.url, "http://mydockerrepourl.example.com");
        end

        function testSetDockerImage(testCase)
          cl = databricks.Cluster;
          cl.setDockerImage('img', 'user', 'passwd');
        
          testCase.verifyEqual(cl.docker_image.url, "img");
          testCase.verifyEqual(cl.docker_image.basic_auth.username, "user");
          testCase.verifyEqual(cl.docker_image.basic_auth.password, "passwd");

          cl = databricks.Cluster;
          dbaStruct.username = "myusername";
          dbaStruct.password = "mypassword";
          dba = databricks.datastructures.DockerBasicAuth(dbaStruct);
          diStruct.url = "http://mydockerrepourl.example.com";
          diStruct.basic_auth = dba;
    
          di = databricks.datastructures.DockerImage(diStruct);
          cl.setDockerImage(di);

          testCase.verifyEqual(cl.docker_image.url, "http://mydockerrepourl.example.com");
          testCase.verifyEqual(cl.docker_image.basic_auth.username, "myusername");
          testCase.verifyEqual(cl.docker_image.basic_auth.password, "mypassword");
        end
    end
    
end

