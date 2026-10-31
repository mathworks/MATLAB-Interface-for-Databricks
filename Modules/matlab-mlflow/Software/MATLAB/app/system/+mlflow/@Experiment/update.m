function update(obj, namestr, varargin)
% UPDATE Method to update experiment metadata
% 
% This method can be used to update the name of an experiment. 
%
% Example:
% 
%   mle = mlflow.Experiment.list;
%   experimentHandle = mle(1);
%   experimentHandle.update('/Users/username@example.com/myNewExperiment')

%  (c) 2020-2022 MathWorks, Inc.

%% Update the Experiment
clusterURI = obj.getURI('experiments', 'update');
request = obj.getRequestMessage('POST');

% Create the payload with the experiment_id
experimentData.experiment_id = obj.experiment_id;
experimentData.new_name = namestr;

% Configure the request
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(experimentData);

% Call mlflow to update the experiment
resp = request.send(clusterURI, getHTTPOptions);

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Update the name
    obj.name = namestr;
    
    % Valid response so package and send back to user
    disp(['Successfully updated experiment with id: ',obj.experiment_id]); 
else 
    error('MLFLOW:ERROR', 'Failed to update experiment: %s\n%s', obj.cluster_name, char(resp.Body.Data));
end

end %function
