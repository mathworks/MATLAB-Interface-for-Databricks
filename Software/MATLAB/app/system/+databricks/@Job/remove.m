function remove(obj, varargin)
    % REMOVE Method to remove/delete a job
    % Remove / delete the job and send an email to the addresses specified in
    % JobSettings.email_notifications. No action occurs if the job has already
    % been removed. After the job is removed, neither its details or its run
    % history is visible via the Jobs UI or API.
    %
    % The job is guaranteed to be removed upon completion of this request.
    % However, runs that were active before the receipt of this request may
    % still be active. They will be terminated asynchronously.
    %
    %   jb = databricks.Job;
    %   jb.setJobId(4);
    %   jb.remove();
    %
    % This method in the Databricks API is called delete. It's called
    % remove here, to avoid confusion with the built-in MATLAB delete
    % method.

    %  Copyright 2019-2022 MathWorks, Inc.

    %% Vectorize
    numJobs = numel(obj);
    for oCount = 1:numJobs
        curObj = obj(oCount);

        %% Delete a job on databricks
        jobsURI = curObj.getURI('jobs', 'delete');
        request = curObj.getRequestMessage('POST');

        request.Body = matlab.net.http.MessageBody;

        % Create the payload with the job_id
        jobData.job_id = curObj.job_id;
        request.Body.Payload = jsonencode(jobData);

        % Call databricks
        resp = request.send(jobsURI, databricks.internal.getHTTPOptions(convertResponse=true));

        %% Process the results
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            % Valid response so package and send back to user
            fprintf('Successfully deleted job #%02d/%02d with id: %ld\n', oCount, numJobs, curObj.job_id);
        else
            errMsg = '';
            if ischar(resp.Body.Data)
                errMsg = resp.Body.Data;
            elseif isStringScalar(resp.Body.Data)
                errMsg = char(resp.Body.Data);
            elseif isstruct(resp.Body.Data)
                if isfield(resp.Body.Data, 'error_code')
                    errMsg = 'error_code: ';
                    if ischar(resp.Body.Data.error_code)
                        errMsg = [errMsg, resp.Body.Data.error_code]; %#ok<*AGROW>
                    else
                        errMsg = [errMsg, 'Unsupported error_code field type'];
                    end
                end
                if isfield(resp.Body.Data, 'message')
                    errMsg = [errMsg, ' message: '];
                    if ischar(resp.Body.Data.message)
                        errMsg = [errMsg, resp.Body.Data.message];
                    else
                        errMsg = [errMsg, 'Unsupported message field type'];
                    end
                end
            else
                errMsg = [errMsg, 'Unsupported resp.Body.Data field type'];
            end
            error('DATABRICKS:ERROR', 'Failed to terminate job: %s\n%s', num2str(curObj.job_id), char(errMsg));
        end
    end

end %function
