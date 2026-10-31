function tf = mkdir(obj, path, options)
    % mkdir Filesystem type agnostic mkdir
    % Returns a logical.
    % Currently supports VOLUMES, DBFS & WORKSPACE types per
    % databricks.internal.io.FileSystemType.
    %
    % If using DBFS this method will not work if there exists a file (not a 
    % directory) at any prefix of the path.
    %
    % Example:
    %   io = databricks.internal.io.IO;
    %   tf = io.mkdir("/Volumes/main/default/myvolume/myDir");

    % Copyright 2025 The MathWorks, Inc.

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
        fprintf(2, "Filesystem type is required for %s\n", path);
        tf = false;
        return;
    end

    switch type
        case "VOLUMES"
            f = databricks.Files(obj.parentVarargin{:});
            tf = f.create(path);

        case "DBFS"
            d = databricks.DBFS(obj.parentVarargin{:});
            try
                ph = databricks.internal.DatabricksPathHelper(path);
                if ~ph.IsDBFS
                    fprintf(2, "Expected a DBFS path: %s\n", path);
                    tf = false;
                    return;
                end
                strippedPath = ph.get(stripDBFS=true)
                d.mkdir(strippedPath);
                tf = true;
            catch
                tf = false;
            end

        case "WORKSPACE"
            w = databricks.Workspace(obj.parentVarargin{:});
            tf = w.mkdirs(path);
            
        otherwise
            fprintf(2, "Filesystem type: %s, is not supported by databricks.internal.io.IO.mkdir.", string(type))
            tf = false;
            return;
    end
end