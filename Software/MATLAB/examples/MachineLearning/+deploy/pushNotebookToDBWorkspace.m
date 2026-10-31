function [URLString, URLHyperlink] = pushNotebookToDBWorkspace(DI)
    % PUSHNOTEBOOKTODBWORKSPACE Upload a notebook from local machine to workspace

    % Copyright 2021-2026 The MathWorks, Inc.

    wsPath = DI.PythonNotebookPath;
    notebook = DI.PythonNotebookSource;
    nbLang = 'PYTHON';

    % Configure the notebook details
    ws = databricks.Workspace;
    ws.import(...
        'path', wsPath, ...
        'format', 'SOURCE', ...
        'language', nbLang, ...
        'overwrite', true, ...
        'file', notebook);

    % Report URL to user
    % This URL will open the notebook on Databricks
    PN  = ws.getStatus(wsPath);

    o = databricks.Object;
    o.getAuth;

    URLString = sprintf("%s/editor/notebooks/%s", o.Host, PN.resource_id);
    URLHyperlink = sprintf('<a href="matlab: web(''%s'')">%s</a>', URLString, URLString);
end