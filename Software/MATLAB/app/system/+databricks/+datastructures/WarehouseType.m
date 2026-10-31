classdef WarehouseType
    % WarehouseType Databricks WarehouseType Data Structure
    % When creating a warehouse if you want to use serverless compute,
    % you must set to PRO and also set the field enable_serverless_compute
    % to true.

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        PRO
        CLASSIC
        TYPE_UNSPECIFIED
    end
end