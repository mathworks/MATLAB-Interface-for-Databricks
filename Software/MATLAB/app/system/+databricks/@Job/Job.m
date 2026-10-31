classdef Job < databricks.Object
    % JOB Databricks Job API
    % The Jobs API allows you to create, edit, and delete jobs. The maximum 
    % allowed size of a request to the Jobs API is 10MB.
    %
    %   jh = databricks.Job;
    %
    % Alternatively, 
    %
    %   jh = databricks.Job('HOST','TOKEN');
    %   jh.max_retries = 1;                  % Set a non-default value
    %
    % The default value for max_retries(0) configures the job to never retry. 
    % A value of -1 means to retry indefinitely
    
    %   (c) 2020-2026 MathWorks, Inc.
        
    properties
        name;
        timeout_seconds int32 = 3600
        max_retries = 0
    end

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end
    
    methods
        % Constructor
        function obj = Job(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
    
    methods(Static)
        % Static Methods
        jobs = list(options);
    end

end %class
