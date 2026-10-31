function update(obj, status, end_time)
    % UPDATE Method to Update run metadata
    %
    % This method is used to change the current status of a run. The
    % possible status options can be found here:
    %    https://www.mlflow.org/docs/latest/rest-api.html#mlflowrunstatus
    %
    % Examples: R is an mlflow.Run object
    % % Using the current time (as posix int64)
    % R.update(mlflow.RunStatus.FINISHED)
    %
    % % Explicitly setting the time
    % R.update(mlflow.RunStatus.FINISHED, 1643877559257)
    %
    % % Using a string instead of the RunStatus class
    % R.update("RUNNING", 1643877559257)

    %  Copyright 2021-2022 MathWorks, Inc.

    % Get metadata
    if nargin < 3
        end_time = getCurrentTimeUnixINT64();
    end
    if ischar(status) || isstring(status)
        status = mlflow.RunStatus(status);
    end


    % Create the request
    runURI = obj.getURI('runs', 'update');
    request = obj.getRequestMessage('POST');
    request.Body = matlab.net.http.MessageBody;

    runData.run_id = obj.run_id;
    runData.end_time = end_time;
    runData.status = status;
    request.Body.Payload = jsonencode(runData);

    % Call MLflow API
    % Don't decode the json with the built in approach so that start & end time
    % can be explicitly converted to int64s
    resp = request.send(runURI, getHTTPOptions('ConvertResponse', false));
    allowMissing = true;
    resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"run_info", "start_time"}, "int64", {"run_info", "end_time"}, "int64"); %#ok<CLARRSTR>

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if ~isempty(fieldnames(resp.Body.Data))
            % We have a non-empty response
            obj.info = mlflow.RunInfo(resp.Body.Data.run_info);
        else
            % We have an empty response
            obj.info = mlflow.RunInfo();
        end
    else
        % Could not list runs
        error('MLFLOW:ERROR', 'Failed to refresh run');
    end

end %function
