classdef WarehouseStatus
    % WarehouseStatus Databricks WarehouseStatus Data Structure

    % Copyright 2022 The MathWorks, Inc.
    enumeration
        % Warehouse is functioning normally and there are no known issues.
        HEALTHY
        % Warehouse might be functional, but there are some known issues. Performance might be affected.
        DEGRADED
        % Warehouse is severely affected and will not be able to serve queries.
        FAILED
    end
end