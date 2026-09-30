function [jobRun, job] = runSparkPythonTaskExample(pythonFile, wheelFile, options)
    % runSparkPythonTaskExample Run an example of PythonSparkTask
    %
    % This is a special function that runs a very simple example. It's used
    % for the example output of PythonSparkBuilder
    %
    % This function needs at least 2 arguments:
    %
    % [jobRun, job] = runSparkPythonTaskExample(pythonFile, wheelFile),
    %
    % where the Python file is the file to be run, and the wheel file is
    % the compiled MATLAB library. It returns to objects, representing the
    % jobRun and the job that were created.
    %
    % The function also takes additional arguments, which can be added in
    % the format 
    %    runSparkPythonTaskExample(pf, wf, 'arg', argValue)
    % or
    %    runSparkPythonTaskExample(pf, wf, arg=argValue)
    %
    % The optional arguments are:
    % baseFolderDBFS - The folder where the python and wheel files will be
    %                  uploaded
    % overwrite - If true, will overwrite files if they exist
    % cluster - The name of an existing cluster, or a uninitialized cluster
    %           object. If not present, a new job cluster will be created
    %           automatically.
    % openRunPage - A logical value specifying whether the runpage should
    %               be opened in a browser automatically.
    % interfaceDirectory - Non settings file value for the package's directory
    % authMethod - A matlab.databricks.AuthMethod
    % profileName - A configuration file profileName value

    % Copyright 2022-2024 The MathWorks, Inc.

    arguments
        pythonFile (1,1) string
        wheelFile (1,1) string
        options.baseFolderDBFS (1,1) string = "/tmp/delete_me"
        options.overwrite (1,1) logical = false
        options.cluster (1,1) string = ""
        options.openRunPage (1,1) logical = true
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    pythonName = getPlainName(pythonFile);
    wheelName = getPlainName(wheelFile);

    pythonDst = options.baseFolderDBFS + "/" + pythonName;
    wheelDst = options.baseFolderDBFS + "/" + wheelName;

    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "baseFolderDBFS", "overwrite"]);
    uploadFile(pythonFile, pythonDst, args{:});
    uploadFile(wheelFile, wheelDst, args{:});

    if strlength(options.cluster) == 0
        args = matlab.utils.addArgs(options, ["authMethod", "profileName", "interfaceDirectory"]);
        cluster = createDatabricksCluster('test-cluster', 0, 'create',false, args{:});
    else
        cluster = options.cluster;
    end

    spt = databricks.SparkPythonTask( ...
        'python_file', "dbfs:" + pythonDst, ...
        'parameters', "1000");

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    job = databricks.Job(args{:});
    job.name = sprintf('sparkpythontask-example-%s', ...
        string(datetime('now', 'Format', 'uuuu-MM-dd_HHmmss.SSS')));
    job.setCluster(cluster);
    job.setTask(spt);

    wheelLib = databricks.Library(args{:});
    wheelLib.setType('whl');
    wheelLib.whl = "dbfs:" + wheelDst;

    JB = databricks.Library(args{:});
    JB.setType('jar');
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
    end
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    javabuilderPath = databricks.internal.mlRuntime.getLatestJavabuilder(interfaceDirectory, release, args{:});
    JB.jar = javabuilderPath;
            
    job.setLibrary([wheelLib, JB]);

    job.create();
    jobRun = job.runNow();

    if options.openRunPage
        openURL = true;
        if batchStartupOptionUsed
            fprintf(2, "Cannot open job URL in batch mode: %s\n", jobRun.run_page_url);
            openURL = false;
        end
        if isdeployed
            fprintf(2, "Cannot open job URL in deployed mode: %s\n", jobRun.run_page_url);
            openURL = false;
        end
        if openURL
            web(jobRun.run_page_url);
        end
    end
end

function uploadFile(localName, dbfsName, options)
    arguments
        localName string {mustBeTextScalar, mustBeNonzeroLengthText}
        dbfsName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.baseFolderDBFS (1,1) string = "/tmp/delete_me"
        options.overwrite (1,1) logical = false
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    db = databricks.DBFS(args{:});

    if options.overwrite
        doUpload = true;
    else
        stat = db.getStatus(dbfsName);
        doUpload = isempty(stat);
    end
    if doUpload
        db.upload(localName, options.baseFolderDBFS);
    end
end

function plainName = getPlainName(fullName)
    [~, name, ext] = fileparts(fullName);
    plainName = name + ext;
end