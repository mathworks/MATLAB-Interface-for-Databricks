classdef testToken < matlab.unittest.TestCase
    % TESTTOKEN Unit test stub for the token API
    % Contains unit tests for testing the token API
    %
    %   t = testToken;
    %   run(t);
    %
    % This unit test creates and revokes tokens on the databricks system using
    % their REST API. Failures in the test can result in tokens not being
    % cleaned up correctly on the databricks system. Tests in this suite rely
    % on the authentication being provided.
    
    %  (c) 2019-2024 MathWorks, Inc.
    
    properties
        interfaceHandle;
    end
    
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            % databricks token interface
            testCase.interfaceHandle = databricks.Token();
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    methods (Test)
        function testListTokens(testCase)
            
            % List all tokens
            t = databricks.Token();
            tokens = t.list();
            tokensTable = table(tokens);
            
            % Verify that we see tokens
            testCase.verifyInstanceOf(t, 'databricks.Token');
            testCase.verifyInstanceOf(tokens, 'databricks.Token');
            testCase.verifyInstanceOf(tokensTable, 'table');
        end
        
        function testCreateRevokeToken(testCase)
            % Created the interface handle
            tokenInterface = testCase.interfaceHandle;
            
            % Create a token
            testComment = ['Testing Token ', char(datetime("now"))];
            testDuration = 100;
            tokenInterface.create(testDuration, testComment);
            
            % Check that we have a valid token
            testCase.verifyNotEmpty(tokenInterface.token_value);
            testCase.verifyNotEmpty(tokenInterface.token_info);
            testCase.verifyNotEmpty(tokenInterface.token_info.token_id);
            
            % Check that we have the correct expiry time for the token
            creationTime = tokenInterface.token_info.creation_time;
            expiryTime = creationTime; % Compute this
            expiryTime.Second = expiryTime.Second+testDuration;
            
            % Computed vs actual
            testCase.verifyMatches(char(tokenInterface.token_info.expiry_time), char(expiryTime));
            
            % Revoke the earlier created token
            tokenInterface.revoke();
            testCase.verifyEmpty(tokenInterface.token_value);
            testCase.verifyEmpty(tokenInterface.token_info);          
        end
    end
end

