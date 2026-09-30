classdef TableType < JSONEnum
    % TableType Enumeration of the table_type field within TableInfo
    %
    % Enumeration Values:
    %   MANAGED
    %   EXTERNAL
    %   VIEW
    %   MATERIALIZED_VIEW
    %   STREAMING_TABLE
    %   MANAGED_SHALLOW_CLONE
    %   FOREIGN
    %   EXTERNAL_SHALLOW_CLONE
    %   METRIC_VIEW

    % Copyright 2022-2026 The MathWorks, Inc.

    enumeration
        MANAGED ("MANAGED")
        EXTERNAL ("EXTERNAL")
        VIEW ("VIEW")

        % Bug fix updated in v6.0.3 pending wider API update
        % appears to be an API change post 2.1 during preview period
        % no additional support for the following types has been added
        % beyond the Enum

        MATERIALIZED_VIEW ("MATERIALIZED_VIEW")
        STREAMING_TABLE ("STREAMING_TABLE")
        MANAGED_SHALLOW_CLONE ("MANAGED_SHALLOW_CLONE")
        FOREIGN ("FOREIGN")
        EXTERNAL_SHALLOW_CLONE ("EXTERNAL_SHALLOW_CLONE")
        METRIC_VIEW ("METRIC_VIEW")
    end
end
