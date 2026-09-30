classdef SQLWarehousePermission < JSONEnum
    % SQLWarehousePermission Permission to grant on the serving endpoint
    % Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
    %
    % Example:
    %   SQLWarehousePermission = databricks.datastructures.apps.SQLWarehousePermission.CAN_MANAGE 

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CAN_MANAGE  ("CAN_MANAGE")
        CAN_USE     ("CAN_USE")
        IS_OWNER    ("IS_OWNER")
    end
end