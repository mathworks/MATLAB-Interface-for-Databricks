function create(obj, varargin)
% CREATE Create a Databricks secret scope in which secrets are stored
% Secrets are stored in Databricks-managed storage and encrypted.
% Errors with RESOURCE_ALREADY_EXISTS if a scope with the given name already
% exists. Errors with RESOURCE_LIMIT_EXCEEDED if maximum number of scopes in the
% workspace is exceeded (100). Errors with INVALID_PARAMETER_VALUE if the scope
% name is invalid. This method support vectorization.
%
% Example
%   scope = databricks.Scope;
%   scope.scope = 'myScope';
%   scope.initial_manage_principal = 'users';
%   scope.create
%   Created scope: myScope

% Copyright 2020-2022 The MathWorks, Inc.

for oCount = 1:numel(obj)
    curObj = obj(oCount);

    % Initializations
    curAPI = 'secrets/scopes';
    apiMethod = 'create';
    curURI = obj.getURI(curAPI, apiMethod);

    % Create a request to create a secret scope
    request = curObj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.POST;

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(curObj);

    % Call Databricks
    resp = request.send(curURI, obj.HTTPOptions);
    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        disp(['Created scope: ', char(curObj.scope)]);
    else
        matlab.databricks.internal.responseError(resp, sprintf('Failed to create scope: %s', char(curObj.scope)));
    end
end

end
