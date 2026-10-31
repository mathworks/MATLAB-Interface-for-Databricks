function [result, errorResponse] = check(obj, keys)
    % CHECK Check configuration status
    % TODO API is not sufficiently documented as yet.
    %
    % Example:
    %   wsc = databricks.internal.WorkspaceConf
    %   [result, errorResponse] = wsc.check("enableExportNotebook")
    %
    % See also: https://docs.databricks.com/api/workspace/workspaceconf/getstatus

    % Unofficial key values: https://github.com/fusionet24/DailyDatabricks/blob/main/tips/workspace-conf.md

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        obj databricks.internal.WorkspaceConf
        keys string {mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('workspace-conf', '');
    URI.Path(end) = [];

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % keys parameters
    % API implies > 1 value support but does not appear to work
    for n = numel(keys)
        URI.Query(end+1) = matlab.net.QueryParameter("keys", keys(n));
    end
 
    % Perform the actual call
    % TODO convert to JSON Mapper map
    resp = request.send(URI, obj.HTTPOptions);
 
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = resp.Body.Data;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = struct.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
