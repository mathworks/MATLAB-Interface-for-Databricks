function cancel(obj, runId)
    % CANCEL Cancel a job run
    %
    % Because the run is canceled asynchronously, the run may still be running
    % when this request completes. The run will be terminated shortly.
    % If the run is already in a terminal life_cycle_state, this method
    % does nothing.
    %
    % Examples:
    %
    %   runObj = job.runNow()
    %   runObj.cancel()
    %
    %   Or:
    %
    %   runObj = databricks.Run()
    %   runObj.cancel(123456)
    %
    % If a run does not exist an error is thrown.

    % Copyright 2022-2026, The MathWorks, Inc.

    if nargin < 2
        if isprop(obj, 'run_id')
            runId = obj.run_id;
        else
            error('DATABRICKS:ERROR', ...
                'The Run object must have a "run_id" property, or one must be added as an argument.');
        end
    end
    
    getURI = obj.getURI('jobs/runs', 'cancel');
    
    request = obj.getRequestMessage("POST");
    
    request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');

    request.Body = matlab.net.http.MessageBody();
    request.Body.Payload = jsonencode(struct('run_id', runId));
    
    % Call databricks
    resp = request.send(getURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Run cancelled
    elseif resp.StatusCode == matlab.net.http.StatusCode.BadRequest % 400.
        if isfield(resp.Body.Data, 'error_code')
            fprintf("error_code: %s\n", resp.Body.Data.error_code)
        end
        if isfield(resp.Body.Data, 'message')
            fprintf("message: %s\n", resp.Body.Data.message)
        end
        error('DATABRICKS:ERROR', 'Invalid parameter: %u', runId);
    else
        % Unexpected error
        error('DATABRICKS:ERROR', 'Failed to cancel run: %u', runId);
    end
end
