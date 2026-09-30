function result = directoryExists(obj, directoryPath)
    % DIRECTORYEXISTS Check if a directory exists
    % If a directory exists a logical true is returned. Otherwise false is
    % returned.
    %
    % The required directoryPath argument is given as an absolute path,
    % as a scalar text value.
    %
    % Example:
    %   f = databricks.Files;
    %   tf = f.directoryExists("/Volumes/main/default/myvolume/myDir")
    %   tf =
    %       true
    %
    % See also: https://docs.databricks.com/api/workspace/files/getmetadata
    
    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj databricks.Files
        directoryPath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    md = obj.directoryMetadata(directoryPath);

    if isa(md, "databricks.datastructures.files.DirectoryMetadata") && md.exists == true
        result = true;
    elseif isa(md, "databricks.datastructures.files.ErrorResponse") && strcmp(md.errorCode, "NOT_FOUND")
        result = false;
    else
        if isprop(md, "errorCode") && isprop(md, "message")
            fprintf(2, "Error checking existence of: %s\nerrorCode: %s\nmessage: %s\n", directoryPath, md.errorCode, md.message);
        else
            fprintf(2, "Error checking existence of: %s\n", directoryPath);
        end
        result = false;
    end
end