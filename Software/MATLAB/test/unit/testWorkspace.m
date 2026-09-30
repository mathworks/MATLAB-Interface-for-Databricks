classdef testWorkspace < matlab.unittest.TestCase
% TESTWORKSPACE Unit tests for the Workspace API


%                 (c) 2020 MathWorks, Inc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please add your test cases below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        jobPrefix = 'UnitTestJobPrefix';
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
        function testConstructor(testCase)
            ws = databricks.Workspace;
            % basic regex user@org.domain match
            % does not match a valid identifiers
            testCase.verifyNotEmpty(regexp(ws.username, '\w*@\w*\.\w*'));
        end
    end
end
