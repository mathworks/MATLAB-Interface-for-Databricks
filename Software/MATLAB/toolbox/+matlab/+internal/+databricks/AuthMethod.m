classdef AuthMethod
    % AuthMethod Enumeration of authentication methods
    % DotDatabricksConnect & Basic are no longer supported and will be removed from
    % this class in a future release without notice.

    % Copyright 2024-2026 The MathWorks, Inc.

    enumeration
        % Evaluate methods in the following order until a working methods is found
        Chain
        % Use a legacy <Home Directory>/.databricks-connect file, this will be removed in a future release
        DotDatabricksConnect
        % Databricks personal access token authentication
        PAT
        % Basic authentication, legacy, this will be removed in a future release
        Basic
        % OAuth machine-to-machine (M2M) authentication
        OauthM2M
        % OAuth user-to-machine (U2M) authentication
        OauthU2M
    end

    methods
        function authType = authMethod2AuthType(obj)
            % AUTHMETHOD2AUTHTYPE Convert AuthMethod enum or string to auth_type string
            % authTypes are returned in lower case.
            % If authMethod is not recognized, a error is raised.

            arguments (Input)
                obj (1,1) matlab.internal.databricks.AuthMethod
            end
            arguments (Output)
                authType string
            end

            switch obj
                case matlab.internal.databricks.AuthMethod.OauthU2M
                    authType = "external-browser";

                case matlab.internal.databricks.AuthMethod.OauthM2M
                    authType = "oauth-m2m";

                case matlab.internal.databricks.AuthMethod.PAT
                    authType = "pat";

                otherwise
                    error("DATABRICKS:MATLAB:AUTHMETHOD:INVALIDAUTHMETHOD", ...
                        "Cannot convert method: %s to an auth_type value.", string(authMethod));
            end
        end

        function authMethod = authType2AuthMethod(authType)
            arguments (Input)
                authType string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                authMethod (1,1) matlab.internal.databricks.AuthMethod
            end

            switch lower(authType)
                case "external-browser"
                    authMethod = matlab.internal.databricks.AuthMethod.OauthU2M;

                case "oauth-m2m"
                    authMethod = matlab.internal.databricks.AuthMethod.OauthM2M;

                case "pat"
                    authMethod = matlab.internal.databricks.AuthMethod.PAT;

                case "basic"
                    authMethod = matlab.internal.databricks.AuthMethod.Basic;

                otherwise
                    error("DATABRICKS:MATLAB:AUTHMETHOD:NOAUTHTYPE", ...
                        "Cannot convert auth_type: %s to a matlab.internal.databricks.AuthMethod enumeration.", auth_type);
            end
        end
    end
end
