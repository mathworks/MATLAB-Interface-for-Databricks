classdef DataSecurityMode
    % DataSecurityMode Enumeration for cluster Data Security Modes in Databricks
    %
    % Data security mode decides what data governance model to use when accessing
    % data from a cluster.
    %
    % NONE: No security isolation for multiple users sharing the cluster.
    % Data governance features are not available in this mode. This mode
    % is now referred to as "No isolation shared".
    %
    % SINGLE_USER: A secure cluster that can only be exclusively used by a single
    % user specified in single_user_name. Most programming languages, cluster
    % features and data governance features are available in this mode. This mode
    % is now referred to as "Dedicated".
    %
    % USER_ISOLATION: A secure cluster that can be shared by multiple users.
    % Cluster users are fully isolated so that they cannot see each other's data
    % and credentials. Most data governance features are supported in this mode.
    % But programming languages and cluster features might be limited. This mode
    % is now referred to as "Standard".
    %
    % The following LEGACY_* modes are deprecated starting with Databricks Runtime
    % 15.0 and will be removed for future Databricks Runtime versions:
    %
    % LEGACY_TABLE_ACL: This mode is for users migrating from legacy Table ACL clusters.
    %
    % LEGACY_PASSTHROUGH: This mode is for users migrating from legacy Passthrough
    % on high concurrency clusters.
    %
    % LEGACY_SINGLE_USER: This mode is for users migrating from legacy Passthrough
    % on standard clusters.
    %
    % LEGACY_SINGLE_USER_STANDARD: This mode provides a way that doesn't have UC
    % nor passthrough enabled.
    %
    %   API               Current terminology     API alias                       Prior terminology / AKA
    %   =====================================================================================================
    %   NONE              No isolation shared
    %   SINGLE_USER       Dedicated               DATA_SECURITY_MODE_DEDICATED    Assigned access mode
    %   USER_ISOLATION    Standard                DATA_SECURITY_MODE_STANDARD     Shared access mode

    % Copyright 2023-2025 The MathWorks, Inc.

    enumeration
        % The following modes can be used regardless of kind.
        % No security isolation for multiple users sharing the cluster. Data governance
        % features are not available in this mode
        NONE
        % A secure cluster that can only be exclusively used by a single user 
        % specified in single_user_name. Most programming languages, cluster
        % features and data governance features are available in this mode.
        SINGLE_USER
        % A secure cluster that can be shared by multiple users. Cluster users are
        % fully isolated so that they cannot see each other's data and credentials.
        % Most data governance features are supported in this mode.
        % But programming languages and cluster features might be limited.
        USER_ISOLATION
        
        % The following modes are deprecated starting with Databricks Runtime 15.0 and
        % will be removed for future Databricks Runtime versions:
        % This mode is for users migrating from legacy Table ACL clusters.
        LEGACY_TABLE_ACL
        % This mode is for users migrating from legacy Passthrough on high concurrency clusters.
        LEGACY_PASSTHROUGH
        % This mode is for users migrating from legacy Passthrough on standard clusters.
        LEGACY_SINGLE_USER
        % This mode provides a way that doesn't have UC nor passthrough enabled.
        LEGACY_SINGLE_USER_STANDARD

        % Pending wider Cluster API updates
        % % The following modes can only be used when kind = CLASSIC_PREVIEW.
        % % Alias for USER_ISOLATION.
        % DATA_SECURITY_MODE_STANDARD
        % % Alias for SINGLE_USER.
        % DATA_SECURITY_MODE_DEDICATED
        % % Databricks will choose the most appropriate access mode depending on your compute configuration.
        % DATA_SECURITY_MODE_AUTO
    end
end
