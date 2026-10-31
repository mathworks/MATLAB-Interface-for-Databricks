function fullFileName = generatePythonNotebookTask(file, examplesFolder, pyFileName)
    % generatePythonNotebookTask Generate a notebook example

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
        examplesFolder (1,1) string
        pyFileName (1,1) string
    end

    PSB = file.Parent;

    funcName = file.funcName + "_notebook_example";
    fileName = funcName + ".m";
    fullFileName = fullfile(examplesFolder, fileName);

    SW = matlab.sparkutils.StringWriter(fullFileName);

    SW.pf("function [job, jobRun] = %s(options)\n", funcName);
    SW.indent();
    SW.pf("%% %s Example function for running an example on a cluster\n", funcName);

    SW.pf("\n");
    SW.pf("arguments\n")
    SW.indent();
    SW.pf("options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}\n");
    SW.pf("options.authMethod (1,1) matlab.databricks.AuthMethod\n");
    SW.pf("options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName\n");
    SW.pf("options.doUpload (1,1) logical = true\n");
    SW.pf("options.notebookSrc (1,1) string = ""%s""\n", pyFileName);

    interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));

    % Remove last directory
    interfaceDirectory = regexprep(interfaceDirectory, "(.+/)[^/]+", '$1');

    uploadDirectory = interfaceDirectory + "MyWheels";

    SW.pf("options.libraryDest (1,1) string = ""%s""\n", uploadDirectory);
    SW.pf("options.librarySrc (1,1) string = ""%s""\n", PSB.getWheelFile);

    SW.unindent();
    SW.pf("end\n\n");

    SW.pf("%% Auth args to use in general\n");
    SW.pf("args = matlab.utils.addArgs(options, [""authMethod"", ""profileName""]);\n\n") % Requires Databricks package
    SW.pf("%% The notebook to use:\n");
    SW.pf("[~, pyPlainName] = fileparts(options.notebookSrc);\n\n");
    SW.pf("[~, libPlainName, libExt] = fileparts(options.librarySrc);\n");
    SW.pf("libraryFullDest = options.libraryDest + ""/"" + libPlainName + libExt;\n");

    % Handle cluster settings
    SW.pf("%% Handle cluster option\n");
    SW.pf("if isfield(options, 'cluster')\n");
    SW.indent();
    SW.pf("cluster = options.cluster;\n");
    SW.pf("if isa(cluster, 'databricks.Cluster')\n");
    SW.indent();
    SW.pf("cluster = cluster.cluster_id;\n");
    SW.unindent();
    SW.pf("end\n");
    SW.pf("namePrefix = 'RunOnExistingCluster';\n");
    SW.unindent();
    SW.pf("else\n");
    SW.indent();
    SW.pf("cluster = createDatabricksCluster('', 0, 'create', false, args{:});\n");
    SW.pf("namePrefix = 'RunOnNewCluster';\n");
    SW.unindent();
    SW.pf("end\n\n");

    SW.pf("%% Handle notebook and potential upload\n");
    SW.pf("ws = databricks.Workspace(args{:});\n");
    SW.pf('baseFolder = "/Users/" + string(ws.username) + "/tmp";\n');
    SW.pf("if options.doUpload\n");
    SW.indent();
    SW.pf("if ~ws.directoryExists(baseFolder)\n");
    SW.indent();
    SW.pf("ws.mkdirs(baseFolder);\n");
    SW.unindent();
    SW.pf("end\n");
    SW.unindent();
    SW.pf("end\n");
    SW.pf("%% Upload the notebook to Databricks\n");
    SW.pf('dstFile = baseFolder + "/" + string(pyPlainName);\n');
    SW.pf("if options.doUpload\n");
    SW.indent();
    SW.pf("ws.import('path', dstFile, ...\n");
    SW.indent();
    SW.pf("'format', 'SOURCE', ...\n");
    SW.pf("'language', 'PYTHON', ...\n");
    SW.pf("'file', options.notebookSrc, ...\n");
    SW.pf("'overwrite', true);\n");
    SW.unindent();
    SW.unindent();
    SW.pf("end\n\n");

    SW.pf("%% Do library upload\n");
    SW.pf("if options.doUpload\n");
    SW.indent();
    SW.pf("io = databricks.internal.io.IO(args{:});\n");
    SW.pf("io.upload(options.librarySrc, libraryFullDest);\n")
    SW.unindent();
    SW.pf("end\n\n");


    % SW.pf("% Create the notebook with parameters\n");
    % SW.pf("params = struct('ds_limit', sprintf('%d', options.N));\n");
    SW.pf("nbTask = databricks.NotebookTask(dstFile);\n");

    SW.pf("job = databricks.Job(args{:});\n");
    SW.pf("job.name = namePrefix + ""_Notebookexample_"" + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));\n");
    SW.pf("job.setTask(nbTask);\n");
    SW.pf("job.setCluster(cluster);\n\n");

    SW.pf("lib = databricks.Library(args{:});\n");
    SW.pf("lib.setType('whl');\n");
    SW.pf("lib.whl = libraryFullDest;\n");
    SW.pf("job.setLibrary(lib);\n\n");
    SW.pf("%% Create the job\n");
    SW.pf("job.create()\n");
    SW.pf("jobRun = job.runNow();\n\n");
    SW.pf('fprintf(''Created job "%%s", see run <a href="%%s">here</a>\\n'', job.name, jobRun.run_page_url)\n');



    SW.unindent();
    SW.pf("end %% EOF: %s\n\n", fileName);
end
