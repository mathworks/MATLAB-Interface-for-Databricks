function authField = getAuthorizationField(obj, varargin)
    % GETAUTHORIZATIONFIELD Return the authorization field for API

    % Copyright 2019-2026 The MathWorks, Inc.

    % Populate header with bearer token from obj / configuration file
    authField = matlab.net.http.field.AuthorizationField();
    authField.Name = 'Authorization';
    authField.Value = "Bearer " + string(obj.Token);

end %function
