function waitForJob(jobId, options)
    % WAITFORJOB Wait for a job to complete
    %
    % JobId argument is required and should be of type int64.
    %
    % An optional timeout named argument can be provided.
    % The timeout value is measured in seconds and should be of type int32.
    % The default timeout is one hour. If the timeout is exceeded an error is
    % thrown.
    %
    % Possible Job run life_cycle_state values are:
    %   PENDING
    %   The run has been triggered. If there is not already an active run of the
    %   same job, the cluster and execution context are being prepared. If there
    %   is already an active run of the same job, the run will immediately
    %   transition into the SKIPPED state without preparing any resources.
    %  
    %   RUNNING
    %   The task of this run is being executed.
    %  
    %   TERMINATING
    %   The task of this run has completed, and the cluster and execution context
    %   are being cleaned up.
    %  
    %   TERMINATED
    %   The task of this run has completed, and the cluster and execution context
    %   have been cleaned up. This state is terminal.
    %  
    %   SKIPPED
    %   This run was aborted because a previous run of the same job was already
    %   active. This state is terminal.
    %  
    %   INTERNAL_ERROR
    %   An exceptional state that indicates a failure in the Jobs service, such
    %   as network failure over a long period. If a run on a new cluster ends in
    %   the INTERNAL_ERROR state, the Jobs service terminates the cluster as soon
    %   as possible. This state is terminal.
    %
    % The optional named argument targetState can be set to "RUNNING" or "SUCCESS".
    % The default is RUNNING. If set to RUNNING the function returns  when the job
    % enters a RUNNING state or successfully terminates. When set to SUCCESS the
    % function returns only on successfully termination.
    % 
    % Other states are handled as follows:
    %
    % If the TERMINATING, SKIPPED or INTERNAL_ERROR states are entered an error is
    % thrown.
    %
    % If TERMINATED with result_state not equal to SUCCESS is entered and error is
    % thrown.
    %
    % If PENDING is entered the function waits for a state change or until the time out.
    %
    % Example:
    %   databricks.internal.job.waitForJob(jobId, targetState="SUCCESS");

    %  Copyright 2023-2026 MathWorks, Inc.
    
    arguments
        jobId int64 {mustBeFinite, mustBeReal}
        options.targetState string {mustBeTextScalar, mustBeMember(options.targetState, {'RUNNING', 'SUCCESS'})} = 'RUNNING'
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 60*60
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if options.verbose
        fprintf("Waiting for job: %u\n", jobId);
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    jobRun = databricks.Run.list('job_id', jobId, args{:});
    if ~isscalar(jobRun.runs)
        error("DATABRICKS:waitForJob", "Found more than one job run with id: %d", job.job_id);
    end

    jobRun = jobRun.runs;
    startTime = jobRun.start_time;
    startTime.TimeZone = "UTC";
    maxWait = seconds(options.timeout);

    while true
        state = jobRun.state;

        switch state.life_cycle_state
            case 'PENDING'
                % Do noting wait some more

            case 'RUNNING'
                if strcmp(options.targetState, "RUNNING")
                    % All went well, exiting.
                    if options.verbose
                        fprintf("Job running: %u\n", jobId);
                    end
                    return;
                end
                % Do nothing wait for SUCCESS or failure
            
            case 'TERMINATING'
                disp(jsonencode(jobRun, PrettyPrint=true));
                error("DATABRICKS:waitForJob", "Job terminating: %u", jobId);

            case 'TERMINATED'
                if "SUCCESS" == string(state.result_state)
                    % All went well, exiting.
                    if options.verbose
                        fprintf("Job completed successfully: %u\n", jobId);
                    end
                    % Job ran successfully so even if target state was RUNNING
                    % consider this okay and return.
                    return;
                else
                    % Output the run for debug
                    disp(jsonencode(jobRun, PrettyPrint=true));
                    error("DATABRICKS:waitForJob", "Job terminated with a failure: %u", jobId);
                end

            case 'SKIPPED'
                disp(jsonencode(jobRun, PrettyPrint=true));
                error("DATABRICKS:waitForJob", "Job skipped: %u", jobId);
    
            case 'INTERNAL_ERROR'
                disp(jsonencode(jobRun, PrettyPrint=true));
                error("DATABRICKS:waitForJob", "Job terminated with an internal failure: %u", jobId);
        end

        pause(10); % Wait between polling the the API for state update
        jobRun = jobRun.get;
        now = datetime("now", "TimeZone", "UTC");
        elapsed = seconds(seconds(now-startTime));
        if mod(elapsed, 60) == 0
            if options.verbose
                fprintf('Elapsed time: %s (timeout: %s)\n', string(elapsed), string(maxWait));
            end
        end
        if elapsed > maxWait
            fprintf('Elapsed time: %s (timeout: %s)\n', string(elapsed), string(maxWait));
            disp(jsonencode(jobRun, PrettyPrint=true));
            error("DATABRICKS:waitForJob", "Wait timed out: %u", jobId);
        end
    end
end