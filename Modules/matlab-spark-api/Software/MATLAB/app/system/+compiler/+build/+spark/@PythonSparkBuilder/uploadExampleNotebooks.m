function uploadExampleNotebooks(obj, options)
    % uploadExampleNotebooks Upload example notebooks to Databricks
    %
    % uploadPath is a folder in the databricks Workspace, e.g.
    %
    %  uploadPath = "/Users/user@example.com/myexamples"
    %
    % If the folder does not exist, it will be created.
    %
    % If the PythonSparkBuilder object has the field NotebookDestination
    % set, an uploadPath need not be specified.
    %
    % The function will output information with links to the notebooks,
    % unless this is explicitly turned off with the option showURLs=false
    %
    % PSB.uploadExampleNotebooks(uploadPath="/Users/user@example.com.com/myexamples")
    % Import path: /Users/user@example.com.com/myexamples/plusPi_example
    % Uploaded notebook plusPi_example
    % Import path: /Users/user@example.com.com/myexamples/doMath_example
    % Uploaded notebook doMath_example
    % Import path: /Users/user@example.com.com/myexamples/addStringCol_example
    % Uploaded notebook addStringCol_example
    % Import path: /Users/user@example.com.com/myexamples/tblPlus_example
    % Uploaded notebook tblPlus_example
    % Import path: /Users/user@example.com.com/myexamples/myArr_example
    % Uploaded notebook myArr_example

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonSparkBuilder
        options.uploadPath (1,1) string
        options.showURLs (1,1) logical = true

        options.authMethod (1,1) string
        options.profileName (1,1) string 
    end

    if ~isDatabricksEnvironment
        warning("SPARKAPI:compiler_notebook_upload", ...
            "Uploading the notebook automatically can only be done for a " + ...
            "Databricks environment.");
        return;
    end

    if isfield(options, 'uploadPath')
        uploadPath = options.uploadPath; 
    elseif strlength(obj.NotebookDestination) > 0
        uploadPath = obj.NotebookDestination;
    else
        error("SPARKAPI:NOTEBOOKSUPLOAD:DESTMISSING", ...
            "When uploading notebooks, a destination must be provided, " + ...
            "either through an optional argument 'uploadPath' or by " + ...
            "setting NotebookDestination during build.");
    end

    args = {};
    if isfield(options, 'authMethod')
        args = {'authMethod', matlab.databricks.AuthMethod(options.authMethod)};
    end
    
    if isfield(options, 'profileName')
        args = [args, 'profileName', options.profileName];
    end

    ws = databricks.Workspace(args{:});

    ws.mkdirs(uploadPath);

    notebooks = obj.ExampleFiles.PythonExamples;

    for k=1:numel(notebooks)
        NB = notebooks(k);
        url = matlab.databricks.workspace.import(NB, uploadPath, args{:});
        if options.showURLs
            [~, plainName] = fileparts(NB);
            href = sprintf('<a href="%s">%s</a>', url, plainName);
            fprintf("Uploaded notebook %s\n", href);
        end
    end

end
