function logMetric(obj, varargin)
    % LOGMETRIC Log a metric for a run.
    % A metric is a key-value pair (string key, float value) with an associated
    % timestamp.
    %
    % Examples include the various metrics that represent ML model accuracy and loss.
    % A metric can be logged multiple times. If a timestamp is not specified,
    % the current time is used.
    %
    % Example:
    %
    %     % Create a run
    %     mle = mlflow.Experiment.getByName('/Users/joe@example.com/MLFlowUnitTests');
    %     r = mle.createRun;
    %     r.user_id = 'joe';
    %     r.create();
    %
    %     % Log a metric at the current time
    %     r.logMetric('TrainingLoss',1e-6);
    %
    %     % Log a metric at a specific time
    %     r.logMetric('TrainingLoss',1e-6, 1643977759293);
    %
    %     Log a metric and also add a step size
    %     r.logMetric('TrainingLoss',1e-6, 1643977759293, 100);
    %
    % A mlflow.Metric object can be used to store the metrics;
    %
    %     % Create a metric
    %     metric = mlflow.Metric('now');
    %     metric.key = 'TrainingLoss';
    %     metric.value = 1e-6;
    %     r.logMetric(metric);
    %

    %  Copyright 2020-2022 MathWorks, Inc.


    % Create the request
    runURI = obj.getURI('runs', 'log-metric');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;

    % Parse the input arguments
    if nargin == 2 && isa(varargin{1},'mlflow.Metric')
        metric = varargin{1};
    elseif nargin > 2
        % Key
        S.key = varargin{1};
        S.value = varargin{2};

        if nargin > 3
            % Create payload
            S.timestamp = varargin{3};
        else
            S.timestamp = getCurrentTimeUnixINT64;
        end
        if nargin > 4
            S.step = varargin{4};
        end

        metric = mlflow.Metric(S);
    else
        error('mlflow:logmetric_argument_error', ...
            'Bad arguments for logMetric method. Please see help for correct usage');
    end

    payload = struct( ...
        'run_id',obj.run_id,...
        'key',metric.key,...
        'value',metric.value,...
        'timestamp',metric.timestamp, ...
        'step', metric.step);


    % Update the request with the payload
    request.Body.Payload = jsonencode(payload);

    % Call mlflow to log the parameter
    resp = request.send(runURI, getHTTPOptions);


    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        propNames = fieldnames(resp.Body.Data);
        if isempty(propNames)
            % Succeeded
        else
            error('MLFLOW:ERROR', 'Failed to log metric\n%s', char(resp));
        end
    else
        % Could not log metric
        error('MLFLOW:ERROR', 'Failed to log metric\n%s', char(resp));
    end

end %function
