classdef testStripSlashes < matlab.unittest.TestCase
    % TESTSTRIPSLASHES Unit tests for the stripping of slashes to path
    %
    %   t = testStripSlashes;
    %   run(t);

    %  (c) 2025 MathWorks, Inc.
    properties
        FixtureDir
    end

    methods (TestClassSetup)
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testDBFS(testCase)
            path = databricks.internal.io.IO.stripTrailingSlashes("dbfs://mydir");
            testCase.verifyEqual(path, "dbfs://mydir");

            path = databricks.internal.io.IO.stripTrailingSlashes("dbfs://mydir///");
            testCase.verifyEqual(path, "dbfs://mydir");

            path = databricks.internal.io.IO.stripTrailingSlashes("dbfs://");
            testCase.verifyEqual(path, "dbfs://");

            path = databricks.internal.io.IO.stripTrailingSlashes("/dbfs/");
            testCase.verifyEqual(path, "/dbfs");

            path = databricks.internal.io.IO.stripTrailingSlashes("/dbfs");
            testCase.verifyEqual(path, "/dbfs");

            path = databricks.internal.io.IO.stripTrailingSlashes("/dbfs/a/b/c////");
            testCase.verifyEqual(path, "/dbfs/a/b/c");

            path = databricks.internal.io.IO.stripTrailingSlashes("dbfs://");
            testCase.verifyEqual(path, "dbfs://");
        end

        function testWorkspaces(testCase)
            path = databricks.internal.io.IO.stripTrailingSlashes("/Workspaces/users/joe@example.com/");
            testCase.verifyEqual(path, "/Workspaces/users/joe@example.com");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Workspaces/users/joe@example.com/////");
            testCase.verifyEqual(path, "/Workspaces/users/joe@example.com");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Workspaces/users/joe@example.com/a/b//");
            testCase.verifyEqual(path, "/Workspaces/users/joe@example.com/a/b");
        end

        function testVolumes(testCase)
            path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default/mydir///");
            testCase.verifyEqual(path, "/Volumes/main/default/mydir");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default/mydir");
            testCase.verifyEqual(path, "/Volumes/main/default/mydir");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default/");
            testCase.verifyEqual(path, "/Volumes/main/default/");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default////");
            testCase.verifyEqual(path, "/Volumes/main/default/");

            path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes");
            testCase.verifyEqual(path, "/Volumes");
        end

        function testABFSS(testCase)
            path = databricks.internal.io.IO.stripTrailingSlashes("abfss://container@account.dfs.core.windows.net/");
            testCase.verifyEqual(path, "abfss://container@account.dfs.core.windows.net/");

            path = databricks.internal.io.IO.stripTrailingSlashes("abfss://container@account.dfs.core.windows.net///");
            testCase.verifyEqual(path, "abfss://container@account.dfs.core.windows.net/");

            path = databricks.internal.io.IO.stripTrailingSlashes("abfss://container@account.dfs.core.windows.net/a/b/");
            testCase.verifyEqual(path, "abfss://container@account.dfs.core.windows.net/a/b");
        end

        function testS3(testCase)
            path = databricks.internal.io.IO.stripTrailingSlashes("s3://");
            testCase.verifyEqual(path, "s3://");

            path = databricks.internal.io.IO.stripTrailingSlashes("S3:////");
            testCase.verifyEqual(path, "S3://");

            path = databricks.internal.io.IO.stripTrailingSlashes("s3://a/b");
            testCase.verifyEqual(path, "s3://a/b");

            path = databricks.internal.io.IO.stripTrailingSlashes("s3://a/b///");
            testCase.verifyEqual(path, "s3://a/b");

            path = databricks.internal.io.IO.stripTrailingSlashes("s3a://");
            testCase.verifyEqual(path, "s3a://");

            path = databricks.internal.io.IO.stripTrailingSlashes("s3a:////");
            testCase.verifyEqual(path, "s3a://");

            path = databricks.internal.io.IO.stripTrailingSlashes("s3a://a/b");
            testCase.verifyEqual(path, "s3a://a/b");

            path = databricks.internal.io.IO.stripTrailingSlashes("S3A://a/b///");
            testCase.verifyEqual(path, "S3A://a/b");
        end
    end % methods
end % class
