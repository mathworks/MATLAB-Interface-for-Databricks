classdef WarehouseState
    % WarehouseState Databricks WarehouseState Data Structure 

    % Copyright 2022 The MathWorks, Inc.
    enumeration
        % The warehouse is in the process of starting.
        STARTING
        % The starting process is done and the warehouse is ready to use.
        RUNNING
        % The warehouse is in the process of being stopped.
        STOPPING
        % The warehouse is stopped. Start by calling start or by submitting a JDBC or ODBC request.
        STOPPED
        % The warehouse is in the process of being destroyed.
        DELETING
        % The warehouse has been deleted and cannot be recovered.
        DELETED
    end
end