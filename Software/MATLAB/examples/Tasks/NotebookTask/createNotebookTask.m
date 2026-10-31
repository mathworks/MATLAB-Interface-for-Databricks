function nbTask = createNotebookTask(options)
    % createNotebookTask Create a simple notebook task
    %
    % Create a simple notebook task. To set a different number for number
    % of rows, add an argument N.
    %
    % Upload is automatic, but can be turned off with doUpload=false

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.N (1,1) int64 = 100
        options.doUpload (1,1) logical = true
    end
    arguments (Output)
        nbTask databricks.NotebookTask
    end

    % The local notebook
    here = fileparts(mfilename("fullpath"));
    srcFile = fullfile(here, "NotebookTask.py");

    % Create a folder in the users workspace
    ws = databricks.Workspace();
    baseFolder = "/Users/" + string(ws.username) + "/tmp";

    if options.doUpload
        if ~ws.directoryExists(baseFolder)
            ws.mkdirs(baseFolder);
        end
    end

    % Upload the notebook to Databricks
    [~,f,e] = fileparts(srcFile);
    dstFile = baseFolder + "/" + f + e;
    if options.doUpload
        ws.import('path', dstFile, ...
            'format', 'SOURCE', 'language', 'PYTHON', ...
            'file', srcFile, 'overwrite', true);
    end

    % Create the notebook with parameters
    params = struct('ds_limit', sprintf('%d', options.N));
    nbTask = databricks.NotebookTask(dstFile, params);
end