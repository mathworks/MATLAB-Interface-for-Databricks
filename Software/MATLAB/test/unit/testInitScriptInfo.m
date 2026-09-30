classdef testInitScriptInfo < matlab.unittest.TestCase
% TESTINITSCRIPTINFO Unit tests for the InitScriptInfo object
% Unit tests that test the object and class method for setting the
% initscriptinfo.

 
%  (c) 2019-2022 MathWorks, Inc. 

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
        function testConstruction(testCase)
            expSolution = 'databricks.InitScriptInfo';
            actSolution = class(databricks.InitScriptInfo);
            
            % Check that we have the right object.
            testCase.verifyEqual(actSolution,expSolution);
        end

        function testInvalidDestination(testCase) %#ok<MANU> 
            is = databricks.InitScriptInfo;
            try
                is.setDestination(rand(10,10));
            catch ME 
                disp('Successfully caught error:')
                disp(ME.identifier);
                disp(ME.message);
            end
            
            try
                is.setDestination();
            catch ME
                disp('Successfully caught error:')
                disp(ME.identifier);
                disp(ME.message);
            end
            
        end
        
        function testDBFSDestination(testCase)
            dest = "dbfs:/home/init_script";
            is = databricks.InitScriptInfo;
            is.setDestination(dest);
            
            % Ensure that the destination is set
            testCase.assertEqual(is.dbfs.destination, char(dest));
        end
        
        function testS3Destination(testCase)
            dest = 's3://init_script_bucket/prefix';
            region = 'us-west-2';
            is = databricks.InitScriptInfo;
            is.setDestination(dest, region);
    
            % Ensure that S3 destination and region are set
            testCase.assertEqual(is.s3.destination, dest);
            testCase.assertEqual(is.s3.region, region);
        end

        function testAbfssDestination(testCase)
            dest = 'abfss://init_container/prefix';
            is = databricks.InitScriptInfo;
            is.setDestination(dest);
    
            testCase.assertEqual(is.abfss.destination, dest);
        end

    end
end

