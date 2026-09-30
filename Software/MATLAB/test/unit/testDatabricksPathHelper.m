classdef testDatabricksPathHelper < matlab.unittest.TestCase
    % testDatabricksPathHelper

    % Copyright 2024 The MathWorks, Inc.

    methods (Test)
        function testSlashRemovals1(testCase)

            s1 = "dbfs:///what/now";
            s2 = "/what/now/";

            dhp1 = databricks.internal.DatabricksPathHelper(s1);
            dhp1.ensureEndsWithSlash();
            testCase.assertEqual(dhp1.get(stripDBFS=true), s2);
        end

        function testSlashRemovals2(testCase)

            s1 = "/dbfs///////what/now";
            s2 = "/what/now/";

            dhp1 = databricks.internal.DatabricksPathHelper(s1);
            dhp1.ensureEndsWithSlash();
            testCase.assertEqual(dhp1.get(stripDBFS=true), s2);
        end
    end

end

