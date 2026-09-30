classdef Genie < databricks.Object
    % GENIE Databricks Genie API
    % Class to support working with Genie.
    % This API is in Public Preview
    %
    % Example:
    %    g = databricks.Genie;
    %
    % See also: https://docs.databricks.com/api/workspace/genie

    % (c) 2025-2026 MathWorks, Inc.

    properties
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = Genie(varargin)
            % Constructor
            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end
