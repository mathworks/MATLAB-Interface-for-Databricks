function exp = getByName(experimentName, varargin)
% GETBYNAME Method to get the metadata for an experiment by name
% This endpoint will return deleted experiments, but prefers the active 
% experiment if an active and deleted experiment share the same name. If 
% multiple deleted experiments share the same name, the API will return 
% one of them.
% 
% Example:
% 
%   mle = mlflow.Experiment.getByName('/Users/joe@example.com/test-experiment');
% 
% This will throw a RESOURCE_DOES_NOT_EXIST error if no experiment with the 
% specified name exists.

%  (c) 2020-2022 MathWorks, Inc.

% Create an experiment
exp = mlflow.Experiment;

% Get metadata
clusterURI = exp.getURI('experiments', 'get-by-name', 'experiment_name', experimentName);
request = exp.getRequestMessage('GET');

% Call backend
% TODO add start_time end_time int64 fix
resp = request.send(clusterURI, getHTTPOptions);

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    
    if ~isempty(fieldnames(resp.Body.Data))
        % We have a non-empty response
        exp = mlflow.Experiment.initFromStruct(resp.Body.Data.experiment);
    else
        % We have an empty response
        exp = [];
    end
    
else
    % Could not list experiment of that name
    if resp.StatusCode==matlab.net.http.StatusCode.NotFound
        error('MLFLOW:ERROR:NOTFOUND','Could not find experiment named: %s', experimentName);
    else
        % Some other error
        error('MLFLOW:ERROR', 'Failed to fetch experiment');
    end
end

end %function
