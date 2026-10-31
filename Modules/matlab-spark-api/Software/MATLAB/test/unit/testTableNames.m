classdef testTableNames < matlab.unittest.TestCase
    % testTableNames Test table names (for columns)

    % Copyright 2025-2025 MathWorks, Inc.

    properties
        DataFrame;
        sparkSession;
        DF_DateTime;
    end

    methods (TestClassSetup)
        function testSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;
            import matlab.unittest.fixtures.PathFixture
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(getSparkApiRoot("test", "fixtures")));
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testTableColumns(testCase)
            T = getTableWithStrangeNames();
            SW = matlab.sparkutils.StringWriter("foo.m");
            SW.pf("function TO = foo(TI)\n");
            SW.indent();
            SW.pf("TO = TI;\n");
            SW.unindent();
            SW.pf("end\n\n");

            generateFunctionSchema("foo", {T});

            schemaFileName = "foo.schema";
            raw = jsondecode(fileread(schemaFileName));
            % This needs to be reset to ensure relocatability of files
            % raw.fullFilename = FIS.FullFileName;
            compilerType = compiler.build.spark.schema.mathworks.CommonBase.load(raw);

            SI = compilerType.Inputs(1).SparkType;
            DI = compiler.build.spark.data.fromSchema(SI);
            if strlength(DI.Name)==0
                DI.Name = compilerType.Inputs(1).Name;
            end

            colNames = colName([DI.fields.dataType]);
            expectedColNames = ["C_TI_F1_id_", "C_TI_F2_VehicleSpeed_afdc4da8", "C_TI_F3__Other_Name__5c2745c7"];
            testCase.verifyEqual(colNames, expectedColNames);

        end


    end
end

