function result = fileExists(obj, filePath)
    % FILEEXISTS Check if a file exists
    % If a file exists a logical true is returned. Otherwise false is
    % returned.
    %
    % The required filePath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   tf = f.fileExists("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    %   tf =
    %       true
    %
    % See also: https://docs.databricks.com/api/workspace/files/getmetadata
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        filePath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    md = obj.fileMetadata(filePath);

    if isa(md, "databricks.datastructures.files.FileMetadata")
        result = true;
    elseif isa(md, "databricks.datastructures.files.ErrorResponse") && strcmp(md.errorCode, "NOT_FOUND")
        result = false;
    else
        if isprop(md, "errorCode") && isprop(md, "message")
            fprintf(2, "Error checking existence of: %s\nerrorCode: %s\nmessage: %s\n", filePath, md.errorCode, md.message);
        else
            fprintf(2, "Error checking existence of: %s\n", filePath);
        end
        result = false;
    end
end