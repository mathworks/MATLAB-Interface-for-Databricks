classdef AppState < JSONEnum
    % AppState
    %
    % Example:
    %   state = databricks.datastructures.apps.AppState.DEPLOYING

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        DEPLOYING   ("DEPLOYING")
        RUNNING     ("RUNNING")
        CRASHED     ("CRASHED")
        UNAVAILABLE ("UNAVAILABLE")
    end
end