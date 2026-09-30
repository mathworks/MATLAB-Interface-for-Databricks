function restore(obj, varargin)
% RESTORE Method to restore an experiment marked for deletion 
% This restores associated metadata, runs, metrics, params, and tags. If 
% experiment uses FileStore, underlying artifacts associated with 
% experiment are also restored.

%  (c) 2020-2021 MathWorks, Inc.

%% Restore the Experiment
clusterURI = obj.getURI('experiments', 'restore');
request = obj.getRequestMessage('POST');

% Create the payload with the experiment_id
experimentData.experiment_id = obj.experiment_id;

% Configure the request
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(experimentData);

% Call mlflow to restore the experiment
resp = request.send(clusterURI, getHTTPOptions);

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    disp(['Successfully restored experiment with id: ',obj.experiment_id]); 
else 
    error('MLFLOW:ERROR','Failed to restore experiment: %s\n%s', obj.cluster_name, char(resp.Body.Data));
end


end %function
