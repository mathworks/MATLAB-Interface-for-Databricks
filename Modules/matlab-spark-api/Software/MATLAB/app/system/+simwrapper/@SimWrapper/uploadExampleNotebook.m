function uploadExampleNotebook(swo, uploadPath, options)
    % uploadExampleNotebook Upload example notebook to Databricks
    %
    %
    %   swo.uploadExampleNotebook("/Users/user@email.com/somewhere")
    %

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
        uploadPath (1,1) string
        options.showURLs (1,1) logical = true

        options.authMethod (1,1) string
        options.profileName (1,1) string 
    end

    if ~isDatabricksEnvironment
        warning("SPARKAPI:codegen_notebook_upload", ...
            "Uploading the notebook automatically can only be done for a " + ...
            "Databricks environment.");
        return;
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

    notebookName = sprintf("%s_notebook_example.py", swo.Name);
    notebookFullName = fullfile(swo.BaseFolder, notebookName);

    url = matlab.databricks.workspace.import(notebookFullName, uploadPath, args{:});
    if options.showURLs
        [~, plainName] = fileparts(notebookFullName);
        href = sprintf('<a href="%s">%s</a>', url, plainName);
        fprintf("Uploaded notebook %s\n", href);
    end

end