classdef AzureUserDelegationSAS < JSONMapper
    % AzureUserDelegationSAS Databricks Data Structure
    %
    % Properties:
    %   sas_token - The signed URI (SAS Token) used to access blob services for
    %      a given path.
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % The signed URI (SAS Token) used to access blob services for a given path.
        sas_token string
    end

    methods
        function obj = AzureUserDelegationSAS(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AzureUserDelegationSAS
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
                fields.?databricks.datastructures.unitycatalog.AzureUserDelegationSAS
            end
            obj = databricks.datastructures.unitycatalog.AzureUserDelegationSAS;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end