function status = getStatus(obj, pathArg)
    % GETSTATUS Gets the status of an object or a directory
    % If path does not exist it errors with RESOURCE_DOES_NOT_EXIST.
    % Returns a struct on on success.
    % The returned value may or may not contain a create_at and modified_at
    % time stamp.
    %
    % Example:
    %   ws = databricks.Workspace;
    %   p = '/Users/joe@example.com/my-workspace-directory';
    %   status = ws.getStatus(p)
    %     status =
    %     struct with fields:
    %       object_type: 'DIRECTORY'
    %              path: '/Users/joe@example.com/my-workspace-directory'
    %         object_id: 3325061472565282

    %   (c) 2020-2026 The MathWorks, Inc.

    % Initializations
    curAPI = 'workspace';
    apiMethod = 'get-status';
    if ischar(pathArg) || isStringScalar(pathArg)
        curURI = obj.getURI(curAPI, apiMethod);
        qp = matlab.net.QueryParameter();
        qp.Name = "path";
        qp.Value = char(pathArg);
        curURI.Query(end+1) = qp;
    else
        error('DATABRICKS:ERROR','path must be of type scalar string or character vector');
    end

    % Create a request to create a secret scope
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call Databricks
    resp = request.send(curURI, obj.HTTPOptions);
    allowMissing = true; % object_id caught below with a dedicated message

    resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"object_id"}, "int64", {'created_at'}, 'int64', {'modified_at'}, 'int64');

    % Don't error if not present as not documented in the spec
    if isfield(resp.Body.Data, 'created_at')
        if isa(resp.Body.Data.created_at, 'int64')
            resp.Body.Data.created_at = datetime(resp.Body.Data.created_at, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
        else
            error('DATABRICKS:ERROR','Expected created_at to be of type int64');
        end
    end
    % Don't error if not present as not documented in the spec
    if isfield(resp.Body.Data, 'modified_at')
        if isa(resp.Body.Data.modified_at, 'int64')
            resp.Body.Data.modified_at = datetime(resp.Body.Data.modified_at, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
        else
            error('DATABRICKS:ERROR','Expected modified_at to be of type int64');
        end
    end

    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        status = resp.Body.Data;
        if ~isfield(status, 'object_id')
            error('DATABRICKS:ERROR','Expected object_id in status struct');
        end
    else
        matlab.databricks.internal.responseError(resp, 'Failed to get status');
    end

end %function