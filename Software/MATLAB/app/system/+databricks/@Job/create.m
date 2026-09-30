function create(obj, varargin)
    % CREATE Method to create a new job using a new or existing Spark cluster
    % The job creation can be configured using the properties and methods of
    % this object.
    %
    % For example, to run a job using a new cluster:
    %
    %   % Setup Cluster configuration
    %   cl = databricks.Cluster();
    %   cl.setNumWorkers([2 10]); % autoscaling cluster
    %
    %   % Setup job configuration
    %   jb = databricks.Job;
    %   jb.name = 'TestJob';
    %   jb.setCluster(cl);
    %   jb.create();

    %  Copyright 2019-2022 MathWorks, Inc.

    %% Vectorize
    for oCount = 1:numel(obj)
        curObj = obj(oCount);

        %% Create a new spark job on databricks
        jobsURI = curObj.getURI('jobs', 'create');
        request = curObj.getRequestMessage('POST');

        request.Body = matlab.net.http.MessageBody;
        candidatePayload = getPayload(curObj);
        % Manually strip the forward slash escape
        % TODO: This is a topic of some controversy.
        % JSON does not REQUIRE you to escape it, but allows you to.
        % So, should it be escaped or not, may be a matter of religion.
        request.Body.Payload = strrep(candidatePayload,'\/','/');

        % Call databricks
        resp = request.send(jobsURI, curObj.HTTPOptions);

        %% Process the results
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            allowMissing = false;
            resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"job_id"}, 'int64');
            % Valid response so package and send back to user
            setprop(curObj, 'job_id', resp.Body.Data.job_id);
        else
            error('DATABRICKS:ERROR', 'Failed to create job: %s\n%s', curObj.name, char(show(resp)));
        end
    end
end %function