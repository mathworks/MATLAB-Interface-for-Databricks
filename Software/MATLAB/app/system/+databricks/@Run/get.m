function obj = get(obj, runId)
    % GET Returns the metadata of a Job run
    %
    % Can be called using a previously retrieved/created Run object, in
    % which case it will use this Run object's 'run_id'. 
    %   % job is a databricks.Job
    %   runObj = job.runNow()
    %   runObj.get()
    %
    % A run_id can also be used with a newly created Run object
    %   runObj = databricks.Run()
    %   runObj.get(12345)

    % Copyright 2020-2026, The MathWorks, Inc.

    if nargin < 2
        if isprop(obj, 'run_id')
            runId = obj.run_id;
        else
            error('DATABRICKS:ERROR', ...
                'The Run object must have a "run_id" property, or one must be added as an argument.');
        end
    end

    getURI = obj.getURI('jobs/runs', 'get', 'run_id', char(sprintf("%u", runId)));
    request = obj.getRequestMessage("GET");

    % Call databricks
    resp = request.send(getURI, obj.HTTPOptions);


    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        tmp = jsondecode(resp.Body.Data); % hack to check if there is runs[] or not
        if isfield(tmp, 'runs')
            R = mlflow.jsondecode(resp.Body.Data, true, ...
                {"runs", {':'}, "job_id"}, "int64", ...
                {"runs", {':'}, "run_id"}, "int64", ...
                {"runs", {':'}, "number_in_job"}, "int64", ...
                {"runs", {':'}, "original_attempt_run_id"}, "int64", ...
                {"runs", {':'}, "start_time"}, "int64", ...
                {"runs", {':'}, "setup_duration"}, "int64", ...
                {"runs", {':'}, "execution_duration"}, "int64", ...
                {"runs", {':'}, "cleanup_duration"}, "int64", ...
                {"runs", {':'}, "end_time"}, "int64");
        else
            R = mlflow.jsondecode(resp.Body.Data, true, ...
                {"job_id"}, "int64", ...
                {"run_id"}, "int64", ...
                {"number_in_job"}, "int64", ...
                {"original_attempt_run_id"}, "int64", ...
                {"start_time"}, "int64", ...
                {"setup_duration"}, "int64", ...
                {"execution_duration"}, "int64", ...
                {"cleanup_duration"}, "int64", ...
                {"end_time"}, "int64"); %#ok<*STRSCALR> 
        end
        addStructureAsDynProps(obj, R);

    else
        % Could not get run
        disp('Message Body: ');
        disp(resp.Body.Data);
        error('DATABRICKS:ERROR', 'Failed to get run: %u', runId);
    end
end