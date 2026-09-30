classdef OauthService
    % OauthService Enumeration of Oauth service provider

    % Copyright 2024-2026 The MathWorks, Inc.

    enumeration
        % Use the Databricks in-house Oauth service
        Databricks
        % Use Entra ID, formerly Azure Active Directory
        EntraID
        % Allow the default behavior of the underlying code e.g. a JDBC driver or use of an alternative service provider
        Unspecified
    end
end
