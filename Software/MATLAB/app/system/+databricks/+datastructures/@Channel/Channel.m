classdef Channel < matlab.databricks.StructOrCellDeserializable
    % CHANNEL Databricks Channel Data Structure

    % Copyright 2022-2023 The MathWorks, Inc.
    properties
        % Channel Name
        name databricks.datastructures.ChannelName
        dbsql_version string
    end
    methods
        function obj = Channel(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end       
end