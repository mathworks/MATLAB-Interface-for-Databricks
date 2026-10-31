function stopflag = trainnet(info)
    persistent active_run
    persistent mlflow_client
    persistent metrics
    persistent logging
    
    % Never stop training due to an issue with logging
    stopflag = false;
    
    try
        switch info.State
            case "start"
                % Start a new run
                mlflow_client = py.mlflow.tracking.MlflowClient;
                active_run = py.mlflow.start_run();
                % With an empty list of metrics
                metrics = py.list();
                % Turn logging on, this will be turned off if an error
                % occurs during logging
                logging = true;
            case "iteration"
                if logging % Only do this if no errors occurred
                    % Log parameters which actually have a value (mlflow
                    % cannot deal with empty values here)
                    if ~isempty(info.TrainingAccuracy)
                        metrics.append(py.mlflow.entities.Metric( ...
                            key='TrainingAccuracy', ...
                            value=info.TrainingAccuracy, ...
                            timestamp=int64(milliseconds(info.TimeElapsed)), ...
                            step=int64(info.Iteration)));
                    end
                    if ~isempty(info.TrainingLoss)
                        metrics.append(py.mlflow.entities.Metric( ...
                            key='TrainingLoss', ...
                            value=info.TrainingLoss, ...
                            timestamp=int64(milliseconds(info.TimeElapsed)), ...
                            step=int64(info.Iteration)));
                    end
                    % Log in batches of about 500. Certain mlflow
                    % servers have a limit of about 1000 metrics you may
                    % log in one log_batch call. With 500 we are well below
                    % this but also not calling this too often, as to not
                    % cause a too high overhead
                    if py.len(metrics) >= 500
                        mlflow_client.log_batch( ...
                            run_id=active_run.info.run_id, ...
                            metrics=metrics, ...
                            aync=true);
                        % After this batch has been logged, start a new
                        % list for the next batch
                        metrics = py.list();
                    end
                end
            case "done"
                if logging % Only do this if no errors occurred
                    % Log the final batch of metrics which are still in the
                    % list
                    mlflow_client.log_batch( ...
                        run_id=active_run.info.run_id, ...
                        metrics=metrics)
                    % End the run
                    mlflow.end_run()
                end
        end
    catch ME
        % In case of error, always end the run to avoid errors if for next
        % attempt or user-code calls mlflow.new_run() (which would error if
        % there still was an active run).
        mlflow.end_run()
        % Set flag to stop any further logging during this training run
        logging = false;
        % Inform the user about the error
        warning('mlflow:logging:warning', ...
            ['An error occurred during mlflow logging.\n' ...
             'Logging will be turned off for the remainder of the training.\n' ...
             '\n' ...
             '%s\n'],ME.getReport());
    end