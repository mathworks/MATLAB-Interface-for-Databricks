function fullOutName = generateArtifactsExample(file, examplesFolder)
    % generateArtifactsExample Generate example on using artifact from within MATLAB

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
        examplesFolder (1,1) string
    end

    fullOutName = iApplyInPandasExample(file, examplesFolder);

end

function fullOutName = iApplyInPandasExample(file, examplesFolder)
    outFuncName = file.funcName + "_applyInPandas_example";
    outFileName = outFuncName + ".m";
    fullOutName = fullfile(examplesFolder, outFileName);
    PSB = file.Parent;

    SW = matlab.sparkutils.StringWriter(fullOutName);

    iGenHeader(SW, outFuncName);

    iGenArgs(SW);

    iGetSpark(SW);

    iAddArtifact(SW, PSB);

    iCreateSampleData(SW, file);

    % Here, we have some default data in DF. Verify what examples can run
    % them.
    SW.pf("%% ----------- applyInPandas -----------\n")
    SW.pf("%% This operation is run on grouped data.\n")
    SW.pf("%% In preparation, a few things must be done:\n\n")
    SW.pf("%% Import the function and its output schema\n");
    SW.pf("%% The package must be at our path while we do this.\n");

    argNames = file.getInputNames(table=file.TableInterface,individual=~file.TableInterface);

    SW.pf("oldPwd = cd('%s');\n", PSB.OutputDir);
    SW.pf("pyrun(""from %s.wrapper import %s, %s"")\n\n", ...
        PSB.PkgName, file.API.applyInPandas, file.API.outputSchema);
    SW.pf("cd(oldPwd);\n\n");
    groupByArgName = chooseGroupbyColumn(file);
    groupFunc = file.API.applyInPandas;
    if file.ScopedTables
        % additional arguments must be created for the scoping
        extraArgs = file.getInputElements(table=false, individual=true, useData=true);
        extraNames = file.getInputNames(table=false, individual=true);
        extraArgNames = "arg_" + extraNames;
        extraArgValues = string.empty;
        for k=1:numel(extraArgs)
            extraArgValues = [extraArgValues, extraArgs(k).instantiateMATLABExampleValue(k*10)]; %#ok<AGROW>
            SW.pf("%s = %s;\n", extraArgNames(k), extraArgValues(k));
        end
    end
    SW.pf("OUT = DF.groupBy(""%s"").applyInPandas( ...\n", groupByArgName);
    SW.indent();
    SW.pf("""%s"", ...\n", groupFunc);
    if file.ScopedTables
        SW.pf("schema=""%s"", ...\n", file.API.outputSchema);
        SW.pf("args={%s});\n", join(extraArgNames, ", "));
    else
        SW.pf("schema=""%s"");\n", file.API.outputSchema);
    end
    SW.unindent();
    SW.pf("\n\n")

    SW.pf("%% Show some results\n");
    SW.pf("OUT.show(10, false)\n\n")

    % SW.pf("""%s"", schema=""%s"");\n", groupFunc,  file.API.outputSchema);
    SW.pf("if options.compareResults\n");
    SW.indent();
    SW.pf("fprintf('Comparing the results from Spark/Databricks with MATLAB\\n');\n");
    SW.pf("fprintf('Convert the source dataframe to a MATLAB table\\n');\n");
    SW.pf("DF_T = DF.table;\n");
    SW.pf("fprintf('Run the algorithm in MATLAB\\n');\n");
    if file.TableInterface
        if file.ScopedTables
            SW.pf("MATLAB_T = %s(DF_T, %s);\n", file.funcName, join(extraArgNames, ", "));
        else
            SW.pf("MATLAB_T = %s(DF_T);\n", file.funcName);
        end
    else
        SW.pf("numRows = height(DF_T);\n");
        inArgs = file.getInputElements(useData=true);
        inNames = file.getInputNames();
        inArgElems = string.empty;
        for k=1:numel(inArgs)
            if inArgs(k).isScalarData
                inArgElems(k) = sprintf("DF_T.%s(row)", inNames(k));
            else
                inArgElems(k) = sprintf("DF_T.%s{row}", inNames(k));
            end
        end
        inArgsStr = join(inArgElems, ", ");
        outArgs = file.getOutputElements(useData=true);
        outNames = file.getOutputNames();
        outArgsAssign = string.empty;
        for k=1:numel(outArgs)
            if outArgs(k).isScalarData
                SW.pf("%s = zeros(numRows, 1, '%s');\n", outNames(k), outArgs(k).MATLABType);
                outArgsAssign = outNames(k) + "(row)";
            else
                SW.pf("%s = cell(numRows, 1);\n", outNames(k));
                outArgsAssign = outNames(k) + "{row}";
            end
        end
        outArgsStr = "[" + join(outArgsAssign, ", ") + "]";
        SW.pf("for row = 1:numRows\n");
        SW.indent();
        SW.pf("%s = %s(%s);\n", outArgsStr, file.funcName, inArgsStr);
        SW.unindent();
        SW.pf("end\n")
        SW.pf("MATLAB_T = table(%s);\n", join(outNames, ", "));
    end
    outNames = file.getOutputNames();
    SW.pf("fprintf('Convert the result dataframe to a MATLAB table, and sort it\\n');\n");
    SW.pf("OUT_T = OUT.table;\n");
    SW.pf("try\n");
    SW.indent();
    SW.pf("OUT_T = sortrows(OUT_T, '%s');\n", outNames(1));
    SW.pf("fprintf('MATLAB == Spark -- %%s\\n', string(isequal(MATLAB_T, OUT_T)));\n");
    SW.unindent();
    SW.pf("catch ME\n");
    SW.indent();
    SW.pf("warning('There were problems sorting the table. This can be the case, if the first column is a cell array.')\n");
    SW.unindent();
    SW.pf("end\n");

    SW.unindent();

    SW.pf("end\n\n");


    SW.unindent();
    SW.pf("\n\n");

    iGenFooter(SW, outFileName);
end

function iGenHeader(SW, outFuncName)
    SW.pf("function OUT = %s(options)\n", outFuncName);
    SW.indent();
    SW.pf("%% %s Simple function for testing\n\n", outFuncName);
end

function iGenFooter(SW, outFileName)
    SW.unindent();
    SW.pf("end %% [EOF] %s\n\n", outFileName);
end

function iGenArgs(SW)
    SW.pf("arguments\n");
    SW.indent();
    SW.pf("options.N (1,1) double = 1000 %% Number of rows\n")
    SW.pf("options.spark (1,1) matlab.pyspark.sql.session.SparkSession\n")
    SW.pf("options.addArtifact (1,1) logical = true\n")
    SW.pf("options.compareResults (1,1) logical = false\n")
    SW.unindent();
    SW.pf("end\n\n");
end

function iGetSpark(SW)
    % SW.pf('here = fileparts(mfilename("fullpath"));\n')
    % SW.pf('oneUp = fileparts(here);\n\n')
    SW.pf("%% Get Spark Session if none was provided.\n");
    SW.pf("if isfield(options, 'spark')\n")
    SW.indent();
    SW.pf("spark = options.spark;\n");
    SW.unindent();
    SW.pf("else\n")
    SW.indent();
    SW.pf("spark = getDatabricksSession();\n")
    SW.unindent();
    SW.pf("end\n\n")
end


function iAddArtifact(SW, PSB)
    SW.pf("if options.addArtifact\n")
    SW.indent();
    SW.pf("%% Attach the compiler output to the Spark session\n");
    SW.pf("spark.addArtifact(""%s"", pyfile=true);\n", PSB.ZipArtifactName);
    SW.unindent();
    SW.pf("end\n\n")
end

function iCreateSampleData(SW, file)
    SW.pf("%% Create some sample data\n");
    SW.pf("R = spark.range(options.N);\n");

    % TODO: At the moment, let's assume we're dealing with a table function
    args = file.getInputElements(table=file.TableInterface,individual=~file.TableInterface, useData=true);
    argNames = file.getInputNames(table=file.TableInterface,individual=~file.TableInterface);
    numArgs= numel(args);
    argNamesList = join("'" + argNames + "'", ", ");

    SW.pf("DF = R ...\n");
    SW.indent();
    srcCol = "R.col(""id"")";
    for k=1:numArgs
        colValue = args(k).instantiateColExampleData(srcCol);
        SW.pf('.withColumn("%s", %s) ...\n', argNames(k), colValue);
    end

    SW.pf('.select(%s);\n\n', argNamesList);
    SW.unindent();
end

