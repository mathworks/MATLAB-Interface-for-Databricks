function pyName = writeNotebookExample(swo)
    % writeNotebookExample Write an example to create a Notebook job

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    funcName = string(swo.CI.Name) + "_notebook_example";
    pyName = funcName + ".py";

    nb = matlab.sparkutils.NotebookWriter(pyName);

    nb.addHeader(sprintf("Example for %s", swo.WrapperName));
    nb.comment(" This notebook contains example for %s", swo.WrapperName);

    nb.addHeader("Install the wheel file")
    nb.magic('%%md');
    nb.magic("# Install the wheel file")
    nb.magic("To install the wheel file, it must be available on the cluster.")
    nb.magic("");
    nb.magic("It can be uploaded from the MATLAB session where it was created like this:")
    nb.magic("");
    nb.magic("```matlab");
    nb.magic("F = databricks.Files();")
    [fullWhl, plainWhl] = swo.getWheelFile();
    interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
    % Take away MathWorks at the end, if there

        % Remove last directory
    interfaceDirectory = regexprep(interfaceDirectory, "(.+/)[^/]+", '$1');

    uploadFolder = interfaceDirectory + "MyWheels";
    
    uploadWhl = uploadFolder + "/MATLABExamples/" + swo.Name + "/" + plainWhl;
    nb.magic("F.upload( ...");
    nb.magic("  '%s', ...", fullWhl);
    nb.magic("  '%s')", uploadWhl);
    nb.magic("```");

    nb.addHeader("Install the wheel file")
    nb.comment(' Provided the wheel has been uploaded (see previous cell), it can now be installed')
    nb.pf('%%pip install %s --force-reinstall\n', uploadWhl);

    nb.addHeader("Imports");
    nb.pf("import pandas as pd\n");
    nb.pf("from pyspark.sql.types import *\n");

    nb.addHeader("Helper functions for made up data");
    numCols = numel(swo.Inputs);
    funcNames = strings(1, numCols);
    for k=1:numCols
        funcNames(k) = swo.Inputs(k).genPythonExampleFunction(nb);
    end

    makeDFName = sprintf("%s_make_dataframe", replace(swo.PyPackageName, ".", "_"));
    nb.pf("def %s(spark, N):\n", makeDFName)
    nb.indent()
    nb.pf("DATA = list()\n");
    nb.pf("for di in range(N):\n")
    nb.indent()
    tmpStrs = strings(1, numCols);
    for nc=1:numCols
        tmpStrs(nc) = sprintf("%s(di + %d)", funcNames(nc), nc-1);
    end
    nb.pf("DATA.append((%s,))\n", tmpStrs.join(", "));
    nb.unindent();
    nb.pf("\n")
    nb.pf("# Create the schema\n")
    nb.pf("dfSchema = %s\n\n", swo.Schema.Inputs.SparkType.pythonInitCode);
    % nb.pf("dfSchema\n\n");

    nb.pf("# Create the actual Dataframe\n")
    nb.pf('DF = spark.createDataFrame(DATA, dfSchema)\n\n')

    nb.pf("return DF")
    nb.unindent();


    nb.addHeader("Generate the example data")
    nb.pf("N = 10000\n")
    nb.pf("DF = %s(spark, N)\n", makeDFName);

    % nb.pf("DATA = list()\n");
    % nb.pf("for di in range(N):\n")
    % nb.indent()
    % tmpStrs = strings(1, numCols);
    % for nc=1:numCols
    %     tmpStrs(nc) = sprintf("%s(di + %d)", funcNames(nc), nc-1);
    % end
    % nb.pf("DATA.append((%s,))\n", tmpStrs.join(", "));
    % nb.unindent();

    % nb.addHeader('Create Dataframe schema')
    % nb.pf("dfSchema = %s\n", swo.Schema.Inputs.SparkType.pythonInitCode);
    % nb.pf("dfSchema\n");

    % nb.addHeader("Create the actual Dataframe")
    % nb.pf('DF = spark.createDataFrame(DATA, dfSchema)\n')

    nb.addHeader("Show some example data");
    nb.pf("DF.show(10, False)\n");

    nb.addHeader("Run mapInPandas example")
    nb.pf("from %s import %s\n", swo.getFullPyPkgName(), swo.getPDFSimIterName());
    nb.pf('DF_OUT = DF.mapInPandas(%s, schema=%s);\n\n', swo.getPDFSimIterName(), swo.getSparkOutputSchema());

    nb.addHeader("Check results")
    nb.pf("DF_OUT.show(10, False)\n")


end