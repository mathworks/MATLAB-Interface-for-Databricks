function remove(obj, varargin)
% REMOVE Method to delete an experiment
% Delete an experiment from the MLFlow tracking server. 
% 
%   mle = mlflow.Experiment;
%   mle.create();  % Creates an experiment
%   mle.remove();  % Deletes an experiment

%  (c) 2020-2022 MathWorks, Inc.

%% Remove the Experiment
clusterURI = obj.getURI('experiments', 'delete');
request = obj.getRequestMessage('POST');

% Create the payload with the experiment_id
experimentData.experiment_id = obj.experiment_id;

% Configure the request
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(experimentData);

% Call mlflow to create the experiment
resp = request.send(clusterURI, getHTTPOptions);


%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    disp(['Successfully deleted experiment with id: ',obj.experiment_id]); 
else
    msg = '';
    if isfield(resp.Body.Data, 'error_code')
        msg = [' error_code: ', char(resp.Body.Data.error_code)];
    end
    if isfield(resp.Body.Data, 'message')
        msg = [msg, ' message: ', char(resp.Body.Data.message)];
    end
    error('MLFLOW:ERROR','Failed to delete experiment: %s\n%s', obj.experiment_id, msg);
end

end %function
