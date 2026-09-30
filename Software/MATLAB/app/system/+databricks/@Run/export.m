function result = export(obj, runId)
    % EXPORT Export and retrieve the job run task
    %
    % Only notebook runs can be exported in HTML format. Exporting runs of
    % other types will fail.
    %
    % Examples:
    %
    %   runObj = job.runNow()
    %   % export can now be called to retrieve the views of this Run
    %   % object.
    %   runData = runObj.export()
    %
    % A run_id can also be used with a newly created Run object
    %   runObj = databricks.Run()
    %   runData = runObj.export(12345)

    % Copyright 2020-2026, The MathWorks, Inc.

    if nargin < 2
        if isprop(obj, 'run_id')
            runId = obj.run_id;
        else
            error('DATABRICKS:ERROR', ...
                'The Run object must have a "run_id" property, or one must be added as an argument.');
        end
    end

    getURI = obj.getURI('jobs/runs', 'export', 'run_id', char(sprintf("%u", runId)));

    request = obj.getRequestMessage("GET");

    % Call databricks
    resp = request.send(getURI, obj.HTTPOptions);

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = jsondecode(resp.Body.Data);
    else
        % Could not get run
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
        disp(errorResponse);
        error('DATABRICKS:ERROR', 'Failed to export run: %u', runId);
    end
end

