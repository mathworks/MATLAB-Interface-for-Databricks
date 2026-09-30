classdef ExperimentPermission < JSONEnum
    % ExperimentPermission
    %
    % Example:
    %   ExperimentPermission = databricks.datastructures.apps.ExperimentPermission.CAN_MANAGE 

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CAN_MANAGE  ("CAN_MANAGE")
        CAN_EDIT    ("CAN_EDIT")
        CAN_READ    ("CAN_READ")
    end
end