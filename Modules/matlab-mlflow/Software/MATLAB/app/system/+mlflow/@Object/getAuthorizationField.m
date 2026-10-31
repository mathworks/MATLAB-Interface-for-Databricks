function authField = getAuthorizationField(obj, varargin)
% GETAUTHORIZATIONFIELD Return the authorization field for API

%  (c) 2019-2021 MathWorks, Inc.

%% Set default Property-Value Pairs (Comment/Delete this section if not used)
authField = matlab.net.http.field.AuthorizationField();
authField.Name = 'Authorization';
authField.Value = ['Bearer',' ',obj.Token];

end %function
