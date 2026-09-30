function logParameter(obj, key, value)
    % LOGPARAMETER Log a parameter for a run. Specified as a key value pair.
    %
    % Example:
    %
    %   % Create a run
    %   r = mlflow.Run;
    %   r.start_time = int64(posixtime(datetime('now','TimeZone','local'))*1e3);
    %   r.user_id = 'joe'
    %   r.create();
    %
    %   % Log a parameter
    %   r.logParameter('mykey','myval');

    %   Copyright 2020-2022 MathWorks, Inc.

    %% Create a new Experiment
    runURI = obj.getURI('runs', 'log-parameter');
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;
    payload.run_id = obj.run_id;
    payload.key = key;
    payload.value = value;
    request.Body.Payload = jsonencode(payload);

    % Call mlflow to log the parameter
    resp = request.send(runURI, getHTTPOptions);


    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        propNames = fieldnames(resp.Body.Data);
        if isempty(propNames)
            % Succeeded
        else
            error('MLFLOW:ERROR', 'Failed to log parameter\n%s', char(resp));
        end
    else
        % Could not create run
        error('MLFLOW:ERROR', 'Failed to log parameter\n%s', char(resp));
    end

end %function
