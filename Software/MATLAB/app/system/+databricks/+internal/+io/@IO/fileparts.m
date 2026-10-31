function [path, file, extension] = fileparts(inputPath, options)
    % FILEPARTS Performs fileparts like functionality for databricks.internal.io.IO paths
    %
    % Examples:
    %   [path, file, extension] = databricks.internal.io.IO.fileparts("/Workspace/Users/mbrowne@mathworks.com/mycode.m");

    % Copyright 2025 The MathWorks, Inc.

    arguments
        inputPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.type (1,1) databricks.internal.io.FileSystemType
    end

    if isfield(options, "type")
        type = options.type;
    else
        type = databricks.internal.io.IO.getType(inputPath);
    end

    if isempty(type)
        error("DATABRICKS:IO:FILEPARTS", "Filesystem type is required for: %s", inputPath);
    end

    switch type
        case {"VOLUMES", "WORKSPACE", "DBFS"}
            [path, file, extension] = innerFp(inputPath, type);

        % TODO Add abfss s3 support etc. see: Software/MATLAB/app/system/+databricks/+internal/+io/@IO/stripTrailingSlashes.m
        otherwise
            error("DATABRICKS:IO:FILEPARTS", "Filesystem type: %s, is not supported by databricks.internal.io.fileparts.", string(type))
    end
end


function [path, file, extension] = innerFp(inputPath, type)

    arguments
        inputPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        type string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    switch upper(type)
        case "DBFS"
            schemaCheck = "dbfs://";

        otherwise
            schemaCheck = "";
            %error("DATABRICKS:IO:FILEPARTS:INNERFP", "Filesystem type: %s, is not supported by databricks.internal.io.fileparts.", string(type))
    end

    schemaLen = strlength(schemaCheck);
    if schemaLen > 0 && startsWith(lower(inputPath), schemaCheck)        
        schema = extractBefore(inputPath, schemaLen+1);
        workingPath = extractAfter(inputPath, schemaLen);
    else
        schema = "";
        workingPath = inputPath;
    end

    parts = workingPath.split("/");
    path = join(parts(1:end-1), "/");
    if ismissing(path) || isempty(path)
        path = "";
    end
    path = schema + path;

    fullName = parts(end);
    nameParts = fullName.split(".");
    if numel(nameParts) > 1
        extension = "." + nameParts(end);
        file = join(nameParts(1:end-1), ".");
    else
        extension = "";
        file = nameParts(1);
    end

    if ismissing(file) || isempty(file)
        file = "";
    end
    if ismissing(extension) || isempty(extension)
        extension = "";
    end    
end