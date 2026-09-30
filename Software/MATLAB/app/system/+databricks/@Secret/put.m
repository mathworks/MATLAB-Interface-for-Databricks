function put(obj)
% PUT Put a secret in the provided scope with the given name
% This method supports vectorization. The key must consist of alphanumeric
% characters, dashes, underscores and periods only and cannot exceed 128
% characters. The maximum allowed secret value size is 128KB.
% The maximum number of secrets in a given scope is 1000. The secret value may
% be a character vector or byte array of type uint8.
%
% Example
%   secret = databricks.Secret;
%   secret.scope = 'myScope';
%   secret.key = 'myKey';
%   secret.value = 'mySecretValue';
%   secret.put
%   Put secret:  myScope : myKey
%
% If a secret object's value property is of type character vector the resulting
% value will be stored in UTF-8 format. If the value is of type unit8 the value
% is stored as a byte value other. Otherwise the method will error.

% Copyright 2020-2026 The MathWorks, Inc.

for oCount = 1:numel(obj)
    curObj = obj(oCount);

    % Initializations
    curAPI = 'secrets';
    apiMethod = 'put';
    curURI = obj.getURI(curAPI, apiMethod);

    % Create a request to create a secret scope
    request = curObj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.POST;

    request.Body = matlab.net.http.MessageBody;
    s = struct;
    if isempty(curObj.scope)
        error('DATABRICKS:ERROR','Secret scope not set');
    else
        s.scope = curObj.scope;
    end
    if isempty(curObj.key)
        error('DATABRICKS:ERROR','Secret key not set');
    else
        s.key = curObj.key;
    end
    if ischar(curObj.value)
        s.string_value = curObj.value;
    elseif isa(curObj.value, 'uint8')
        s.bytes_value = curObj.value;
    else
        error('DATABRICKS:ERROR','Secret value must be of type uint8 or character vector');
    end
    request.Body.Payload = jsonencode(s);

    % Call Databricks
    resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        fprintf("Put secret:  %s, : %s\n", curObj.scope, curObj.key);
    else
        matlab.databricks.internal.responseError(resp, sprintf('Failed to put secret: %s : %s', char(curObj.scope), char(curObj.key)));
    end
end

end
