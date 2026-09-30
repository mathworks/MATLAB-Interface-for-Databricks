function authField = getAuthorizationField(obj, varargin)
    % GETAUTHORIZATIONFIELD Return the authorization field for API

    %  (c) 2019-2026 MathWorks, Inc.

    % Populate header with bearer token from obj / configuration file

    authField = obj.objectImpl.getAuthorizationField(varargin{:});

end %function
