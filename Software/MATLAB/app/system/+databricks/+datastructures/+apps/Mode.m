classdef Mode < JSONEnum
    % Mode The mode of which the deployment will manage the source code
    %
    % Example:
    %   mode = databricks.datastructures.apps.Mode.SNAPSHOT

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        SNAPSHOT ("SNAPSHOT")
        AUTO_SYNC ("AUTO_SYNC")
    end
end