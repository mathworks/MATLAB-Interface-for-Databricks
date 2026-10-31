function runs = list(options)
    % LIST List runs in databricks cluster
    %
    % This method lists runs in a Databricks cluster. It takes 6 optional
    % arguments:
    %  job_id - Only runs for a certain job (int64)
    %  active_only - Only active runs (logical)
    %  completed_only - Only completed runs (logical)
    %  offset - Needed for paging (see limit) (int32)
    %  limit - Maximum number to return (int32)
    %  run_type - what Databricks run_type to accept (string/char)
    %
    % Further information is available from Databricks, see
    %  https://docs.databricks.com/dev-tools/api/2.0/jobs.html#runs-list
    %
    % Examples:
    %  % Read 20 latest runs:
    %  runs = databricks.Run.list()
    %
    %  % Read only 5 runs:
    %  runs = databricks.Run.list(limit=5)
    %
    %  % Read 10 runs, starting at 100:
    %  runs = databricks.Run.list(offset=100,limit=10)
    %
    %  % Only read active runs
    %  runs = databricks.Run.list(active_only=true)
    
    % Copyright 2020-2026, The MathWorks, Inc.

    arguments
        options.job_id (1,1) int64
        options.active_only (1,1) logical = false
        options.completed_only (1,1) logical = false
        options.offset (1,1) int32
        options.limit (1,1) int32
        options.run_type string {mustBeTextScalar, mustBeMember(options.run_type, {'JOB_RUN', 'WORKFLOW_RUN', 'SUBMIT_RUN'})}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    obj = databricks.Run(args{:});

    if options.active_only && options.completed_only
        error('Databricks:ERROR', ...
            'active_only and completed_only cannot both be true at the same time')
    end
    args = {};
    if options.active_only
        args{end+1} = 'active_only';
        args{end+1} = 'true';
    end
    if options.completed_only
        args{end+1} = 'completed_only';
        args{end+1} = 'true';
    end
    args = matlab.utils.addArgs(options, ["job_id", "offset", "limit", "run_type"], args);

    listURI = obj.getURI('jobs/runs', 'list', args{:});

    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call databricks
    resp = request.send(listURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        R = mlflow.jsondecode(resp.Body.Data, true, ...
            {"runs", {':'}, "job_run_id"}, "int64", ...
            {"runs", {':'}, "job_id"}, "int64", ...
            {"runs", {':'}, "run_id"}, "int64", ...
            {"runs", {':'}, "number_in_job"}, "int64", ...
            {"runs", {':'}, "original_attempt_run_id"}, "int64", ...
            {"runs", {':'}, "start_time"}, "int64", ...
            {"runs", {':'}, "setup_duration"}, "int64", ...
            {"runs", {':'}, "execution_duration"}, "int64", ...
            {"runs", {':'}, "cleanup_duration"}, "int64", ...
            {"runs", {':'}, "end_time"}, "int64");

        runs = struct(...
            'runs', databricks.Run.empty, ...
            'has_more', R.has_more ...
            );
        if isfield(R, 'runs')
            for k=1:length(R.runs)
                if iscell(R.runs)
                    curRun = R.runs{k};
                else
                    curRun = R.runs(k);
                end
                RO = databricks.Run();
                RO.addStructureAsDynProps(curRun);
                runs.runs(k) = RO;
            end
        end

    else
        % Could not list jobs
        error('DATABRICKS:ERROR', 'Failed to list runs');
    end

end
