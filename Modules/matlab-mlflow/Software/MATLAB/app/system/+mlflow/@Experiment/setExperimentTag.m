function setExperimentTag(obj, key, value, varargin)
% SETEXPERIMENTTAG Method to set a tag on an experiment
% Experiment metadata can be attached to an experiment using this method.
%
% Example:
%   mle = mlflow.Experiment;
%   mle.setExperimentTag('key','value');

%   (c) 2020-2022 MathWorks, Inc.

if ~(ischar(key) || isStringScalar(key))
    error('MLFLOW:ERROR', 'Expected key to be of type character vector or scalar string');
end
if ~(ischar(value) || isStringScalar(value))
    error('MLFLOW:ERROR', 'Expected value to be of type character vector or scalar string');
end

if ~isprop(obj,'tags')
    % experiment not initialized
    obj.tags = mlflow.ExperimentTag.empty();
end

% TODO move to using Experiment Tag type in structs
% % Setup the tag
% rTag = mlflow.ExperimentTag;
% rTag.key = key;
% rTag.value = value;
% 
% % Append the tag
% obj.tags(end+1) = rTag;
% For now just adding into the struct
obj.tags(end+1).key = key;
obj.tags(end).value = value;

%% Create a new tag on an experiment 
clusterURI = obj.getURI('experiments', 'set-experiment-tag');
request = obj.getRequestMessage('POST');
    
% Create the request
request.Body = matlab.net.http.MessageBody;

payload.experiment_id = obj.experiment_id;
payload.key = obj.tags(end).key;
payload.value = obj.tags(end).value;
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
    % Could not create tag
    error('MLFLOW:ERROR', 'Failed to create tag\n%s', char(resp));
end

end %function
