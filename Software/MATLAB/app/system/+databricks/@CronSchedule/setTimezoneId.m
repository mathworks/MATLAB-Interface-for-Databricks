function setTimezoneId(obj, timezoneId)
    % SETTIMEZONEID Method to set the timezone of a CronSchedule
    % The value must be a a Java timezone ID. The schedule for a job will be
    % resolved with respect to this timezone. See Java TimeZone for details:
    % https://docs.oracle.com/javase/7/docs/api/java/util/TimeZone.html
    % This field is required.
    %
    % Example:
    %   cs = databricks.CronSchedule;
    %   cs.setTimezoneId("Ireland/Dublin");

    % (c) 2021-2024 MathWorks, Inc.

    if ischar(timezoneId) || isStringScalar(timezoneId)
        obj.timezone_id = char(timezoneId);
    else
        error('DATABRICKS:ERROR','Expected timezoneId to be of type character vector or scalar string');
    end
end %function
