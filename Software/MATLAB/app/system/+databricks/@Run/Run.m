classdef Run < databricks.Object
    % RUN Class for interacting with specific runs of jobs
    
    % Copyright (c) 2020-2026 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end
    
    methods
        function obj = Run(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            getAuth(obj, varargin{:});
        end
    end
    
    methods(Static)
        % Static Methods
        runs = list(varargin);
    end
    
end
