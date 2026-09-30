function waitForRunStatus(jobRun)
    % waitForRunStatus Wait for job lifecycle to end and reports status

    arguments
        jobRun (1,1) databricks.Run
    end

    if ~isprop(jobRun, 'run_id')
        disp(jobRun);
        error('DATABRICKS:INSTALL', 'Expected run_id property not found');
    end
    runId = jobRun.run_id;
    done = false;
    oldLength = 0;
    while ~done % breaks on SUCCESS, TERMINATED or FAILED
        runData = jobRun.get();
        runState = runData.state;
        t1 = runData.start_time;
        t2 = datetime("now", "TimeZone", "UTC");
        t2.TimeZone = "";
        delta = t2-t1;
        
        if strlength(runState.state_message) == 0
            statMsg = sprintf("run_id: #%u state: %s - %s", ...
                        runId, runState.life_cycle_state, string(delta));
        else
            statMsg = sprintf("run_id: #%u state: %s '%s' - %s", ...
                        runId, runState.life_cycle_state, runState.state_message, string(delta));
        end

        newLength = strlength(statMsg);
        backspace = repmat(sprintf('\b'), 1, oldLength);
        fprintf("%s%s", backspace, statMsg);
        oldLength = newLength;
        
        % See: https://docs.databricks.com/dev-tools/api/2.0/jobs.html
        if strcmp(runState.life_cycle_state, 'SUCCESS')
            fprintf("\n");
            break;
        elseif strcmp(runState.life_cycle_state, 'TERMINATED')
            if startsWith(runState.state_message, 'Run cancelled')
                error('Job run state: TERMINATED\nAn exception state that indicates a cancellation in the job has occurred.');
            else
                fprintf("\n");
                break;
            end
        end
        if strcmp(runState.life_cycle_state, 'INTERNAL_ERROR')
            error('Job run state: INTERNAL_ERROR\nAn exception state that indicates a failure in the job has occurred.');
        end
        if strcmp(runState.life_cycle_state, 'SKIPPED')
            error('Job run state: SKIPPED\nThis job was aborted because a previous run of the same job is already active.');
        end
        pause(10);
    end
end
