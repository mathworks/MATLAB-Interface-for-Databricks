classdef GeniePermission < JSONEnum
    % GeniePermission
    %
    % Example:
    %   GeniePermission = databricks.datastructures.apps.GeniePermission.CAN_MANAGE 

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CAN_MANAGE  ("CAN_MANAGE")
        CAN_EDIT    ("CAN_EDIT")
        CAN_RUN     ("CAN_RUN ")
        CAN_VIEW    ("CAN_VIEW")
    end
end