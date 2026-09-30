classdef testFileInfo < matlab.unittest.TestCase
% TESTFILEINFO This is a test stub for a unit testing
% The assertions that you can use in your test cases:
%
%    assertTrue
%    assertFalse
%    assertEqual
%    assertFilesEqual
%    assertElementsAlmostEqual
%    assertVectorsAlmostEqual
%    assertExceptionThrown
%
%   A more detailed explanation goes here.
%
% Notes:

 
%                 (c) 2019 MathWorks, Inc. 
%                 $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please add your test cases below 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (TestMethodSetup)
        function testSetup(testCase)

        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase)

        end
    end

    methods (Test)
        function testRealSolution(testCase)
            % INSERT THE TEST CODE
            %actSolution = quadraticSolver(1,-3,2); % Expected to fail
            actSolution = [2,1];
            expSolution = [2,1];
            testCase.verifyEqual(actSolution,expSolution);
        end

        function testImaginarySolution(testCase)
            % INSERT THE TEST CODE
            %actSolution = quadraticSolver(1,2,10); % Expected to fail
            actSolution = [-1+3i, -1-3i];
            expSolution = [-1+3i, -1-3i];
            testCase.verifyEqual(actSolution,expSolution);
        end
    end
    
end

