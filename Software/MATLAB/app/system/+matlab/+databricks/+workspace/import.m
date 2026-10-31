function url = import(srcFile, dstFolder, options)
    % import Import file to workspace
    %
    % This is a helpful utility, that removes some of the details of the
    % official methods in the databricks.Workspace class
    %
    %   matlab.databricks.workspace.import("demo.py", "/Users/user@example.com/Demos")
    %
    % This will import the file demo.py into the workspace with the name
    % without extension:
    %
    %   "/Users/jdoe@example.com/Demos/demo"
    %
    % The destination folder given as the second argument to the function
    % will be created if it doesn't exist already.
    %
    % If called with an output argument, it will return a URL for opening
    % the notebook in the Databricks portal.
    %
    %   url = matlab.databricks.workspace.import("demo.py", "/Shared")

    % Copyright 2025 The MathWorks, Inc.

    arguments
        srcFile (1,1) string {mustBeFile}
        dstFolder (1,1) string
        options.overwrite (1,1) logical = true
        options.printURL (1,1) logical = false

        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if ~endsWith(srcFile, ".py")
        error("DATABRICKS:workspace_import", ...
            "This utility currently only works with Python files/notebooks");
    end

    if ~endsWith(dstFolder, "/")
        dstFolder = dstFolder + "/";
    end

    args = matlab.utils.addArgs(options, {'authMethod', 'profileName'});

    ws = databricks.Workspace(args{:});

    % Create directory if necessary
    if ~ws.directoryExists(dstFolder)
        ws.mkdirs(dstFolder);
    end

    content = fileread(srcFile);
    [~, srcPlain] = fileparts(srcFile);
    dstFile = dstFolder + srcPlain;

    ws.import('path', dstFile, 'format', 'SOURCE', ...
        'language', 'PYTHON', ...
        'content', content, ...
        'overwrite', options.overwrite);

    urlTmp = matlab.databricks.workspace.getNotebookLink(dstFile, args{:});
    if nargout > 0
        url = urlTmp;
    end
    if options.printURL
        printURL(urlTmp, srcPlain);
    end  
end

function printURL(url, plainName)
    fprintf('Notebook <a href="%s">%s</a> uploaded.\n', url, plainName);
end
