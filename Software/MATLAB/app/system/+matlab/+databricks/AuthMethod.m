classdef AuthMethod
    % AuthMethod Enumeration of authentication methods
    % DotDatabricksConnect & Basic are no longer supported and will be removed from
    % this class in a future release without notice.

    % Copyright 2024-2025 The MathWorks, Inc.

    properties(SetAccess = immutable)
        authMethodImpl matlab.internal.databricks.AuthMethod;
    end


    enumeration
        % Evaluate methods in the following order until a working methods is found
        Chain (matlab.internal.databricks.AuthMethod.Chain)
        % Use a legacy <Home Directory>/.databricks-connect file, this will be removed in a future release
        DotDatabricksConnect (matlab.internal.databricks.AuthMethod.DotDatabricksConnect)
        % Databricks personal access token authentication
        PAT (matlab.internal.databricks.AuthMethod.PAT)
        % Basic authentication, legacy, this will be removed in a future release
        Basic (matlab.internal.databricks.AuthMethod.Basic)
        % OAuth machine-to-machine (M2M) authentication
        OauthM2M (matlab.internal.databricks.AuthMethod.OauthM2M)
        % OAuth user-to-machine (U2M) authentication
        OauthU2M (matlab.internal.databricks.AuthMethod.OauthU2M)
    end

    methods (Access = private)
        % Private constructor to assign the composed object
        function obj = AuthMethod(internalEnum)
            obj.authMethodImpl = internalEnum;
        end
    end

    methods
        function authType = authMethod2AuthType(obj)
            % AUTHMETHOD2AUTHTYPE Convert AuthMethod enum or string to auth_type string
            % authTypes are returned in lower case.
            % If authMethod is not recognized, a error is raised.

            authType = obj.authMethodImpl.authMethod2AuthType; 
        end
    end
end
