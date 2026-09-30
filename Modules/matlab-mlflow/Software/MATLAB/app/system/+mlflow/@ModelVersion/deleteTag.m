function obj = deleteTag(~, name, version, key)
% DELETETAG Delete a tag on a model version
%
% name must be provided as a scalar string or character vector, it represents
% name of the registered model that the tag was logged under.
%
% version must be provided as a scalar string or character vector, it represents
% the model version number that the tag was logged under.
%
% key must be provided as a scalar string or character vector. It is the name of
% the tag. The name must be an exact match; wild-card deletion is not supported.
% Maximum size is 250 bytes.

%  (c) 2021-2022 MathWorks, Inc.

% Validate input
if ~(ischar(name) || isStringScalar(name))
    error('MLFLOW:ERROR', 'Expected name to be of type character vector or scalar string');
end
if ~(ischar(version) || isStringScalar(version))
    error('MLFLOW:ERROR', 'Expected version to be of type character vector or scalar string');
end
if ~(ischar(key) || isStringScalar(key))
    error('MLFLOW:ERROR', 'Expected key to be of type character vector or scalar string');
end

% Search API endpoint
obj = mlflow.Run;
clusterURI = obj.getURI('model-versions', 'delete-tag');

% Create the request
request = obj.getRequestMessage('POST');

% Create the request
request.Body = matlab.net.http.MessageBody;
payload.name = name;
payload.version = version;
payload.key = key;
request.Body.Payload = jsonencode(payload);

% Call MLflow endpoint
resp = request.send(clusterURI, getHTTPOptions);

% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    
    propNames = fieldnames(resp.Body.Data);
    if isempty(propNames)
        % Succeeded
    else
        error('MLFLOW:ERROR', 'Failed to delete tag\n%s', char(resp));
    end
else
    % Could not delete tag
    error('MLFLOW:ERROR', 'Failed to delete tag\n%s', char(resp));
end

end %function