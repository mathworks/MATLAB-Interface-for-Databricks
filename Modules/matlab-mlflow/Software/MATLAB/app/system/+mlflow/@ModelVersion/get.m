function obj = get(name, version) %#ok<STOUT> 
% GET Get a specified model version
%
% name must be provided as a scalar string or character vector. It is the name of
% the registered model.
%
% version must be provided as a scalar string or character vector. It is the model
% version number.

%  (c) 2021-2022 MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    error('MLFLOW:ERROR', 'Expected name to be of type character vector or scalar string');
end
if ~(ischar(version) || isStringScalar(version))
    error('MLFLOW:ERROR', 'Expected value to be of type character vector or scalar string');
end

%% Create a new model version
clusterURI = obj.getURI('model-versions', 'get');
request = obj.getRequestMessage('GET');

payload.name = name;
payload.version = version;
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = payload;

% Call mlflow to create the model version
% Don't decode the json with the built in approach so that creation_timestamp & last_updated_timestamp
% can be explicitly converted to int64s
resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));
allowMissing = true;
resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"model_version", "creation_timestamp"}, "int64", {"model_version", "last_updated_timestamp"}, "int64");  %#ok<CLARRSTR>

% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    
    propNames = fieldnames(resp.Body.Data);
    if ~isempty(propNames)
        
        % Ensure that we have the model version response
        if isfield(resp.Body.Data,'model_version')
            % We have a non-empty response
            if isfield(resp.Body.Data.model_version, 'creation_timestamp')
                resp.Body.Data.model_version.creation_timestamp = datetime(resp.Body.Data.model_version.creation_timestamp, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
            end
            if isfield(resp.Body.Data.model_version, 'last_updated_timestamp')
                resp.Body.Data.model_version.last_updated_timestamp = datetime(resp.Body.Data.model_version.last_updated_timestamp, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
            end
            obj.addStructureAsDynProps(resp.Body.Data.model_version);
        else
            error('MLFLOW:ERROR', 'Failed to get model version\n%s', char(resp));
        end

    else
        error('MLFLOW:ERROR', 'Failed to get model version\n%s', char(resp));
    end
    
else
    % Could not get model version
    error('MLFLOW:ERROR', 'Failed to get model version\n%s', char(resp));
end

end %function