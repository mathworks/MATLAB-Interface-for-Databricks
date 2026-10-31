function scopeTable = list(obj, varargin)
    % LIST Lists secret scopes
    % Lists all secret scopes available in the workspace. Returns a MATLAB table
    % on success. Errors with PERMISSION_DENIED if the caller does not have
    % permission to make the call. If no scopes are defined an empty table is
    % returned. Table entries are returned as scalar strings.
    %
    % Example:
    %   scope = databricks.Scope;
    %   scopes = scope.list
    %   scopes =
    %     2x2 table
    %         name       backend_type
    %       _________    ____________
    %       "aScope"     "DATABRICKS"
    %       "myScope"    "DATABRICKS"

    %   (c) 2020-2026 The MathWorks, Inc.

    % Initialization
    curAPI = 'secrets/scopes';
    apiMethod = 'list';
    curURI = obj.getURI(curAPI, apiMethod);

    % Create a request to create a secret scope
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call Databricks
    resp = request.send(curURI, obj.HTTPOptions);
    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if isfield(resp.Body.Data, 'scopes')
            nrows = numel(resp.Body.Data.scopes);
        else
            nrows = 0;
        end
        scopeTable = table('Size', [nrows, 2], 'VariableTypes', ["string", "string"], 'VariableNames', ["name", "backend_type"]);
        for n = 1:nrows
            scopeTable(n,:) = {string(resp.Body.Data.scopes(n).name), string(resp.Body.Data.scopes(n).backend_type)};
        end
    else
        matlab.databricks.internal.responseError(resp, 'Failed to list scopes');
    end
end
