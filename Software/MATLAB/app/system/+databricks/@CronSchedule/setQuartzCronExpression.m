function setQuartzCronExpression(obj, expression)
    % SETQUARTZCRONEXPRESSION Method to set the timezone of a CronSchedule
    % A Cron expression using Quartz syntax that describes the schedule for a job.
    % For details see: http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html
    % This field is required.
    %
    % For example:
    %
    %   cs = databricks.CronSchedule;
    %   cs.setQuartzCronExpression("0 15 22 * * ?");

    % (c) 2021-2024 MathWorks, Inc.

    if ischar(expression) || isStringScalar(expression)
        obj.quartz_cron_expression = string(expression);
    else
        error('DATABRICKS:ERROR','Expected expression to be of type character vector or scalar string');
    end
end %function