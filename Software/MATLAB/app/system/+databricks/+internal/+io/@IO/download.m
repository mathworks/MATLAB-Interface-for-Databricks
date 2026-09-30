function [result, localPath] = download(obj, source, options)
    % DOWNLOAD File system type agnostic file down loader
    % Currently supports VOLUMES, DBFS and WORKSPACE type per
    % databricks.internal.io.FileSystemType.
    %
    % Example:
    %   io = databricks.internal.io.IO(authMethod="PAT");
    %   [result, localPath] = io.download("/Volumes/main/default/myvolume/mydir/myfile.txt");
    %
    % In general the use of DBFS is discouraged.
    %
    % In MATLAB releases older than R2025a a failed download may leave behind a
    % destination directory when working with /Volumes.


    % Copyright 2025 The MathWorks, Inc.

    arguments
        obj (1,1) databricks.internal.io.IO
        source string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText} = pwd
        options.type (1,1) databricks.internal.io.FileSystemType
        options.overwrite (1,1) logical = true
        options.recursive (1,1) logical = true
        options.verbose (1,1) logical = true
    end
    
    result = false;
    localPath = string.empty;

    % Determine if using Volumes, DBFS or Workspace for the source
    if isfield(options, "type")
        type = options.type;
    else
        type = obj.getType(source);
    end
    if isempty(type)
        fprintf(2, "Filesystem type is required for: %s\n", source);
        return;
    end
    
    srcIsFile = obj.isfile(source);
    srcIsFolder = obj.isfolder(source);
    
    % Sanity check the source it should not be both a file and a folder or neither
    if ~srcIsFile && ~srcIsFolder
        fprintf(2, "Source not found: %s\n", source);
        return;
    end
    
    if srcIsFile && srcIsFolder
        fprintf(2, "The source must be either a file or a directory: %s\n", source);
        return;
    end
    
    dstNS = databricks.internal.io.IO.stripTrailingSlashes(options.destination);
    dstIsfile = isfile(dstNS);
    dstIsFolder = isfolder(dstNS);
    dstExists = dstIsFolder || dstIsfile;

    if srcIsFolder
        if dstExists
            if dstIsFolder
                dstDir = dstNS;
                dstPath = fullfile(dstDir, getFileNameFromPath(source));
            else % dst is a file
                dstPath = dstNS;
                dstDir = fileparts(dstPath);
            end
        else % dst is neither a file or folder
            dstPath = dstNS;
            dstDir = fileparts(dstPath);
        end
    else % source is a file
        if dstExists
            if dstIsFolder
                dstDir = dstNS;
                dstPath = fullfile(dstDir, getFileNameFromPath(source));
            else % dst is a file
                dstPath = dstNS;
                dstDir = fileparts(dstPath);
            end
        else % dst is neither a file or a folder
            dstPath = dstNS;
            dstDir = fileparts(dstPath);
        end
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

    switch type
        case "VOLUMES"
            f = databricks.Files(obj.parentVarargin{:});
            if options.recursive || srcIsFolder
                args = matlab.utils.addArgs(options, ["verbose", "overwrite"]);
                [result, localPath] = databricks.internal.files.download(f, source, 'destination', dstPath, args{:});
                if ~result
                    fprintf(2, "Download of: %s failed.\n", source);
                    % localPath have a value even if failed from files.download
                    localPath = string.empty;
                    return;
                end
            else
                args = matlab.utils.addArgs(options, "overwrite");
                [result, errorResponse, localPath] = f.download(source, 'destination', dstPath, args{:});
                if ~result
                    if options.verbose
                        fprintf(2, "Download of: %s failed.\n", source);
                        disp(errorResponse);
                    end
                    localPath = string.empty;
                    return;
                end
            end
        
        case "WORKSPACE"
            ws = databricks.Workspace(obj.parentVarargin{:});
            args = matlab.utils.addArgs(options, ["verbose", "overwrite", "recursive"]);
            [result, localPath] = databricks.internal.workspace.download(ws, source, "destination", dstPath, args{:});
            % if isfile(dstPath) && ~options.overwrite
            %     fprintf(2, "Destination exists, set overwrite option to true to overwrite: %s\n", dstPath);
            %     return;
            % end
            % 
            % if srcIsFolder
            %     if options.verbose
            %         fprintf("Workspace directories are downloaded as DBC files.\n");
            %     end
            %     dstPath = dstPath + ".dbc";
            % end
            % 
            % ws = databricks.Workspace(obj.parentVarargin{:});
            % directDownload = true;
            % format = 'AUTO';
            % [fileId, errmsg] = fopen(dstPath, "w");
            % if fileId == -1
            %     fprintf(2, "Could not open file: %s\n%s\n", dstPath, errmsg);
            %     return;
            % else
            %     whenDone = onCleanup(@() fclose(fileId));
            %     content = ws.export(source, format, directDownload);
            %     ctr = fwrite(fileId, content);
            %     if isStringScalar(content)
            %         nVals = strlength(content);
            %     else
            %         nVals = numel(content);
            %     end
            %     if ctr ~= nVals
            %         fprintf(2, "Could not write all content to file: %s\n", dstPath);
            %         return;
            %     end
            %     localPath = dstPath;
            %     result = true;
            % end

        case "DBFS"
            if isfile(dstPath) && ~options.overwrite
                fprintf(2, "Destination exists, set overwrite option to true to overwrite: %s\n", dstPath);
                return;
            end

            if srcIsFolder || options.recursive
                recurse = true;
            else
                recurse = false;
            end

            if startsWith(lower(source), "/dbfs/")
                dbfsSrc = extractAfter(source, 5);
            elseif startsWith(lower(source), "dbfs://")
                dbfsSrc = extractAfter(source, 6);
            else
                dbfsSrc = source;
            end

            db = databricks.DBFS(obj.parentVarargin{:});
            tmpName = tempname;
            [status, msg] = mkdir(tmpName);
            if status ~= 1
                fprintf(2, "Unable to create temporary directory: %s\n%s\n", tmpName, msg);
                return;
            else
                dbfsTmp = onCleanup(@() rmdir(tmpName, 's'));
                dbfsDownloadPath = string(db.download(dbfsSrc, 'outfolder', tmpName, 'recurse', recurse, 'silent', options.verbose));
                if isempty(dbfsDownloadPath)
                    fprintf(2, "Unable to download: %s\n", dbfsSrc);
                    return;
                end
                [cpStatus, cpMsg] = copyfile(fullfile(tmpName, getFileNameFromPath(dbfsSrc)), dstPath);
                if cpStatus ~= 1
                    fprintf(2, "Unable relocate downloaded file, from: %s, to: %s\n%s\n", fullfile(tmpName, getFileNameFromPath(dbfsSrc)), dstPath, cpMsg);
                    return;
                else
                    result = true;
                end
            end

        otherwise
            fprintf(2, "Filesystem type: %s, is not supported by databricks.internal.io.download.\n", string(type));
    end

    if result && ~isMATLABReleaseOlderThan('R2025a') && exist("cleanup", "var") == 1
        cancel(cleanup); % i.e. keep the created directory
    end
end


function filename = getFileNameFromPath(path)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    [p, n, e] = fileparts(path); %#ok<ASGLU>
    filename = n + e;
end
