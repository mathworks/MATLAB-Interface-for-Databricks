classdef testCompilerWorkflow < matlab.unittest.TestCase
    % testCompilerWorkflow Unit tests for the SparkBuilder class

    % Copyright 2021-2026 MathWorks, Inc.

    properties
        DS
    end
    properties (TestParameter)
        BadFile = {"fBad_1.m", "fBad_2.m", "fBad_3.m"}
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;
            import matlab.unittest.fixtures.PathFixture;
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
            testCase.applyFixture(PathFixture(getSparkApiRoot('test', 'fixtures'), 'IncludeSubfolders', false))

        end

    end

    methods (TestClassTeardown)
        function testTearDown(testCase)
        end
    end

    methods (Test)

        function testValues_Python(testCase)
            testCase.assumeFalse(isDatabricksEnvironment, 'Ignore when on Databricks, tested in JobTester');

            opts = compiler.build.PythonPackageOptions( ...
                [getSparkApiRoot("test", "fixtures", "fValues.m"), ...
                getSparkApiRoot("test", "fixtures", "fTable.m"), ...
                getSparkApiRoot("test", "fixtures", "fTablePlus.m")], ...
                "OutputDir", "pyOut", ...
                "PackageName", "mlsparkapi.tcwpy_1");

            PSB = compiler.build.spark.PythonSparkBuilder(opts);
            PSB.Verbose = true;
            PSB.build();

        end

        function testValuesArrays_Python(testCase)
            testCase.assumeFalse(isDatabricksEnvironment, 'Ignore when on Databricks, tested in JobTester');

            opts = compiler.build.PythonPackageOptions( ...
                [...
                getSparkApiRoot("test", "fixtures", "fValues_Arrays.m"), ...
                getSparkApiRoot("test", "fixtures", "fValues_Arrays2.m"), ...
                getSparkApiRoot("test", "fixtures", "fValues_Arrays3.m"), ...
                getSparkApiRoot("test", "fixtures", "fValues_Arrays4.m"), ...
                getSparkApiRoot("test", "fixtures", "fValues_Arrays5.m"), ...
                ], ...
                "OutputDir", "pyOutArr", ...
                "PackageName", "mlsparkapi.tcwpy_2");

            PSB = compiler.build.spark.PythonSparkBuilder(opts);
            PSB.Verbose = true;
            PSB.build();

        end

        function testVarArrays_Python(testCase)
            testCase.assumeFalse(isDatabricksEnvironment, 'Ignore when on Databricks, tested in JobTester');

            opts = compiler.build.PythonPackageOptions( ...
                [...
                getSparkApiRoot("test", "fixtures", "fVarArrSize1.m"), ...
                getSparkApiRoot("test", "fixtures", "fVarArrSize2.m"), ...
                ], ...
                "OutputDir", "pyOutArr", ...
                "PackageName", "mlsparkapi.tvapy_2");

            PSB = compiler.build.spark.PythonSparkBuilder(opts);
            PSB.Verbose = true;
            PSB.build();

        end


        function testBadInterfaces_Python(testCase, BadFile)

            errID = 'MATLAB_SPARK_API:bad_table_arguments';

            opts = compiler.build.PythonPackageOptions( ...
                [getSparkApiRoot("test", "fixtures", BadFile), ...
                ], ...
                "OutputDir", "pyOut", ...
                "PackageName", "test.unit.python");

            PSB = @() compiler.build.spark.PythonSparkBuilder(opts);
            testCase.assertError(PSB, errID);

        end

    end
end
