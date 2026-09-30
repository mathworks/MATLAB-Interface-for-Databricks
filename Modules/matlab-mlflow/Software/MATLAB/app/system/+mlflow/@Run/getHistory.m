function metrics = getHistory(obj, metric)
    % GETHISTORY Retrieve history of a metric from a run
    %
    % Example:
    %
    %   % Retrieve a Run
    %   RS = mlflow.Run.search('1', '');
    %   metrics = RS.getHistory()

    %   Copyright 2020-2022 MathWorks, Inc.

    % Get metadata
    clusterURI = obj.getURI('metrics', 'get-history', ...
        'run_id', obj.run_id, 'metric_key', metric);
    request = obj.getRequestMessage('GET');

    % Call MLflow API
    % Don't decode the json with the built in approach so that start & end time
    % can be explicitly converted to int64s
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;
        Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"metrics", {":"}, "timestamp"}, "int64", {"metrics", {":"}, "step"}, "int64"); %#ok<STRSCALR>

        numMetrics = length(Data.metrics);
        for k=numMetrics:-1:1
            metrics(k) = mlflow.Metric(Data.metrics(k));
        end

    else
        % Could not list runs
        error('MLFLOW:ERROR', 'Failed to retrieve history for metric %s', metric);
    end

end %function
