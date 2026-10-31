function objs = list(obj, varargin)
    % LIST Lists contents of Databricks workspace directory or object.
    %
    % Returns a cell array of object structs on on success.
    % If no objects are defined an empty cell array is returned.
    %
    % If no argument is required a top level listing for the current user is
    % returned equivalent to ws.list('/Users/user@example.com/')
    % The username is configured in the databricks-settings.json file
    %
    % Example:
    %   ws = databricks.Workspace;
    %   wsArray = ws.list('/Users/user@example.com/')
    %   wsArray = 
    %     1x65 ObjectInfo array with properties:
    %       object_type
    %       object_id
    %       path
    %       language
    %
    %   % Examine object of type NOTEBOOK
    %   wsArray(1)
    %   ans =
    %     ObjectInfo with properties:
    %       object_type: NOTEBOOK
    %       object_id: 203885482887083
    %       path: "/Users/user@example.com/myNotebook"
    %       language: "PYTHON"
    %
    %   % Examine object of type DIRECTORY
    %   wsArray(4)
    %   ans =
    %   struct with fields:
    %     object_type: 'DIRECTORY'
    %            path: '/Users/user@example.com/my-workspace-directory'
    %       object_id: 3325061472565282

    %   (c) 2020-2026 The MathWorks, Inc.

    if isempty(varargin)
        if isprop(obj, 'username')
            if ~isempty(obj.username)
                % Insert username into '/Users/joe@example.com/')
                pathArg = ['/Users/', char(obj.username), '/'];
            else
                error('DATABRICKS:ERROR','Workspace username property is empty');
            end
        else
            error('DATABRICKS:ERROR','No username property on Workspace object as expected');
        end
    elseif length(varargin) == 1 %#ok<ISCL>
        pathArg = varargin{1};
    else
        error('DATABRICKS:ERROR','Unexpected number of arguments');
    end
    if ischar(pathArg) || isStringScalar(pathArg)
        curURI = obj.getURI("workspace", "list");
        curURI.Query(end+1) = matlab.net.QueryParameter("path", pathArg);
    else
        error('DATABRICKS:ERROR','path must be of type scalar string or character vector');
    end

    % Create a request to create a secret scope
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call Databricks
    resp = request.send(curURI, obj.HTTPOptions);
    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        objs = databricks.datastructures.ObjectInfo.fromJSON(resp.Body.Data);
    else
        matlab.databricks.internal.responseError(resp, 'Failed to list Workspaces');
    end
end
