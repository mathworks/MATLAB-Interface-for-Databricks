classdef testNotebooks < matlab.unittest.TestCase
    % TESTNOTEBOOKS Testing notebook utilities
    
    % Copyright 2024 The MathWorks, Inc.

    properties (TestParameter)
        nbType = {'python', 'scala'}
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;

            % Create a temporary folder and make it the current working
            % folder.
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));

        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end

    methods (Test)
        function testCreation(testCase, nbType)
            locFN = "MyFile" + "." + nbType;
            testCase.assertFalse(isfile(fullfile(".", locFN)))
            NB = matlab.databricks.notebook.Notebook(filename=locFN, type=nbType);

            NB.addSectionHeader('Top of the morning to you', true);
            NB.addSectionLine('2 + 3')

            NB.addSectionHeader('And the rest of the day to you');
            NB.addSectionLine('%f * %f', pi, exp(1));
            
            testCase.assertTrue(isfile(fullfile(".", locFN)))
        end

        function testUploadNotebookPython(testCase)
            NB = matlab.databricks.notebook.Notebook(type="py");

            NB.addSectionHeader('Starting here', true)
            NB.addSectionLine("T = 2 + 3")
            NB.addSectionLine("print(f'T == {T}')")
            [~, name] = fileparts(tempname);
            wsPath = "/Shared/UnitTests/" + string(name);

            NB.importNotebookToWorkspace(wsPath);
            ws = databricks.Workspace();

            try
                stat = ws.getStatus(wsPath);
                testCase.assertEqual(string(NB.Type), string(stat.language))

                ws.delete(wsPath)
            catch EX
                testCase.assertFalse(true, "Problem getting stat of temporary notebook.")
            end
        end

        function testUploadNotebookScala(testCase)
            NB = matlab.databricks.notebook.Notebook(type="scala");

            NB.addSectionHeader('Starting here', true)
            NB.addSectionLine("val T = 2 + 3")
            NB.addSectionLine('println(s"T == ${T}")')
            [~, name] = fileparts(tempname);
            wsPath = "/Shared/UnitTests/" + string(name);

            NB.importNotebookToWorkspace(wsPath);
            ws = databricks.Workspace();

            try
                stat = ws.getStatus(wsPath);
                testCase.assertEqual(string(NB.Type), string(stat.language))

                ws.delete(wsPath)
            catch EX
                testCase.assertFalse(true, "Problem getting stat of temporary notebook.")
            end
        end
    end
end