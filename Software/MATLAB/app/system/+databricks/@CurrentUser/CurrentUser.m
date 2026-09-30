classdef CurrentUser < databricks.Object
    % CURRENTUSER Get details about the current method caller's identity
    % This API is in Public Preview
    %
    % Example:
    %   u = databricks.CurrentUser;
    %   [userInfo, errorResponse] = u.getCurrentUserInfo();
    %
    % See also: https://docs.databricks.com/api/workspace/currentuser/me

    % (c) 2025 MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = CurrentUser(varargin)
            % Constructor
            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end
