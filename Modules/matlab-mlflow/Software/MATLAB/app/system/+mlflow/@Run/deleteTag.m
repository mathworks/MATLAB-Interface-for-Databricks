function obj = deleteTag(obj, run_id, key)
% DELETETAG Delete a tag on a run
% Tags are run metadata that can be updated during a run and after a run completes.
%
% run_id must be provided as a scalar string or character vector, it represents
% the ID of the run that the tag was logged under.
%
% key must be provided as a scalar string or character vector.It is the name of 
% the tag. Maximum size is 255 bytes. 

%  (c) 2021 MathWorks, Inc.

% Validate input
if ~(ischar(run_id) || isStringScalar(run_id))
    error('MLFLOW:ERROR', 'Expected run_id to be of type character vector or scalar string');
end
if ~(ischar(key) || isStringScalar(key))
    error('MLFLOW:ERROR', 'Expected key to be of type character vector or scalar string');
end

% Search API endpoint
obj = mlflow.Run;
clusterURI = obj.getURI('runs', 'delete-tag');

% Create the request
request = obj.getRequestMessage('POST');

% Create the request
request.Body = matlab.net.http.MessageBody;
payload.run_id = run_id;
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
    % Could not delte tag
    error('MLFLOW:ERROR', 'Failed to delete tag\n%s', char(resp));
end

end %function