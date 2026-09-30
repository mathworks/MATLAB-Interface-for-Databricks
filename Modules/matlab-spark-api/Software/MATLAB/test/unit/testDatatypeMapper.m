classdef testDatatypeMapper < matlab.unittest.TestCase
    % testDatatypeMapper Unit tests for the Spark/MATLAB/Java type mapper
    
    % Copyright 2021 MathWorks, Inc.
    
    methods (Test)
        function testFromMATLAB(testCase)

            entry = matlab.sparkutils.datatypeMapper( 'matlab', 'double');
            
            testCase.assertEqual(entry.MATLABType, "double");
            testCase.assertEqual(entry.JavaType, "Double");
            testCase.assertEqual(entry.SparkType, "DoubleType");
            
        end
        
        function testFromJava(testCase)

            entry = matlab.sparkutils.datatypeMapper( 'java', 'Float');
            
            testCase.assertEqual(entry.MATLABType, "single");
            testCase.assertEqual(entry.JavaType, "Float");
            testCase.assertEqual(entry.SparkType, "FloatType");
            
        end
        
        function testFromSpark(testCase)

            entry = matlab.sparkutils.datatypeMapper( 'spark', 'StringType');
            
            testCase.assertEqual(entry.MATLABType, "string");
            testCase.assertEqual(entry.JavaType, "String");
            testCase.assertEqual(entry.SparkType, "StringType");
            
        end
    end
end

