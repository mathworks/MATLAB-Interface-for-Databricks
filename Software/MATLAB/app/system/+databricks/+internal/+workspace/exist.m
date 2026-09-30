function tf = exist(path, options)
    % exist Returns true if a Workspace object of a given path exists, otherwise false
    %
    % Example:
    %   % Creates a Workspace object as required
    %   tf = databricks.internal.workspace.exist(path);
    %
    %   % Use an existing Workspace
    %   tf = databricks.internal.workspace.exist(path, workspace=ws);

    % Copyright MathWorks Inc. 2024

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.workspace (1,1) databricks.Workspace
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    
    if isfield(options, "workspace")
        tf = testExists(options.workspace, path);
    else
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        workspace = databricks.Workspace(args{:});
        tf = testExists(workspace, path);
    end
end


function tf = testExists(workspace, path)
    arguments
        workspace (1,1) databricks.Workspace
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    try
        t = workspace.ls(path);
        if istable(t) && ~isempty(t) && height(t) == 1
            tf = true;
        else
            error("Unexpected workspace ls response for: %s", path);
        end
    catch ME
        if contains(ME.message, '"error_code":"RESOURCE_DOES_NOT_EXIST"')
            tf = false;
        else
            error("Unexpected workspace ls response for: %s\nMessage: %s", path, ME.message);
        end
    end
end
