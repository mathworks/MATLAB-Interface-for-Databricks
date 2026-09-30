function upload(obj, source, destination, options)
    % UPLOAD Filesystem type agnostic file uploader
    % Currently supports DBFS, VOLUMES and WORKSPACE type per
    % databricks.internal.io.FileSystemType.
    %
    % The source should be a file.
    % The destination should be an absolute file path, and not a directory.
    %
    % Volumes, Workspaces and DBFS are supported.
    % DBFS is deprecated and not recommended.
    %
    % Example:
    %   io = databricks.internal.io.IO();
    %   io.upload(sourcePathVar, destinationPathVar, overwrite=true, verbose=false);

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        obj (1,1) databricks.internal.io.IO
        source string {mustBeTextScalar, mustBeFile}
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        
        options.type (1,1) databricks.internal.io.FileSystemType
        options.overwrite (1,1) logical = true
        
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if isfield(options, "type")
        type = options.type;
    else
        type = obj.getType(destination);
    end

    if isempty(type)
        error("DATABRICKS:IO:UPLOAD", "Filesystem type is required for: %s", destination);
    end

    switch type
        case "VOLUMES"
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            f = databricks.Files(args{:});
            f.upload(source, destination, overwrite=options.overwrite);
        case "WORKSPACE"
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            ws = databricks.Workspace(args{:});
            wsDir = regexp(destination, "^(.*)/[^/]+$", "tokens", "once");
            ws.mkdirs(wsDir);
            args = matlab.utils.addArgs(options, "overwrite");
            [wsResult, wsErrorResponse] = ws.import('path', destination, 'format', 'AUTO', 'file', source, 'verbose', false, args{:});
            if ~isempty(wsErrorResponse)
                disp(wsErrorResponse)
            end
            if ~wsResult || ~isempty(wsErrorResponse)
                error("DATABRICKS:IO:UPLOAD:WSFAIL","Workspace upload failed for: %s", source);
            end
        case "DBFS"
            if destination.startsWith("dbfs:")
                dest = destination.extractAfter("dbfs:");
            elseif destination.startsWith("/dbfs")
                dest = destination.extractAfter("/dbfs");
            else
                error("DATABRICKS:IO:INTERNAL_IO_NAME_BAD", ...
                    "This destination name is not a valid DBFS path.");
            end
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            db = databricks.DBFS(args{:});
            % For DBFS, the destination should not contain the name
            [destPath, destName] = i_fileparts(dest, "/");
            [~, srcName] = i_fileparts(source, filesep);
            if srcName ~= destName
                % Make a temporary source, to get the naming right
                newPath = tempname;
                mkdir(newPath);
                newSource = fullfile(newPath, destName);
                copyfile(source, newSource);
                rmAfter = onCleanup(@() rmdir(newPath, 's'));
                source = newSource;
            end
            db.upload(source, destPath);
        otherwise
            error("DATABRICKS:IO:UPLOAD", "Filesystem type: %s, is not supported by databricks.internal.io.upload.", string(type))
    end
end

function [thePath, theName] = i_fileparts(somePath, splitter)
    parts = somePath.split(splitter);
    thePath = join(parts(1:end-1), splitter);
    theName = parts(end);
end