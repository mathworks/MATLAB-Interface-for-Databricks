classdef Apps < databricks.Object
    % Apps Databricks Apps API
    %
    % See also: https://docs.databricks.com/api/workspace/apps

    %   (c) 2026 MathWorks, Inc.

    properties(Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
        % Values databricks.datastructures.job.GetResult
        % Id int64
    end

    methods
        % Constructor
        function obj = Apps(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.Version = '2.0';
            obj.getAuth(varargin{:});
        end
    end
end
