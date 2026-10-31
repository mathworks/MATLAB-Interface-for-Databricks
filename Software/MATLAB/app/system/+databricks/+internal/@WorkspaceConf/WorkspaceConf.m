classdef WorkspaceConf < databricks.Object
    % WORKSPACECONF Allows updating known workspace settings for advanced users

    % Copyright 2024-2026 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = WorkspaceConf(varargin)
            % WorkspaceConf Constructor

            if verLessThan('matlab', '9.13') %#ok<VERLESSMATLAB>
                error("DATABRICKS:FILES","WorkspaceConf requires MATLAB R2022b or later");
            end

            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=true);
            obj.getAuth(varargin{:});
        end
    end
end
