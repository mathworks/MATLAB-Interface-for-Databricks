classdef testJobEmailNotifications < matlab.unittest.TestCase
    % TESTJOBEMAILNOTIFICATIONS This is a test stub for job notifications
    
    
    %                 (c) 2019-2021 MathWorks, Inc.
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Please add your test cases below
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testConstruction(testCase)
            % Create a notification object
            disp('Testing constructor');
            
            addrStr = databricks.JobEmailNotifications.getNotificationEmail();
            
            if ischar(addrStr)
                n = databricks.JobEmailNotifications;
                n.on_start = {addrStr};
                n.on_success = {addrStr};
                n.on_failure = {addrStr};
                n.no_alert_for_skipped_runs = true;
                
                testCase.verifyClass(n,'databricks.JobEmailNotifications');
                testCase.verifyTrue(n.no_alert_for_skipped_runs);
                getResult = databricks.JobEmailNotifications.getNotificationEmail();
                testCase.verifyTrue(strcmp(getResult, n.on_failure{1}));
                testCase.verifyTrue(strcmp(getResult, n.on_success{1}));
                testCase.verifyTrue(strcmp(getResult, n.on_start{1}));
                
                n = databricks.JobEmailNotifications;
                n.on_start = addrStr;
                n.on_success = addrStr;
                n.on_failure = addrStr;
                n.no_alert_for_skipped_runs = true;
                
                testCase.verifyClass(n,'databricks.JobEmailNotifications');
                testCase.verifyTrue(n.no_alert_for_skipped_runs);
                getResult = databricks.JobEmailNotifications.getNotificationEmail();
                testCase.verifyTrue(strcmp(getResult, n.on_failure));
                testCase.verifyTrue(strcmp(getResult, n.on_success));
                testCase.verifyTrue(strcmp(getResult, n.on_start));
                
            else
                testCase.verifyTrue(iscellstr(addrStr)) %#ok<ISCLSTR>
                getResult = databricks.JobEmailNotifications.getNotificationEmail();
                
                n = databricks.JobEmailNotifications;
                n.on_start = addrStr;
                n.on_success = addrStr;
                n.on_failure = addrStr;
                n.no_alert_for_skipped_runs = true;
                
                testCase.verifyTrue(iscellstr(addrStr)); %#ok<ISCLSTR>
                testCase.verifyTrue(any(strcmp(getResult, addrStr{1})));
                testCase.verifyTrue(any(strcmp(getResult, n.on_start{1})));
                testCase.verifyTrue(any(strcmp(getResult, n.on_success{1})));
                testCase.verifyTrue(any(strcmp(getResult, n.on_failure{1})));
                testCase.verifyTrue(n.no_alert_for_skipped_runs);
            end
        end
        
        function testSetJobEmailNotifications(testCase)
            disp('Testing setJobEmailNotifications');
            
            job = databricks.Job;
            job.setJobEmailNotifications();
            testCase.verifyClass(job.email_notifications,'databricks.JobEmailNotifications');
            getResult = databricks.JobEmailNotifications.getNotificationEmail();
            
            if ischar(getResult)
                testCase.verifyTrue(strcmp(getResult, job.email_notifications.on_failure));
                testCase.verifyTrue(strcmp(getResult, job.email_notifications.on_success));
                testCase.verifyTrue(strcmp(getResult, job.email_notifications.on_start));
            else
                testCase.verifyTrue(isequal(getResult, job.email_notifications.on_failure));
                testCase.verifyTrue(isequal(getResult, job.email_notifications.on_success));
                testCase.verifyTrue(isequal(getResult, job.email_notifications.on_start));
            end
            testCase.verifyFalse(job.email_notifications.no_alert_for_skipped_runs);
            
            job = databricks.Job;
            addrStr = 'myaddress@example.com';
            job.setJobEmailNotifications(addrStr);
            testCase.verifyClass(job.email_notifications,'databricks.JobEmailNotifications');
            testCase.verifyTrue(strcmp(addrStr, job.email_notifications.on_failure));
            testCase.verifyTrue(strcmp(addrStr, job.email_notifications.on_failure));
            
        end
    end
    
end
