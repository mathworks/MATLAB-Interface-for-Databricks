classdef FileSystemType
    % FileSystemType Enumeration for File System types
    %
    % Example:
    %   type = databricks.internal.io.FileSystemType.DBFS

    % Copyright 2024-2025 The MathWorks, Inc.

    enumeration
        DBFS
        ABFSS
        S3
        WORKSPACE
        VOLUMES
    end
end
