classdef JobPermission < JSONEnum
    % JobPermission
    %
    % Example:
    %   JobPermission = databricks.datastructures.apps.JobPermission.CAN_MANAGE 

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CAN_MANAGE      ("CAN_MANAGE")
        IS_OWNER        ("IS_OWNER")
        CAN_MANAGE_RUN  ("CAN_MANAGE_RUN")
        CAN_VIEW        ("CAN_VIEW")
    end
end