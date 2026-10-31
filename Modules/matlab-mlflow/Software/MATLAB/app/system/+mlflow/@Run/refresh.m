function refresh(obj, varargin)
    % REFRESH Method to get metadata for a run
    % Fetch metadata about a run.
    %
    % Example:
    %
    %   % Create an experiment
    %   mle = mlflow.Experiment;
    %   mle.name = '/Users/joe@example.com/myDemo';
    %   mle.create();  % Creates an experiment
    %
    %   % Create a run
    %   runObj = mle.createRun();
    %   runObj.create();       % Creates a run
    %   runObj.refresh();      % Refresh run metadata

    %   Copyright 2020-2022 MathWorks, Inc.

    % Get metadata
    clusterURI = obj.getURI('runs', 'get', 'run_id', obj.run_id);
    request = obj.getRequestMessage('GET');

    % Call MLflow API
    % Don't decode the json with the built in approach so that start & end time
    % can be explicitly converted to int64s
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));
    allowMissing = true;
    resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"run", {":"}, "info", "start_time"}, "int64", {"run", {":"}, "info", "end_time"}, "int64"); %#ok<STRSCALR>

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if ~isempty(fieldnames(resp.Body.Data))
            % We have a non-empty response
            expStruct = resp.Body.Data.run;

            obj.info = mlflow.RunInfo(expStruct.info);
            obj.data = mlflow.RunData(expStruct.data);

        else
            % We have an empty response
            obj = mlflow.Run.empty; %#ok<NASGU>
        end
    else
        % Could not list runs
        error('MLFLOW:ERROR', 'Failed to refresh run');
    end

end %function
