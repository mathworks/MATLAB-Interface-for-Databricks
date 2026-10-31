classdef WarehouseTagPair < matlab.databricks.StructOrCellDeserializable
    % WAREHOUSETAGPAIR Databricks WarehouseTagPair Data Structure

    % Copyright 2022 The MathWorks, Inc.
    properties
        % Tag key name.
        key string
        % Tag key value.
        value string
    end

    methods
        function obj = WarehouseTagPair(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end
end