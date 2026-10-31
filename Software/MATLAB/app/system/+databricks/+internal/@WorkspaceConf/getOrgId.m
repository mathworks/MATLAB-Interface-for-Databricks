function orgId = getOrgId(obj)
    % GETORGID Return the Workspace orgId or an empty string if it is not found
    %
    % Example:
    %    wsc = databricks.internal.WorkspaceConf;
    %    orgId = wsc.getOrgId();

    % Copyright 2024-2026 MathWorks, Inc.

    arguments (Input)
        obj databricks.internal.WorkspaceConf
    end
    arguments (Output)
        orgId string
    end

    % Get URI
    URI = obj.getURI('workspace-conf', '');
    URI.Path(end) = [];

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    % Return empty by default
    orgId = string.empty;

    if ~isprop(resp, "Header")
        return;
    end

    for n = 1:numel(resp.Header)
        if strcmpi(resp.Header(n).Name, "x-databricks-org-id")
            orgId = string(resp.Header(n).Value);
            break;
        end
    end
end