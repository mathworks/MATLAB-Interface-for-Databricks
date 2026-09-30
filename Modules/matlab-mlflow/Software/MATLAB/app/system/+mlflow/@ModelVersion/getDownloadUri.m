function uri = getDownloadUri(name, version)
% GETDOWNLOADURI Get Download URI For ModelVersion Artifacts
%
% name must be provided as a scalar string or character vector. It is the name of
% the registered model.
%
% version must be provided as a scalar string or character vector. It is the model
% version number.
%
% The download uri to be returned as a character vector.


%  (c) 2021-2022 MathWorks, Inc.


if ~(ischar(name) || isStringScalar(name))
    error('MLFLOW:ERROR', 'Expected name to be of type character vector or scalar string');
end
if ~(ischar(version) || isStringScalar(version))
    error('MLFLOW:ERROR', 'Expected value to be of type character vector or scalar string');
end

clusterURI = obj.getURI('model-versions', 'get-download-uri');
request = obj.getRequestMessage('POST');

payload.name = name;
payload.version = version;
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = payload;

resp = request.send(clusterURI, getHTTPOptions());

% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    
    propNames = fieldnames(resp.Body.Data);
    if ~isempty(propNames)
        
        % Ensure that we have the model version response
        if isfield(resp.Body.Data,'artifact_uri')
            if ischar(resp.Body.Data.artifact_uri)
                uri = resp.Body.Data.artifact_uri;
            else
                error('MLFLOW:ERROR', 'Expected download uri to be returned as a character vector\n%s', char(resp));
            end
        else
            error('MLFLOW:ERROR', 'Failed to get download uri\n%s', char(resp));
        end

    else
        error('MLFLOW:ERROR', 'Failed to get download uri\n%s', char(resp));
    end
    
else
    % Could not get download uri
    error('MLFLOW:ERROR', 'Failed to get download uri\n%s', char(resp));
end

end
