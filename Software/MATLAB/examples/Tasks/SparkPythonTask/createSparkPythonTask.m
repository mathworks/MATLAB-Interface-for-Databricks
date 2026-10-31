function task = createSparkPythonTask(options)
    % createSparkPythonTask Create an example task to execute a .py script

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.N (1,1) int64 = 100
        options.doUpload (1,1) logical = true
    end
    arguments (Output)
        task databricks.SparkPythonTask
    end

    % The local notebook
    here = fileparts(mfilename("fullpath"));
    srcFile = fullfile(here, "PythonTask.py");
    assert(isfile(srcFile), "Task file not found: %s", srcFile);

    ws = databricks.Workspace();
    baseFolder = "/Workspace/Users/" + string(ws.username) + "/Examples";
    if options.doUpload
        if ~ws.directoryExists(baseFolder)
            ws.mkdirs(baseFolder);
        end
    end

    % Upload the notebook to Databricks
    [~,f,e] = fileparts(srcFile);
    dstFile = baseFolder + "/" + f + e;
    if options.doUpload
        % Note the use of 'RAW' is important so that the file is imported
        % as a Python script and not a notebook, for notebooks a notebook
        % task should be used instead
        ws.import('path', dstFile, ...
            'format', 'RAW', 'language', 'PYTHON', ...
            'file', srcFile, 'overwrite', true);
    end

    task = databricks.SparkPythonTask(python_file=dstFile, parameters=string(options.N));
end
