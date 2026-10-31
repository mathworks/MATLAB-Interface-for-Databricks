classdef ServingPermission < JSONEnum
    % ServingPermission Permission to grant on the serving endpoint
    % Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
    %
    % Example:
    %   servingPermission = databricks.datastructures.apps.ServingPermission.CAN_MANAGE 

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        CAN_MANAGE  ("CAN_MANAGE")
        CAN_QUERY   ("CAN_QUERY")
        CAN_VIEW    ("CAN_VIEW")
    end
end