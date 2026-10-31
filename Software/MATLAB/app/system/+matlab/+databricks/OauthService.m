 classdef OauthService
    % OauthService Enumeration of Oauth service provider

    % Copyright 2024 - 2026 The MathWorks, Inc.
    properties(SetAccess = immutable)
        OauthServiceImpl matlab.internal.databricks.OauthService;
    end

    enumeration
        % Use the Databricks in-house Oauth service
        Databricks (matlab.internal.databricks.OauthService.Databricks)
        % Use Entra ID, formerly Azure Active Directory
        EntraID  (matlab.internal.databricks.OauthService.EntraID)
        % Allow the default behavior of the underlying code e.g. a JDBC driver or use of an alternative service provider
        Unspecified (matlab.internal.databricks.OauthService.Unspecified)
    end

    methods (Access = private)
        % Private constructor to assign the composed object
        function obj = OauthService(internalEnum)
            obj.OauthServiceImpl = internalEnum;
        end
    end

end
