function tf = directoryExists(obj, path)
    % DIRECTORYEXISTS Checks if a Workspace directory exists
    % Returns logical true is a directory exists otherwise false.

    % Copyright MathWorks Inc. 2024

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
        if strcmp(status.object_type, "DIRECTORY")
            tf = true;
        else
            tf = false;
        end
    else
        error("DATABRICKS:DIRECTORYEXISTS", "Invalid databricks.Workspace.getStatus response returned for: %s", path);
    end
end


