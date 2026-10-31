function downloadNotebooksRecursively(options)
    % DOWNLOADNOTEBOOKSRECURSIVELY

    % Copyright 2022-2024 The MathWorks, Inc.

    arguments
        options.startPath (1,1) string = ""
        options.scala (1,1) logical = true
        options.python (1,1) logical = true
        options.outdir (1,1) string = "./notebooks"
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    ws = databricks.Workspace(args{:});

    if strlength(options.startPath) == 0
        options.startPath = "/Users/" + ws.username;
    end
    files = ws.list(options.startPath);
    download_(files, options, ws);

end

function download_(fileList, options, ws)
    for k = 1:length(fileList)
        F = fileList(k);
        if F.object_type == "NOTEBOOK"
            if F.language == "PYTHON" && options.python
                downloadFile(F, options, ws);
            elseif F.language == "SCALA" && options.scala
                downloadFile(F, options, ws);
            end
        elseif F.object_type == "DIRECTORY"
            download_(ws.list(F.path), options, ws);
        else
            warning('DATABRICKS:unsupported_workspace_type', ...
                "This type hasn't been implemented yet.");
            disp(F)
        end
    end

end

function downloadFile(F, options, ws)

    if F.language == "SCALA"
        ext = ".scala";
    elseif F.language == "PYTHON"
        ext = ".py";
    end
    relPath = F.path.extractAfter(options.startPath) + ext;
    fullLocalName = fullfile(options.outdir, relPath);
    localPath = fileparts(fullLocalName);
    if ~isfolder(localPath)
        mkdir(localPath)
    end

    result = ws.export(F.path, 'SOURCE', false);
    [fh, errmsg] = fopen(fullLocalName, "w");
    if fh < 1
        error('DATABRICKS:file_write_open', ...
            "Problems opening file %s for writing.\nMessage: %s", fullLocalName, errmsg);
    end
    fprintf(fh, "%s\n", result.content);
    fclose(fh);
end
