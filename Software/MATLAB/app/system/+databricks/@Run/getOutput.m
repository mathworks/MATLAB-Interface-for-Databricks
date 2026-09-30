function output = getOutput(obj, runId)
    % GETOUTPUT Retrieve the output and metadata of a single task run
    %
    % This function returns metadata for a Job run, corresponding to a Run
    % object. I can also return details of run errors in an error and or
    % error_trace field.
    %
    % If a run produces notebook output this is returned in a field called
    % notebook_output as a NotebookOutput object.
    %
    % Examples:
    %   % Using an existing Run object, in which case it's 'run_id' is
    %   % queried
    %   runObj = job.runNow()
    %   % export can now be called to retrieve the views of this Run
    %   % object.
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


    obj = databricks.Run();

    getURI = obj.getURI('jobs/runs', 'get-output', 'run_id', char(sprintf("%u", runId)));
    request = obj.getRequestMessage("GET");

    % Call databricks
    resp = request.send(getURI, obj.HTTPOptions);

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        result = mlflow.jsondecode(resp.Body.Data, true, ...
            {"metadata", {':'}, "job_id"}, "int64", ...
            {"metadata", {':'}, "run_id"}, "int64", ...
            {"metadata", {':'}, "number_in_job"}, "int64", ...
            {"metadata", {':'}, "original_attempt_run_id"}, "int64", ...
            {"metadata", {':'}, "start_time"}, "int64", ...
            {"metadata", {':'}, "setup_duration"}, "int64", ...
            {"metadata", {':'}, "execution_duration"}, "int64", ...
            {"metadata", {':'}, "cleanup_duration"}, "int64", ...
            {"metadata", {':'}, "end_time"}, "int64");

        output = struct;
        if isfield(result, 'metadata')
            addStructureAsDynProps(obj, result.metadata);
            output.metadata = obj;
        else
            error('DATABRICKS:Run:getOutput', 'No metadata found in response');
        end

        if isfield(result, 'notebook_output')
            output.notebook_output = databricks.datastructures.NotebookOutput();
            if isfield(result.notebook_output, "result")
                output.notebook_output.result = string(result.notebook_output.result);
            end
            if isfield(result.notebook_output, "truncated")
                output.notebook_output.truncated = result.notebook_output.truncated;
            end
        end

        if isfield(result, 'error')
            output.error = string(result.error);
        end

        if isfield(result, 'error_trace')
            output.error_trace = string(result.error_trace);
        end

    else
        % Could not get run
        if strlength(resp.Body.Data) > 0
            fprintf("Error: %s\n", jsonencode(resp.Body.Data, PrettyPrint=true));
        end
        error('DATABRICKS:Run:getOutput', 'Failed to get run output: %u', runId);
    end
end