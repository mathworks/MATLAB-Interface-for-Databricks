function create(obj, varargin)
    % CREATE Method to create an experiment with a name
    % Returns the ID of the newly created experiment. Validates that another
    % experiment with the same name does not already exist and fails if another
    % experiment with the same name already exists.
    %
    % An experiment name must be an absolute path within the MLFlow
    % workspace, for example:
    %
    % '/Users/<some-username>/my-experiment'.
    %
    % For more information on how to use this method when using Databricks,
    % Please see:
    % [1] https://docs.databricks.com/applications/mlflow/experiments.html#experiment-migration
    % [2] https://mlflow.org/docs/latest/rest-api.html#create-experiment

    %  (c) 2020-2022 MathWorks, Inc.

    %% Create a new Experiment
    clusterURI = obj.getURI('experiments', 'create');
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload;

    % Call mlflow to create the experiment
    resp = request.send(clusterURI, getHTTPOptions);


    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
            % A non-empty response
            obj.initFromStructInternal(resp.Body.Data);
    else
        % Could not create experiment
        error('MLFLOW:ERROR', 'Failed to create experiment\n%s', char(resp));
    end

end %function
