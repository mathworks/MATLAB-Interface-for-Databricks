classdef ComputeState < JSONEnum
    % ComputeState
    %
    % Example:
    %   state = databricks.datastructures.apps.ComputeState.ERROR

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        ERROR     ("ERROR")
        DELETING  ("DELETING")
        STARTING  ("STARTING")
        STOPPING  ("STOPPING")
        UPDATING  ("UPDATING")
        STOPPED   ("STOPPED")
        ACTIVE    ("ACTIVE")
    end
end