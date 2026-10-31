function [url, link] = getNotebookLink(workspacePath, options)
    % getNotebookLink Return URL and optional link for a notebook
    %
    % Examples:
    %   url = matlab.databricks.workspace.getNotebookLink("/Workspace/Users/joe@example.com/myNotebook")
    %
    %   [url, link] = matlab.databricks.workspace.getNotebookLink("/Workspace/Users/joe@example.com/myNotebook")

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments (Input)
        workspacePath (1,1) string
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    arguments (Output)
        url (1,1) string
        link (1,1) string
    end

    args = matlab.utils.addArgs(options, {'authMethod', 'profileName'});

    ws = databricks.Workspace(args{:});
    wsObj = ws.ls(workspacePath);

    url = sprintf("%s/editor/notebooks/%ld", ws.Host, wsObj.object_id);

    if nargout > 1
        link = matlab.utils.URL2Link(url);
    else
        link = "";
    end
end