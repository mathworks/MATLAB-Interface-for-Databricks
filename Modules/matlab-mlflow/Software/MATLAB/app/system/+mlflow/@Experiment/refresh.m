function refresh(obj)
    % REFRESH Method to get metadata for an experiment
    % Fetch metadata about an experiment. This method also works on
    % deleted experiments.

    %  Copyright 2020-2022 MathWorks, Inc.

    % Get metadata
    clusterURI = obj.getURI('experiments', 'get', 'experiment_id', obj.experiment_id);
    request = obj.getRequestMessage('GET');

    % Call mlflow
    resp = request.send(clusterURI, getHTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        if ~isempty(fieldnames(resp.Body.Data))
            % We have a non-empty response
            obj.initFromStructInternal(resp.Body.Data.experiment);

        else
            % We have an empty response
            warning('MLFLOW:no_refresh_data', 'No data was returned from refresh call');
        end

    else
        % Could not list experiments
        error('MLFLOW:ERROR', 'Failed to refresh experiment');
    end

end %function
