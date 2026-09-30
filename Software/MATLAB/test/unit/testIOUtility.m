classdef testIOUtility < matlab.unittest.TestCase
    % testIOUtility The the IO utility

    % Copyright MathWorks Inc. 2024-2025

    properties
        SrcFile (1,1) string = databricksRoot('startup.m')
    end


    methods (Test)
        function testWorkspace(testCase)
            baseDir = "/Shared/UnitTests";
            tmpName = string(matlab.lang.internal.uuid());
            testDir = baseDir + "/" + tmpName;
            realDir = testDir + "/real";
            fakeDir = testDir + "/fake";
            realFile = realDir + "/startup.m";
            fakeFile = fakeDir + "/startup.m";

            ws = databricks.Workspace();
            ws.mkdirs(realDir);
            deleteAfter = onCleanup(@() ws.delete(testDir, 'recursive', true));

            ws.import('path', realFile, 'format', 'AUTO', 'file', testCase.SrcFile, 'overwrite', true);

            io = databricks.internal.io.IO();

            testCase.assertTrue(io.isfile(realFile));
            testCase.assertFalse(io.isfile(fakeFile));

            testCase.assertTrue(io.isfolder(realDir));
            testCase.assertFalse(io.isfolder(fakeDir));
        end


        function testFileparts(testCase)
            [p,f,e] = databricks.internal.io.IO.fileparts("/Workspace/Users/joe@example.com/myfile.m");
            testCase.verifyEqual(p, "/Workspace/Users/joe@example.com");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".m");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Workspace/Users/joe@example.com/myfile");
            testCase.verifyEqual(p, "/Workspace/Users/joe@example.com");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, "");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Workspace/Users/joe@example.com/mydir/");
            testCase.verifyEqual(p, "/Workspace/Users/joe@example.com/mydir");
            testCase.verifyEqual(f, "");
            testCase.verifyEqual(e, "");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Workspace/Users/joe@example.com/mydir/myfile.m");
            testCase.verifyEqual(p, "/Workspace/Users/joe@example.com/mydir");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".m");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Workspace/Users/joe@example.com/mycode.m");
            testCase.verifyEqual(p, "/Workspace/Users/joe@example.com");
            testCase.verifyEqual(f, "mycode");
            testCase.verifyEqual(e, ".m");

            [p,f,e] = databricks.internal.io.IO.fileparts("dbfs://mydir");
            testCase.verifyEqual(p, "dbfs://");
            testCase.verifyEqual(f, "mydir");
            testCase.verifyEqual(e, "");

            [p,f,e] = databricks.internal.io.IO.fileparts("dbfs://myfile.txt");
            testCase.verifyEqual(p, "dbfs://");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".txt");

            [p,f,e] = databricks.internal.io.IO.fileparts("dbfs://myfile.txt");
            testCase.verifyEqual(p, "dbfs://");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".txt");
    
            [p,f,e] = databricks.internal.io.IO.fileparts("/dbfs/myfile.txt");
            testCase.verifyEqual(p, "/dbfs");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".txt");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Volumes/catalog/schema/myfile.txt");
            testCase.verifyEqual(p, "/Volumes/catalog/schema");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".txt");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Volumes/catalog/schema/mydir/myfile.txt");
            testCase.verifyEqual(p, "/Volumes/catalog/schema/mydir");
            testCase.verifyEqual(f, "myfile");
            testCase.verifyEqual(e, ".txt");

            [p,f,e] = databricks.internal.io.IO.fileparts("/Volumes/catalog/schema/mydir/myfile.m.txt");
            testCase.verifyEqual(p, "/Volumes/catalog/schema/mydir");
            testCase.verifyEqual(f, "myfile.m");
            testCase.verifyEqual(e, ".txt");
        end
    end
end
