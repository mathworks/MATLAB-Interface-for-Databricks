function type = getType(path, options)
    % GETTYPE Returns an enumeration based on the type of a path
    % If a determination cannot be made an empty value is returned.
    % The return type is databricks.internal.io.FileSystemType.
    %
    % Example:
    %   ioEnumType = databricks.internal.io.IO.getType(pathStr);

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    % Remove lead and trailing white space
    path = strip(path);

    pathLower = lower(path);
    if startsWith(path, "/Volumes/")
        type = databricks.internal.io.FileSystemType.VOLUMES;
    elseif (startsWith(path, "/Users/") || startsWith(path, "/Shared/") || startsWith(path, "/Repos/") || startsWith(path, "/Workspace/"))
        type = databricks.internal.io.FileSystemType.WORKSPACE;
    elseif startsWith(path, "/dbfs/") || startsWith(pathLower, "dbfs:")
        type = databricks.internal.io.FileSystemType.DBFS;
    elseif startsWith(pathLower, "s3:") || startsWith(pathLower, "s3a:")
        type = databricks.internal.io.FileSystemType.S3;
    elseif startsWith(pathLower, "abfss:")
        type = databricks.internal.io.FileSystemType.ABFSS;
    else
        if options.verbose
            fprintf(2, "Unable to determine filesystem type for: %s\n", path);
        end
        type = databricks.internal.io.FileSystemType.empty;
    end
end