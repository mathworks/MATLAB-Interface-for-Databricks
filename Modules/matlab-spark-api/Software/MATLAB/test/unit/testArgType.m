classdef testArgType < matlab.unittest.TestCase
    % testArgTypeInfo Unit tests for the ArgTypeInfo class
    
    % Copyright 2021 MathWorks, Inc.
    
    properties (TestParameter)
       Type = {"double", "single", "int32", "string", "int64"}; 
       Size = {[1, 1], [1, 5], [1, inf], [2, 3]};
    end
    
    methods (Test)
      
        function testTypeArg(testCase, Type)
            A = compiler.build.spark.types.ArgType.instantiate(Type);
            testCase.assertEqual(A.MATLABType, Type);
            
            sz = [1,1];
            testCase.assertTrue(all(A.Size==sz));
            
        end
        
        function testTypeAndSizeArg(testCase, Type, Size)

            A = compiler.build.spark.types.ArgType.instantiate(Type, Size);
            testCase.assertEqual(A.MATLABType, Type);
            
            testCase.assertTrue(all(A.Size==Size));
            
        end
        
    end
end

