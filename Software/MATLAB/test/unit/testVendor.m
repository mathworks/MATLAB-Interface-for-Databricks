classdef testVendor < matlab.unittest.TestCase
    % testVendor Unit tests for the Vendor enumeration

    % Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testEnumMembers(testCase)
            testCase.verifyClass(matlab.databricks.vendor.Vendor.AWS, 'matlab.databricks.vendor.Vendor');
            testCase.verifyClass(matlab.databricks.vendor.Vendor.AZURE, 'matlab.databricks.vendor.Vendor');
        end

        function testEnumEquality(testCase)
            testCase.verifyEqual(matlab.databricks.vendor.Vendor.AWS, matlab.databricks.vendor.Vendor.AWS);
            testCase.verifyNotEqual(matlab.databricks.vendor.Vendor.AWS, matlab.databricks.vendor.Vendor.AZURE);
        end

        function testInternalImpl(testCase)
            aws = matlab.databricks.vendor.Vendor.AWS;
            testCase.verifyEqual(aws.vendorImpl, matlab.internal.databricks.vendor.Vendor.AWS);

            azure = matlab.databricks.vendor.Vendor.AZURE;
            testCase.verifyEqual(azure.vendorImpl, matlab.internal.databricks.vendor.Vendor.AZURE);
        end
    end
end
