classdef ShareDataObject < JSONMapper
    % ShareDataObject Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ShareDataObject Properties:
    %   name - A fully qualified name that uniquely identifies a data object.
    %      For example, a table's fully qualified name is in the format of
    %      `<catalog>.<schema>.<table>`.
    %   comment - User-supplied free-form text
    %   shared_as - A user-provided new name for the data object within the share. If
    %      this new name is not provided, the object's original name will be
    %      used as the `shared_as` name. The `shared_as` name must be unique
    %      within a Share. For tables, the new name must follow the format
    %      of `<schema>.<table>`.
    %   partition_specification - Defines the format of partition filtering specification for
    %      shared tables. It consists of a list of Partitions which in turn
    %      include a list of PartitionValues.
    %   cdf_enabled - Whether to enable Change Data Feed (cdf) or indicate if cdf is
    %      enabled on the shared object.
    %   start_version - The start version associated with the object for cdf. This allows
    %      data providers to control the lowest object version that is
    %      accessible by clients. If specified, clients can query snapshots
    %      or changes for versions >= start_version. If not specified,
    %      clients can only query starting from the version of the object at
    %      the time it was added to the share. NOTE: The start_version
    %      should be <= the "current" version of the object.
    %   added_at - Date of table add to share
    %   added_by - Username of user who added table to share
    %   data_object_type - Type of data object. Currently, the only supported type is
    %      "TABLE".

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % A fully qualified name that uniquely identifies a data object.
        % For example, a table's fully qualified name is in the format of
        % `<catalog>.<schema>.<table>`.
        name string
        % User-supplied free-form text
        comment string
        % A user-provided new name for the data object within the share. If
        % this new name is not provided, the object's original name will be
        % used as the `shared_as` name. The `shared_as` name must be unique
        % within a Share. For tables, the new name must follow the format
        % of `<schema>.<table>`.
        shared_as string
        % Defines the format of partition filtering specification for
        % shared tables. It consists of a list of Partitions which in turn
        % include a list of PartitionValues.
        partition_specification databricks.datastructures.unitycatalog.PartitionSpecification
        % Whether to enable Change Data Feed (cdf) or indicate if cdf is
        % enabled on the shared object.
        cdf_enabled logical
        % The start version associated with the object for cdf. This allows
        % data providers to control the lowest object version that is
        % accessible by clients. If specified, clients can query snapshots
        % or changes for versions >= start_version. If not specified,
        % clients can only query starting from the version of the object at
        % the time it was added to the share. NOTE: The start_version
        % should be <= the "current" version of the object.
        start_version int64
        % Date of table add to share
        added_at datetime {JSONMapper.epochDatetime(added_at, 'TicksPerSecond', 1000)}
        % Username of user who added table to share
        added_by string
        % Type of data object. Currently, the only supported type is
        % "TABLE".
        data_object_type string
    end

    methods
        function obj = ShareDataObject(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ShareDataObject
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
                fields.?databricks.datastructures.unitycatalog.ShareDataObject
            end
            obj = databricks.datastructures.unitycatalog.ShareDataObject;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end       
end