classdef WarehouseTags < matlab.databricks.StructOrCellDeserializable
    % WarehouseTags Databricks WarehouseTags Data Structure

    % Copyright 2022 The MathWorks, Inc.
    
    properties
        % An object containing an array of key-value pairs.
        custom_tags databricks.datastructures.WarehouseTagPair
    end

    methods
        function obj = WarehouseTags(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end

        % Override jsonencode to ensure that custom_tags is always an array
        % when encoded
        function json = jsonencode(obj,varargin)
            if length(obj.custom_tags) == 1
                s.custom_tags = {obj.custom_tags};
            else
                s.custom_tags = obj.custom_tags;
            end
            json = jsonencode(s,varargin{:});
        end

    end
end