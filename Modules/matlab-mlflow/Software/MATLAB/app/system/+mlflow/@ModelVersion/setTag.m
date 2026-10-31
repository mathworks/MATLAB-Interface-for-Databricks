function obj = setTag(obj, name, version, key, value)
% SETTAG Set a Model Version tag
%
% name must be provided as a scalar string or character vector, it represents
% the unique name of the model.
%
% version must be provided as a scalar string or character vector, it represents
% the model version number.
%
% key must be provided as a scalar string or character vector, it represents
% the name of the tag. Maximum size depends on storage backend. If a tag with
% this name already exists, its preexisting value will be replaced by the
% specified value. All storage backends are guaranteed to support key values up
% to 250 bytes in size.
%
% value must be provided as a scalar string or character vector, it represents
% the string value of the tag being logged. Maximum size depends on storage
% backend. All storage backends are guaranteed to support key values up to 5000
% bytes in size.

%  (c) 2021-2022 MathWorks, Inc.

% Validate input
if ~(ischar(run_id) || isStringScalar(name))
    error('MLFLOW:ERROR', 'Expected name to be of type character vector or scalar string');
end
if ~(ischar(version) || isStringScalar(version))
    error('MLFLOW:ERROR', 'Expected version to be of type character vector or scalar string');
end
if ~(ischar(key) || isStringScalar(key))
    error('MLFLOW:ERROR', 'Expected key to be of type character vector or scalar string');
end
if ~(ischar(value) || isStringScalar(value))
    error('MLFLOW:ERROR', 'Expected value to be of type character vector or scalar string');
end


if ~isprop(obj,'tags')
    % model version not initialized
    obj.tags = mlflow.ModelVersionTag.empty();
end

mvTag = mlflow.ModelVersionTag;
mvTag.key = key;
mvTag.value = value;

obj.tags(end+1) = mvTag;

%% Create a new tag on an experiment 
clusterURI = obj.getURI('model-versions', 'set-tag');
request = obj.getRequestMessage('POST');

% Create the request
request.Body = matlab.net.http.MessageBody;

payload.name = name;
payload.version = version;
payload.key = mvTag.key;
payload.value = mvTag.value;
request.Body.Payload = jsonencode(payload);

% Call mlflow to attach the metadata
resp = request.send(clusterURI, getHTTPOptions);

% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    propNames = fieldnames(resp.Body.Data);
    if isempty(propNames)
        % Succeeded no response fields expected
    else
        error('MLFLOW:ERROR', 'Failed to set tag\n%s', char(resp));
    end
else
    % Could not set tag
    error('MLFLOW:ERROR', 'Failed to set tag\n%s', char(resp));
end

end %function