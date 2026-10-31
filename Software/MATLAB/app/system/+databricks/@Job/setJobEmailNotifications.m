function setJobEmailNotifications(obj,varargin)
% SETJOBEMAILNOTIFICATIONS Method to set email notifications
% Sets email address to be notified on job start, success, failure & skipped
%
% For example:
%
%   jen = databricks.JobEmailNotifications;
%   jen.on_start = {'myaddress@example.com'};
%   jen.on_success = {'myaddress@example.com'};
%   jen.on_failure = {'myaddress@example.com'};
%   jen.no_alert_for_skipped_runs = true;
%
%   job = databricks.Job;
%   job.setJobEmailNotifications(jen);
%
%
%   If a string is provided to this method, it will create a
%   databricks.JobEmailNotifications object with 'on_start', 'on_success',
%   and 'on_failure' all set to this email address, e.g.
%
%   job = databricks.Job;
%   job.setJobEmailNotifications('myaddress@example.com');
%
%   If multiple addresses are required a cell array of character vectors can be
%   provided.
%
%   getNotificationEmail can be used to get a preconfigured address in the
%   databricks-settings.json configuration file or attempt to derive the user's address:
%
%   jen = databricks.JobEmailNotifications;
%   notificationEmail = jen.getNotificationEmail;
%    or
%   notificationEmail = databricks.JobEmailNotifications.getNotificationEmail;
%
%   If no argument is provided, an attempt will be made to set the notification
%   address for all states automatically:
%
%   job.setJobEmailNotifications();


%  (c) 2019-2021 MathWorks, Inc.

if isempty(varargin)
    % No argument provided so attempt to get email address
    jobNotifications = setValues(databricks.JobEmailNotifications.getNotificationEmail);
elseif length(varargin) == 1
    % May be a scalar char/string, cellstr or databricks.JobEmailNotifications
    jobNotifications = setValues(varargin{1});
else
    error('DATABRICKS:INVALID','Unexpected number of arguments');
end


% Check if we have a property already
if ~isprop(obj,'email_notifications')
    addprop(obj,'email_notifications');
end

% Set jobNotifications property value
obj.email_notifications = jobNotifications;

end %function


function jobNotifications = setValues(notificationEmail)
if ischar(notificationEmail) || isStringScalar(notificationEmail)
    if strlength(notificationEmail) > 0
        jobNotifications = databricks.JobEmailNotifications();
        jobNotifications.on_start   = notificationEmail;
        jobNotifications.on_success = notificationEmail;
        jobNotifications.on_failure = notificationEmail;
    else
        % Exit without setting up notifications as per warning above
        warning('No email address provided, notifications will not be set.');
        return;
    end
elseif iscellstr(notificationEmail) %#ok<ISCLSTR>
    if ~any(~cellfun(@isempty, notificationEmail))
        warning('No email address provided, notifications will not be set.');
        return;
    else
        jobNotifications = databricks.JobEmailNotifications();
        jobNotifications.on_start   = notificationEmail;
        jobNotifications.on_success = notificationEmail;
        jobNotifications.on_failure = notificationEmail;
    end
elseif isa(notificationEmail,'databricks.JobEmailNotifications')
    jobNotifications = notificationEmail;
else
    error('DATABRICKS:INVALID','Expected a character vector, scalar string or databricks.JobEmailNotifications as input');
end
end %function
