function [result, localPath] = download(obj, source, options)
    % DOWNLOAD Download a file or directory of files using the Files API
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
    %   f = databricks.Files;
    %   [result, localPath] = databricks.internal.files.download(f, "/volumes/main/default/myvolume/mydirectory")

    % Copyright 2025 The MathWorks, Inc.

    arguments
        obj databricks.Files
        source string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
        options.recursive (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    % If the source is a file just do a regular download and return
    if obj.fileExists(source)
        args = matlab.utils.addArgs(options, ["destination", "overwrite"]);
        if options.verbose
            fprintf("Downloading: %s\n", source);
        end
        [tf, errorResponse, lp] = obj.download(source, args{:});
        if ~isempty(errorResponse)
            fprintf("Error downloading: %s\n", source)
            disp(errorResponse);
            result = false;
            localPath = string.empty;
            return;
        end
        result = tf;
        if ~result
            fprintf("Unable to download: %s\n", source)
            localPath = string.empty;
            return;
        else
            localPath = lp;
        end
    elseif obj.directoryExists(source)
        args = matlab.utils.addArgs(options, ["destination", "overwrite"]);
        [tf, localDir] = createLocalDir(source, args{:});
        if ~tf
            fprintf("Unable to create destination directory: %s\n", localDir);
            localPath = string.empty;
            result = false;
            return;
        end
        srcDirList = obj.list(source);
        for n = 1:numel(srcDirList.contents)
            dstPath = fullfile(localDir, srcDirList.contents(n).name);
            args = {"destination", dstPath};
            args = matlab.utils.addArgs(options, ["verbose", "overwrite", "recursive"], args);
            % recursive call recursive call recursive call recursive call ...
            entryResult = databricks.internal.files.download(obj, srcDirList.contents(n).path, args{:});
            if ~entryResult
                fprintf("Unable to download: %s\n", srcDirList.contents(n).path);
                localPath = string.empty;
                result = false;
                return;
            end
        end
        result = true;
        localPath = localDir;
    else
        result = false;
        localPath = string.empty;
        fprintf("Source appears to be neither a file nor directory: %s\n", source);
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