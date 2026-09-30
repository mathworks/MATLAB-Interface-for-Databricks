classdef JobEmailNotifications < databricks.Object
    % JOBEMAILNOTIFICATIONS Notifications to be sent for Jobs
    % Object properties can be used to set email addresses to be notified on
    % job start and other events.
    %
    % To use this object, please specify email addresses to be notified on
    % start, success and failure.
    % By default alerts on skipped runs are enabled.
    
    
    %  (c) 2019-2020 MathWorks, Inc.
    
    properties
        on_start = {};
        on_success = {};
        on_failure = {};
        no_alert_for_skipped_runs = false;
    end
    
    methods
        %% Constructor
        function obj = JobEmailNotifications(~, varargin)
        end
    end
    
    methods (Static)
        nEmail = getNotificationEmail();
    end
    
end %class
