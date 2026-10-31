classdef SCIM < databricks.Object
    % SCIM Class to provide an interface to the Databricks Files REST API
    %
    % See also: https://docs.databricks.com/api/workspace/currentuser/me

    % Copyright 2024-2026 The MathWorks, Inc.

    properties
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = SCIM(varargin)
            % SCIM Constructor

            if verLessThan('matlab', '9.13') %#ok<VERLESSMATLAB>
                error("DATABRICKS:FILES","SCIM requires MATLAB R2022b or later");
            end

            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end