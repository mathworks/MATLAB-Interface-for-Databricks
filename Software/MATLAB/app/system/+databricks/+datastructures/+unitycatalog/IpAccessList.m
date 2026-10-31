classdef IpAccessList < JSONMapper
    % IpAccessList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.IpAccessList Properties:
    %   allowed_ip_addresses - Allowed IP Addresses in CIDR notation. Limit of 100.

    % Copyright 2022-2024 The MathWorks, Inc.
    properties
        % Allowed IP Addresses in CIDR notation. Limit of 100.
        allowed_ip_addresses string {JSONMapper.JSONArray}
    end

    methods
        function obj = IpAccessList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.IpAccessList
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
                fields.?databricks.datastructures.unitycatalog.IpAccessList
            end
            obj = databricks.datastructures.unitycatalog.IpAccessList;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end