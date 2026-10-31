classdef WarehouseHealth < matlab.databricks.StructOrCellDeserializable
    % WarehouseHealth Databricks WarehouseHealth Data Structure

    % Copyright 2022 The MathWorks, Inc.

    properties
        % Warehouse status.
        status databricks.datastructures.WarehouseStatus
        % A descriptive message about the health status. Includes
        % information about errors contributing to current health status.
        message string
    end

    methods
        function obj = WarehouseHealth(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end    
end