function setTimeoutSeconds(obj, timeout, varargin)
    % SETTIMEOUTSECONDS Method to set the timeout on the configured job
    % The provided value timeout will be converted to an int32.
    % The default value is 3600 seconds.
    %
    %   % Create a Job and set a timeout
    %   jb = databricks.Job;
    %   jb.setTimeoutSeconds(1000);

    %  (c) 2022 MathWorks, Inc.

    % Add the properties needed for a specific task
   obj.timeout_seconds = timeout;


end %function
