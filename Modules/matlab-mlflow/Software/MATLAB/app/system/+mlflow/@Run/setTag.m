function obj = setTag(obj, key, value)
    % SETTAG Set a tag on a run.
    % Tags are run metadata that can be updated during a run and after a run completes.
    %
    % The object on which this method is called must be a 'real run', i.e.
    % either created through the API, or retrieved using a search method.
    % The run_id of this object will be used to specify on which run the
    % tag will be set.
    %
    % key must be provided as a scalar string or character vector. It is the maximum
    % size depends on storage backend. All storage backends are guaranteed to support
    % key values up to 250 bytes in size.
    %
    % value must be provided as a scalar string or character vector. It is the value
    % of the tag being logged. Maximum size depends on storage backend. All storage
    % backends are guaranteed to support key values up to 5000 bytes in size.
    %
    % The run_uuid field is deprecated and not support use run_id instead.

    %  (c) 2021-2022 MathWorks, Inc.

    % Validate input
    if ~(ischar(key) || isStringScalar(key))
        error('MLFLOW:ERROR', 'Expected key to be of type character vector or scalar string');
    end
    if ~(ischar(value) || isStringScalar(value))
        error('MLFLOW:ERROR', 'Expected value to be of type character vector or scalar string');
    end

    % Create a new tag on a run
    clusterURI = obj.getURI('runs', 'set-tag');
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;

    payload.run_id = obj.run_id;
    payload.key = key;
    payload.value = value;
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