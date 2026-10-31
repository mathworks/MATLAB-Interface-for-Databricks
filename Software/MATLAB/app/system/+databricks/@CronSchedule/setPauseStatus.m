function setPauseStatus(obj, status)
    % setPauseStatus Method to set the timezone of a CronSchedule
    % The value must be a a Java timezone ID. The schedule for a job will be
    % resolved with respect to this timezone. See Java TimeZone for details:
    % https://docs.oracle.com/javase/7/docs/api/java/util/TimeZone.html
    % This field is required.
    %
    % Example:
    %   cs = databricks.CronSchedule;
    %   cs.setPauseStatus("UNPAUSED");

    % (c) 2021-2024 MathWorks, Inc.

    if ischar(status) || isStringScalar(status)

        status = upper(string(status));

        if (strcmp(status, "PAUSED") || strcmp(status, "UNPAUSED"))

            if isprop(obj, 'pause_status')
                prop = findprop(obj, 'pause_status');
                delete(prop);
            end

            if ~isprop(obj, 'pause_status')
                addprop(obj, 'pause_status');
            end

            obj.pause_status = char(status);
        else
            error('DATABRICKS:ERROR','Expected status must have value PAUSED or UNPAUSED');
        end
    else
        error('DATABRICKS:ERROR','Expected status to be of type character vector or scalar string');
    end
end %function
