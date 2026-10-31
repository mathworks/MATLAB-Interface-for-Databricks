classdef ClusterPolicy < databricks.Object
    % CLUSTERPOLICY Databricks Cluster Policies API
    %
    % Class to support working with cluster polices.
    %
    % Example:
    %    cp = databricks.ClusterPolicy;

    % (c) 2022-2026 MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = ClusterPolicy(varargin)
            % Constructor
            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end