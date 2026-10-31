classdef InstancePools < databricks.Object
    % INSTANCEPOOLS Databricks Instance Pools API
    %
    % Class to support working with instance pools.
    %
    % Example:
    %    ip = databricks.InstancePools;

    % (c) 2025-2026 MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = InstancePools(varargin)
            % Constructor
            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end

    methods (Static)
        [result, errorResponse] = list(varargin)
    end
end
