classdef testCodeGen < matlab.unittest.TestCase
    % testCodeGen Test code generation workflows.

    % Copyright 2024 The MathWorks, Inc.
    methods (TestMethodSetup)
        function methodSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;

            % Create a temporary folder and make it the current working
            % folder.
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));            
        end
    end
    methods (TestMethodTeardown)
        function methodTeardown(testCase) %#ok<MANU>
        end
    end
    methods (Test)
        function testCodegen(testCase)
            % TODO: Skip for now
            return

            mdl = "test_cg_1";
            origMdl = databricksRoot("test", "fixtures", mdl) + ".slx";
            copyfile(origMdl, pwd);
            try
                load_system(mdl);
                closeAfter = onCleanup(@() close_system(mdl));
                slbuild(mdl);
            catch EX
                testCase.assertTrue(false, sprintf('Couldn''t load model %s', mdl));
            end

            % If we get here, code was generated. Test it with different
            % options
            dirs = RTW.getBuildDir(mdl);
            cd(dirs.BuildDirectory);

            % Test MATLAB version
            try
                N = 1000;
                T_OUT = test_cg_1_matlab_example(N);
                testCase.verifyEqual(height(T_OUT), N);
                names = string(T_OUT.Properties.VariableNames);
                expected = ["AO", "BO", "CO"];
                testCase.verifyEqual(names, expected);
            catch EX
                testCase.assertTrue(false, "Troubles testing shared object from within MATLAB.");
            end

            % Test Python version
            try
                cmdStr = sprintf("python %s_python_example.py", mdl);
                [res, output] = system(cmdStr);
                output = string(output);
                testCase.verifyEqual(res, 0);
                testCase.verifyTrue(output.contains("pdf_in"));
                testCase.verifyTrue(output.contains("pdf_out"));
            catch EX
                testCase.assertTrue(false, "Troubles testing shared object from within Python.");
            end


            % % Test Databricks version
            % try
            %     N = 1000;
            %     srcFile = "../" + mdl + ".so";
            %     uploadDir = "/Volumes/main/default/myvolume/MyWheels/DLLs";
            %     uploadFile = uploadDir + "/" + mdl + ".so";
            %     F = databricks.Files();
            %     F.upload(srcFile, uploadFile);
            %     T_OUT = test_cg_1_spark_example(serverless=false);
            %     testCase.verifyEqual(height(T_OUT), N);
            %     names = string(T_OUT.Properties.VariableNames);
            %     expected = ["AO", "BO", "CO"];
            %     testCase.verifyEqual(names, expected);
            % catch EX
            %     testCase.assertTrue(false, "Troubles testing shared object from within Databricks.");
            % end

        end
    end

end

