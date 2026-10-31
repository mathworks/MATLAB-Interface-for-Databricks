function setSchedule(obj, schedule)
% SETSCHEDULE Set an optional periodic schedule for a job
% The default behavior is that the job runs when triggered by the runNow method.
% An argument of type databricks.CronSchedule is required.
%
% For example:
%
%   job = databricks.Job;
%   cs = databricks.CronSchedule;
%   cs.setQuartzCronExpression("0 15 22 * * ?");
%   cs.setPauseStatus("PAUSED");
%   cs.setTimezoneId("Ireland/Dublin");
%   job.setSchedule(cs);

%  (c) 2021 MathWorks, Inc.

if ~isa(schedule, 'databricks.CronSchedule')
    error('DATABRICKS:INVALID','Expected schedule of type databricks.CronSchedule');
end

% Check if we have a property already
if ~isprop(obj,'schedule')
    addprop(obj,'schedule');
end

obj.schedule = schedule;

end