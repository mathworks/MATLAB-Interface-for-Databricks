function tf = fileExists(obj, path)
    % FILEEXISTS Checks if a Workspace file exists
    % Returns logical true is a file exists otherwise false.
    %
    % Example:
    %   ws = databricks.Workspace();
    %   ws.fileExists("/Workspace/Users/joe@example.com/mydirectorymyfile.txt");

    % Copyright MathWorks Inc. 2024-2025

    arguments
        obj (1,1) databricks.Workspace
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    try
        status = obj.getStatus(path);
    catch ME
        tf = false;
        return;
    end

    if ~isempty(status) && isstruct(status) && isfield(status, "object_type")
        if ~strcmp(status.object_type, "DIRECTORY")
            tf = true;
        else
            tf = false;
        end
    else
        error("DATABRICKS:FILEEXISTS", "Invalid databricks.Workspace.getStatus response returned for: %s", path);
    end

end


