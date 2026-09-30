function obj = list(options)
    % LIST Create a list of databricks jobs.
    % This method can be used to create a list of jobs.
    %
    % Example:
    %   jl = databricks.Job.list();
    %
    % The returned job handles can be used to manage the jobs.

    % (c) 2019-2024 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    %% Get a list of all databricks jobs
    obj = databricks.Job(args{:});

    %% Create a new spark job on databricks
    jobURI = obj.getURI('jobs', 'list');
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(jobURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        resp.Body.Data = mlflow.jsondecode(resp.Body.Data, true, ...
            {'jobs',{':'},'created_time'}, "int64", ...
            {'jobs',{':'},'job_id'}, "int64");
        if ~isempty(fieldnames(resp.Body.Data))
            % We have a non-empty response

            % Create an object for each job
            for cCount = 1:numel(resp.Body.Data.jobs)
                % Create an output job
                obj(cCount) = databricks.Job;

                if iscell(resp.Body.Data.jobs)
                    curJob = resp.Body.Data.jobs{cCount};
                else
                    curJob = resp.Body.Data.jobs(cCount); % only one structure
                end

                % Valid response so package and send back to user
                % sPropList = fieldnames(curJob.settings);
                obj(cCount).addStructureAsDynProps(curJob.settings);

                % Get the fieldnames for the job omitting the settings that we
                % have already handled.

                % Populate the structure the job details
                obj(cCount).addStructureAsDynProps(rmfield(curJob, 'settings'))
            end
        else
            % We have an empty response
            obj = [];
        end

    else
        % Could not list jobs
        error('DATABRICKS:ERROR', 'Failed to list jobs');
    end

end %function
