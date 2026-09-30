classdef testGetUniqueName < matlab.mock.TestCase
    % testGetUniqueName Unit tests for Job and Notebook getUniqueName methods

    % Copyright 2026 MathWorks, Inc.

    methods (Test)
        function testJobReturnsString(testCase)
            job = testCase.createJob("folder1", "Python", "myJob", "nb1", "build.m");
            uName = job.getUniqueName();
            testCase.verifyClass(uName, 'string');
            testCase.verifyTrue(strlength(uName) > 0);
        end

        function testJobDifferentPerCall(testCase)
            job = testCase.createJob("folder1", "Python", "myJob", "nb1", "build.m");
            testCase.verifyNotEqual(job.getUniqueName(), job.getUniqueName());
        end

        function testJobInfixArgument(testCase)
            job = testCase.createJob("folder1", "Python", "myJob", "nb1", "build.m");
            uNameDefault = job.getUniqueName();
            uNameInfix = job.getUniqueName("mid");
            testCase.verifyTrue(contains(uNameInfix, "_mid_"));
            testCase.verifyNotEqual(uNameDefault, uNameInfix);
        end

        function testJobEmptyNotebookName(testCase)
            job = testCase.createJob("folder1", "Python", "myJob", string.empty, "build.m");
            uName = job.getUniqueName();
            testCase.verifyClass(uName, 'string');
            testCase.verifyTrue(strlength(uName) > 0);
        end

        function testJobSuffixLength(testCase)
            job = testCase.createJob("folder1", "Python", "myJob", "nb1", "build.m");
            uName = job.getUniqueName();
            parts = split(uName, "_");
            suffix = parts(end);
            testCase.verifyEqual(strlength(suffix), 8);
        end

        function testNotebookReturnsString(testCase)
            [~, nb] = testCase.createJobWithNotebook("folder1", "Python", "myJob", "nb1", "build.m");
            uName = nb.getUniqueName();
            testCase.verifyClass(uName, 'string');
            testCase.verifyTrue(strlength(uName) > 0);
        end

        function testNotebookDifferentPerCall(testCase)
            [~, nb] = testCase.createJobWithNotebook("folder1", "Python", "myJob", "nb1", "build.m");
            testCase.verifyNotEqual(nb.getUniqueName(), nb.getUniqueName());
        end

        function testNotebookSuffixLength(testCase)
            [~, nb] = testCase.createJobWithNotebook("folder1", "Python", "myJob", "nb1", "build.m");
            uName = nb.getUniqueName();
            parts = split(uName, "_");
            suffix = parts(end);
            testCase.verifyEqual(strlength(suffix), 8);
        end
    end

    methods (Access = private)
        function job = createJob(testCase, folder, type, name, notebookName, buildScript)
            [mockJT, ~] = testCase.createMock(?databricks.internal.runjobs.JobTester);
            jobInfo.Name = name;
            jobInfo.Type = type;
            jobInfo.BuildScript = buildScript;
            if ~isempty(notebookName)
                jobInfo.NotebookName = notebookName;
            end
            job = databricks.internal.runjobs.Job(folder, jobInfo, mockJT);
        end

        function [job, nb] = createJobWithNotebook(testCase, folder, type, name, notebookName, buildScript)
            job = testCase.createJob(folder, type, name, notebookName, buildScript);
            nbPath = fullfile(tempdir, notebookName + ".m");
            fid = fopen(nbPath, 'w'); fclose(fid);
            nb = databricks.internal.runjobs.Notebook(job, nbPath);
        end
    end
end
