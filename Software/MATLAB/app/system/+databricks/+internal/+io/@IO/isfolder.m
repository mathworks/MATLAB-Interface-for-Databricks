function tf = isfolder(obj, path, options)
    % ISFOLDER Filesystem type agnostic check for directory existence
    % Returns a logical.
    % Currently supports VOLUMES, DBFS & WORKSPACE types per
    % databricks.internal.io.FileSystemType.
    %
    % Example:
    %   io = databricks.internal.io.IO;
    %   tf = io.isfolder("/Volumes/main/default/myvolume/myDir")

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
        error("DATABRICKS:IO", "Filesystem type is required for: %s", path);
    end

    switch type
        case "VOLUMES"
            f = databricks.Files(obj.parentVarargin{:});
            tf = f.directoryExists(path);

        case "DBFS"
            if startsWith(lower(path), "dbfs://")
                dbfsPath = extractAfter(path, 6);
            elseif startsWith(lower(path), "/dbfs/")
                dbfsPath = extractAfter(path, 5);
            else
                dbfsPath = path;
            end

            d = databricks.DBFS(obj.parentVarargin{:});
            status = d.getStatus(dbfsPath);
            if isempty(status)
                tf = false;
            else
                if isprop(status, "is_dir") % false if this is a file not a directory
                    tf = status.is_dir;
                else
                    error("DATABRICKS:IO", "is_dir status property not found for %s", patdbfsPathh);
                end
            end

        case "WORKSPACE"
            w = databricks.Workspace(obj.parentVarargin{:});
            tf = w.directoryExists(path);

        otherwise
            error("DATABRICKS:IO", "Filesystem type: %s, is not supported by databricks.internal.io.IO.isfolder.", string(type))
    end
end