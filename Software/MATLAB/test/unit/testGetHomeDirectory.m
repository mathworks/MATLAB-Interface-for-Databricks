classdef testGetHomeDirectory < matlab.unittest.TestCase
    % testGetHomeDirectory Unit tests for matlab.utils.getHomeDirectory

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testReturnsNonEmpty(testCase)
            homeDir = matlab.utils.getHomeDirectory();
            testCase.verifyNotEmpty(homeDir);
        end

        function testReturnsCharVector(testCase)
            homeDir = matlab.utils.getHomeDirectory();
            testCase.verifyClass(homeDir, 'char');
        end

        function testIsValidDirectory(testCase)
            homeDir = matlab.utils.getHomeDirectory();
            testCase.verifyTrue(isfolder(homeDir));
        end

        function testDelegatesToInternal(testCase)
            homeDir = matlab.utils.getHomeDirectory();
            internalHomeDir = matlab.internal.utils.getHomeDirectory();
            testCase.verifyEqual(homeDir, internalHomeDir);
        end
    end
end
