classdef ShareInfo < JSONMapper
    % ShareInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ShareInfo Properties:
    %   name - of Share relative to parent metastore
    %   comment - User-supplied free-form text
    %   objects - A list of shared data objects within the Share
    %   owner - Username/groupname of Share owner
    %   created_at - Date of Share creation
    %   created_by - Username of Share creator
    %   updated_at - Date of last update to Share
    %   updated_by - Username of user who last updated Share

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % Name of Share relative to parent metastore
        name string
        % User-supplied free-form text
        comment string
        % A list of shared data objects within the Share
        objects databricks.datastructures.unitycatalog.ShareDataObject {JSONMapper.JSONArray}
        % Username/groupname of Share owner
        owner string
        % Date of Share creation
        created_at datetime {JSONMapper.epochDatetime(created_at, 'TicksPerSecond', 1000)}
        % Username of Share creator
        created_by string
        % Date of last update to Share
        updated_at datetime {JSONMapper.epochDatetime(updated_at, 'TicksPerSecond', 1000)}
        % Username of user who last updated Share
        updated_by string
    end

    methods
        function obj = ShareInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ShareInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods (Static)
        function obj = fromInputs(fields)
            % FROMINPUTS creates an instance of the class with specific
            % properties set to specific values. For each property that is
            % to be set, provide the property name and desired value as 
            % Name-Value pairs.
            arguments
                fields.?databricks.datastructures.unitycatalog.ShareInfo
            end
            obj = databricks.datastructures.unitycatalog.ShareInfo;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end    
end