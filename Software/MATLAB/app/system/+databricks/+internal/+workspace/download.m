function [result, localPath] = download(obj, source, options)
    % DOWNLOAD Download a file or directory of files using the Workspaces API
    % 
    % Optional arguments:
    %   destination: Specify a destination path, otherwise the current directory
    %                is used along with the source file/directory name.
    %
    %     overwrite: Overwrite an existing local file or directory.
    %                Default: true.
    %
    %     recursive: Recursively download subdirectories.
    %                Default: true.
    %
    %       verbose: Enable additional output.
    %                Default: true.
    %
    % Example:
    %   ws = databricks.Workspace;
    %   [result, localPath] = databricks.internal.workspace.download(ws, "/Workspace/Users/joe@example.com/myDirectory");

    % Copyright 2025 The MathWorks, Inc.

    arguments
        obj databricks.Workspace
        source string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
        options.recursive (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    result = false;
    localPath = string.empty;

    if startsWith(lower(source), "/Workspace/")
        source = extractAfter(source, 10);
    end
    
    % If the source is a file just do a regular download and return
    if obj.fileExists(source)
        if options.verbose
            fprintf("Downloading: %s\n", source);
        end

        if isfield(options, "destination")
            if isfolder(options.destination)
                dstDir = options.destination;
                dstFile = getFileNameFromPath(source);
                dstPath = fullfile(dstDir, dstFile);
            elseif isfile(options.destination)
                dstPath = options.destination;
                dstDir = fileparts(options.destination);
                dstFile = getFileNameFromPath(dstPath); %#ok<NASGU>
            else
                % destination does not exist
                dstPath = options.destination;
                dstDir = fileparts(options.destination);
                dstFile = getFileNameFromPath(dstPath); %#ok<NASGU>
            end
        else
            dstDir = pwd;
            dstFile = getFileNameFromPath(source);
            dstPath = fullfile(dstDir, dstFile);
        end

        if isfile(dstPath) && ~options.overwrite
            fprintf(2, "Destination exists, set overwrite option to true to overwrite: %s\n", dstPath);
            return;
        end

        % Create the destination directory if it does not exist
        if ~isfolder(dstDir)
            [status, msg] = mkdir(dstDir);
            if status ~= 1
                fprintf(2, "Unable to create directory: %s\n%s\n", dstDir, msg);
                return;
            else
                % R2025a added the ability to cancel the clean up when the download is complete
                if ~isMATLABReleaseOlderThan('R2025a')
                    cleanup = onCleanup(@() rmdir(dstDir, 's'));
                end
            end
        end
        
        %args = matlab.utils.addArgs(options, ["destination", "overwrite"]);
        [fileId, errmsg] = fopen(dstPath, "w");
        if fileId == -1
            fprintf(2, "Could not open file: %s\n%s\n", dstPath, errmsg);
            return;
        else
            whenDone = onCleanup(@() fclose(fileId));
            directDownload = true;
            format = 'AUTO';
            content = obj.export(source, format, directDownload);
            ctr = fwrite(fileId, content);
            if isStringScalar(content)
                nVals = strlength(content);
            else
                nVals = numel(content);
            end
            if ctr ~= nVals
                fprintf(2, "Could not write all content to file: %s\n", dstPath);
            else
                result = true;
                localPath = dstPath;
            end
        end
    elseif obj.directoryExists(source)
        args = matlab.utils.addArgs(options, ["destination", "overwrite"]);
        [tf, localDir] = createLocalDir(source, args{:});
        if ~tf
            fprintf("Unable to create destination directory: %s\n", localDir);
            return;
        end
        srcDirList = obj.list(source);
        for n = 1:numel(srcDirList)
            switch srcDirList(n).object_type
                case {"NOTEBOOK", "FILE", "LIBRARY"}
                    dstPath = fullfile(localDir, getFileNameFromPath(srcDirList(n).path));
                    args = {"destination", dstPath};
                    args = matlab.utils.addArgs(options, ["verbose", "overwrite", "recursive"], args);
                    entryResult = databricks.internal.workspace.download(obj, srcDirList(n).path, args{:});
                    if ~entryResult
                        fprintf("Unable to download: %s\n", srcDirList(n).path);
                        return;
                    end
                
                case "DIRECTORY"
                    if options.recursive
                        dstPath = fullfile(localDir, getFileNameFromPath(srcDirList(n).path));
                        args = {"destination", dstPath};
                        args = matlab.utils.addArgs(options, ["verbose", "overwrite", "recursive"], args);
                        entryResult = databricks.internal.workspace.download(obj, srcDirList(n).path, args{:});
                        if ~entryResult
                            fprintf("Unable to download: %s\n", srcDirList(n).path);
                            return;
                        end
                    end

                case "REPO"
                    fprintf(2, "Skipping download of repo path: %s\n", srcDirList(n).path);

                case "DASHBOARD"
                    fprintf(2, "Skipping download of dashboard path: %s\n", srcDirList(n).path);

                otherwise
                    fprintf(2, "Unexpected object type: %s, for path: %s, skipping download.\n", srcDirList(n).object_type, srcDirList(n).path);
            end
        end
        result = true;
        localPath = localDir;
    else
        if databricks.internal.workspace.exist(source, workspace=obj)
            fprintf(2, "Source appears to be neither a file nor directory: %s\n", source);
        else
            fprintf("Source not found: %s\n", source);
        end
    end
end


function [tf, localDir] = createLocalDir(source, options)
    arguments
        source string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = false
    end

    if isfield(options, "destination")
        localDir = options.destination;
    else
        % Create a local dir based on the name of the last portion of the source path
        % this might be a dir called
        [~, p, e] = fileparts(source);
        localDir = fullfile(pwd, p + e);
    end

    if isfolder(localDir)
        % do nothing, it will be written into
        tf = true;
    elseif isfile(localDir)
        if options.overwrite
            % Overwrite the file with a directory
            [status, msg, msgID] = mkdir(localDir);
            if status ~= 1
                %if options.verbose
                    fprintf("Unable to create directory: %s\nMessage: %s\nMessage Id: %s\n", localDir, msg, msgID);
                %end
                tf = false;
            else
                tf = true;
            end
        else
            tf = false;
            if options.verbose
                fprintf("A file already exists, not overwriting: %s\n", localDir);
            end
        end
    else
        [status, msg, msgID] = mkdir(localDir);
        if status ~= 1
            %if options.verbose
                fprintf("Unable to create directory: %s\nMessage: %s\nMessage Id: %s\n", localDir, msg, msgID);
            %end
            tf = false;
        else
            tf = true;
        end
    end
end


function filename = getFileNameFromPath(path)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    [p, n, e] = fileparts(path); %#ok<ASGLU>
    filename = n + e;
end