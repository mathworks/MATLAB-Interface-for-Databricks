classdef testClusterTag < matlab.unittest.TestCase
    % TESTCLUSTERTAG Unit tests for specifying tags
    
    
    %  (c) 2019-2021 MathWorks, Inc.
 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    methods (Test)
        function testStringConstructor(testCase)
            % Create tags using strings
            tags = databricks.ClusterTag('owner','arvind');
            
            % Verifications
            testCase.verifyClass(tags,'databricks.ClusterTag');
        end
        
        function testCellArrayConstructor(testCase)
            
            % Create tags using a cell array
            tagCell = {'owner','arvind';'group','engineering'};
            tags = databricks.ClusterTag(tagCell);

            % Verifications
            testCase.verifyClass(tags,'databricks.ClusterTag');
            testCase.verifyEqual(numel(tags),1);
            testCase.verifyEqual(tags.tags.Count,uint64(2));
            
        end
    end
    
end

