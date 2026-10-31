classdef RotateRecipientToken < JSONMapper
    % RotateRecipientToken Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.RotateRecipientToken Properties:
    %   existing_token_expire_in_seconds - This will set the expiration_time of existing token only to a
    %      smaller timestamp, it cannot extend the expiration_time. Use 0 to
    %      expire the existing token immediately, negative number will
    %      return an error.

    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties
        % This will set the expiration_time of existing token only to a
        % smaller timestamp, it cannot extend the expiration_time. Use 0 to
        % expire the existing token immediately, negative number will
        % return an error.
        existing_token_expire_in_seconds int64
    end

    methods
        function obj = RotateRecipientToken(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.RotateRecipientToken
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
                fields.?databricks.datastructures.unitycatalog.RotateRecipientToken
            end
            obj = databricks.datastructures.unitycatalog.RotateRecipientToken;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end      
end