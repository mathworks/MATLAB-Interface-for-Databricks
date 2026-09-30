classdef testCurrentUser < matlab.unittest.TestCase
    % testCurrentUser Unit tests for databricks.CurrentUSer
    
    % (c) 2025 MathWorks, Inc.
       
    % Cluster to use for the tests
    properties
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
            u = databricks.CurrentUser;
            testCase.verifyClass(u,'databricks.CurrentUser');
        end
        
        % Set the type
        function testGetCurrentUserInfo(testCase)
            u = databricks.CurrentUser;
            [userInfo, errorResponse] = u.getCurrentUserInfo();

            testCase.verifyClass(userInfo,'databricks.datastructures.currentuser.UserInfo');
            testCase.verifyClass(errorResponse,'databricks.datastructures.currentuser.ErrorResponse');

            testCase.verifyEmpty(errorResponse);

            testCase.verifyClass(userInfo.userName,'string');
            testCase.verifyNotEmpty(userInfo.userName);
            testCase.verifyTrue(endsWith(userInfo.userName, "@mathworks.com"));
            testCase.verifyTrue(isscalar(userInfo.userName));

            testCase.verifyTrue(userInfo.active);
            testCase.verifyTrue(isscalar(userInfo.active));

            testCase.verifyClass(userInfo.id,'string');
            testCase.verifyTrue(isscalar(userInfo.id));
        end
    end
end

