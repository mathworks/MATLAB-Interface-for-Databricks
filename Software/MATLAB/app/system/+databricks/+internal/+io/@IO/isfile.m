function tf = isfile(obj, path, options)
    % ISFILE Filesystem type agnostic check for file existence
    % Returns a logical.
    % Currently supports VOLUMES, DBFS & WORKSPACE types per
    % databricks.internal.io.FileSystemType.
    %
    % Example:
    %   io = databricks.internal.io.IO;
    %   tf = io.isfile("/Volumes/main/default/myvolume/myDir/hello-world.txt")

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        obj (1,1) databricks.internal.io.IO
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.type (1,1) databricks.internal.io.FileSystemType
        options.verbose (1,1) logical = true
    end

    if isfield(options, "type")
        type = options.type;
    else
        type = obj.getType(path);
    end

    if isempty(type)
        error("DATABRICKS:IO", "Filesystem type is required for %s", path);
    end

    switch type
        case "VOLUMES"
            f = databricks.Files(obj.parentVarargin{:});
            tf = f.fileExists(path);

        case "DBFS"
            if startsWith(lower(path), "dbfs://")
                dbfsPath = extractAfter(path, 6);
            elseif startsWith(lower(path), "/dbfs/")
                dbfsPath = extractAfter(path, 5);
            else
                dbfsPath = path;
            end

            d = databricks.DBFS(obj.parentVarargin{:}); % no verbose option
            status = d.getStatus(dbfsPath);
            if isempty(status)
                tf = false;
            else
                if isprop(status, "is_dir") % false if this is a directory not a file
                    tf = ~status.is_dir;
                else
                    error("DATABRICKS:IO", "is_dir status property not found for %s", dbfsPath);
                end
            end

        case "WORKSPACE"
            w = databricks.Workspace(obj.parentVarargin{:}); % no verbose option
            tf = w.fileExists(path);

        otherwise
            error("DATABRICKS:IO", "Filesystem type: %s, is not supported by databricks.internal.io.IO.isfile.", string(type))
    end
end