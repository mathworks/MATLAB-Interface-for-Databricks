classdef CronSchedule < databricks.Object
    % CRONSCHEDULE Quartz Cron schedule object
    %
    % Example:
    %   cs = databricks.CronSchedule;
    %   cs.setQuartzCronExpression("0 15 22 * * ?");
    %   cs.setPauseStatus("PAUSED");
    %   cs.setTimezoneId("Ireland/Dublin");
    
    %   (c) 2021-2022 MathWorks, Inc.
    
    properties
        quartz_cron_expression = '';
        timezone_id = '';
    end
    
    methods
        %% Constructor
        function obj = CronSchedule(~, varargin)
            
        end
    end
    
end %class
