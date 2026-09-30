function nEmail = getNotificationEmail()
% GETNOTIFICATIONEMAIL Attempts to get email address(es) for job notifications
% If the notificationEmail field of the databricks-settings.json file has been customized
% this will be returned as a character vector or cell array, otherwise an
% attempt will be made to derive the user's email address based on probable
% sources, if this fails an empty character vector will be returned.
%
% Example:
%
%   jen = databricks.JobEmailNotifications;
%   notificationEmail = jen.getNotificationEmail;
%   if isempty(notificationEmail)
%       warning('No email address retrieved, notifications will not be used.');
%   else
%       jen.on_start = notificationEmail;
%       jen.on_success = notificationEmail;
%       jen.on_failure = notificationEmail;
%       job.setJobEmailNotifications(jen);
%   end
%
% In practice a JobEmailNotifications object generally does not need to be
% created manually and job notifications can be configured automatically if
% possible as follows: 
%
%   job.setJobEmailNotifications();

% Copyright 2020-2021 The MathWorks, Inc

% Check settings exists and extract the values
settings = databricks.internal.settings.Settings.getSettingsStruct();

% Legacy settings files may not have the settings field
if isfield(settings, 'notificationEmail')
    % May return a cell array which may have empty values
    if isempty(settings.notificationEmail)
        nEmail = '';
    else
        nEmail = settings.notificationEmail;
    end
else
    % default return value
    disp('notificationEmail field not found in databricks-settings.json file')
    nEmail = '';
end


% Attempt to get an address from the system
% Do not use the default example.com address
% getUserEmail will also return '' if it fails
if ischar(nEmail)
    if isempty(nEmail)
        nEmail = matlab.utils.getUserEmail;
    elseif strcmpi(nEmail, 'defaultaddress@example.com')
        nEmail = matlab.utils.getUserEmail;
    else
        % Return the char value
    end
elseif iscellstr(nEmail)
    %  Input is a cellstr which may be empty
    
    %  Returns 0 if all values in the cell array are empty otherwise 1
    if ~any(~cellfun(@isempty, nEmail))
        % attempt to return the 'best guess'
        nEmail = matlab.utils.getUserEmail;
    end
else
    error('DATABRICKS:FILENOTFOUND', 'Unexpected notification email type');
end

end %function

