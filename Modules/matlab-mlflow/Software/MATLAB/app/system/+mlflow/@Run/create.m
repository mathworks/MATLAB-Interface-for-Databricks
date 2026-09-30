function create(obj, varargin)
    % CREATE Method to create a run in a particular run in an experiment
    % Create a particular run in an experiment
    %
    % If the start_time is not defined, then the run will assume the current
    % time as specified by the computers local timezone setting.
    %
    % To configure the start_time, specify the time as an int64 in milliseconds.
    %
    % Example:
    %
    %   r = mlflow.Run;
    %   r.start_time = int64(posixtime(datetime('now','TimeZone','local'))*1e3);
    %

    %   Copyright 2020-2022 MathWorks, Inc.

    % Create a new Run
    clusterURI = obj.getURI('runs', 'create');
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload;

    % Call mlflow to create the experiment
    % Don't decode the json with the built in approach so that start & end time
    % can be explicitly converted to int64s
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;
        resp.Body.Data = mlflow.jsondecode( ...
            resp.Body.Data, allowMissing, ...
            {"run", "info", "start_time"}, "int64", ...
            {"run", "info", "end_time"}, "int64");  %#ok<CLARRSTR>

        propNames = fieldnames(resp.Body.Data);
        if ~isempty(propNames)

            % Ensure that we have the run response
            if isfield(resp.Body.Data,'run')
                % We have a non-empty response

                obj.info = mlflow.RunInfo(resp.Body.Data.run.info);
                obj.data = mlflow.RunData(resp.Body.Data.run.data);

            else
                error('MLFLOW:ERROR', 'Failed to create run\n%s', char(resp));
            end

        else
            error('MLFLOW:ERROR', 'Failed to create run\n%s', char(resp));
        end
    else
        % Could not create run
        error('MLFLOW:ERROR', 'Failed to create run\n%s', char(resp));
    end

end %function
