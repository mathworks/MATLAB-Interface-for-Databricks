function output = runNow(obj, varargin)
    % RUNNOW Method to run a job now.
    % Run a job now populate the details of the job
    %
    %   jb = databricks.Job;
    %
    %   TODO %% Configure & create the job %%
    %
    %   % Run the job
    %   jb.runNow();

    %  Copyright 2019-2022 MathWorks, Inc.

    %% Vectorize
    for oCount = 1:numel(obj)
        curObj = obj(oCount);

        %% Create a request to start the job on databricks
        jobsURI = curObj.getURI('jobs', 'run-now');
        request = curObj.getRequestMessage('POST');

        request.Body = matlab.net.http.MessageBody;
        request.Body.Payload = jsonencode(curObj);

        % Call databricks
        resp = request.send(jobsURI, obj.HTTPOptions);

        %% Process the results
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            resp.Body.Data = mlflow.jsondecode(resp.Body.Data, false, ...
                {'run_id'}, "int64");
            tmpRun = databricks.Run();
            output = tmpRun.get(resp.Body.Data.run_id);

        else
            if isstruct(resp.Body.Data)
                if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
                    error('DATABRICKS:ERROR','Failed to run job: %s\nerror_code: %s\n   message: %s',...
                     curObj.name, char(resp.Body.Data.error_code), char(resp.Body.Data.message));
                else
                    error('DATABRICKS:ERROR', 'Failed to run job: %s', curObj.name);
                end
            else
                error('DATABRICKS:ERROR', 'Failed to run job: %s', curObj.name, char(resp.Body.Data));
            end
        end
    end

end %function
