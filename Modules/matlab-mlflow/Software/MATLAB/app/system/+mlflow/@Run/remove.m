function remove(obj, varargin)
% REMOVE Method to delete a run from an experiment
% Delete a run from the MLFlow experiment
% 
% Example:
%
%   % Create an experiment
%   mle = mlflow.Experiment;
%   mle.name = '/Users/username@example.com/PFTDemo';
%   mle.create();  % Creates an experiment
%   
%   % Create a run
%   runObj = mle.createRun();
%   runObj.create();    % Creates a run
%   runObj.remove();    % Deletes a run

%  (c) 2020-2022 MathWorks, Inc.

%% Remove the Experiment
clusterURI = obj.getURI('runs', 'delete');
request = obj.getRequestMessage('POST');

% Create the payload with the run_id
runData.run_id = obj.run_id;

% Configure the request
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(runData);

% Call mlflow to create the experiment
resp = request.send(clusterURI, getHTTPOptions);

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    disp(['Successfully deleted run with id: ',obj.run_id]); 
else 
    error('MLFLOW:ERROR', 'Failed to delete run: %s\n%s', obj.run_id, char(resp.Body.Data));
end

end %function
