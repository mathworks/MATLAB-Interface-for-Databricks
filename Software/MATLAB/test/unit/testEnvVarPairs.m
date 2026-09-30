classdef testEnvVarPairs < matlab.unittest.TestCase
    % TESTENVVARPAIRS Unit tests for specifying environment variables
    
    %  (c) 2022 MathWorks, Inc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Test)
        function testStringConstructor(testCase)
            % Create tags using strings
            envPair = databricks.SparkEnvPair('owner','arvind');
            
            % Verifications
            testCase.verifyClass(envPair,'databricks.SparkEnvPair');
        end
        
        function testCellArrayConstructor(testCase)
            
            % Create tags using a cell array
            varsCell = {'owner','arvind';'group','engineering'};
            vars = databricks.SparkEnvPair(varsCell);

            % Verifications
            testCase.verifyClass(vars,'databricks.SparkEnvPair');
            testCase.verifyEqual(numel(vars),1);
            testCase.verifyEqual(vars.envVarPairs.Count,uint64(2));
            
        end
    end
    
end

