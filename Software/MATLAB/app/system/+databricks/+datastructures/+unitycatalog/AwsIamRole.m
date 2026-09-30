classdef AwsIamRole < JSONMapper
    % AwsIamRole Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.AwsIamRole Properties:
    %   role_arn - The Amazon Resource Name (ARN) of the AWS IAM role for S3
    %      data access
    %   unity_catalog_iam_arn - The Amazon Resource Name (ARN) of the AWS IAM user managed by
    %      Databricks. This is the identity that is going to assume the
    %      AWS IAM role.
    %   external_id - The external ID used in role assumption to prevent confused
    %      deputy problems.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % The Amazon Resource Name (ARN) of the AWS IAM role for S3
        % data access
        role_arn string
        % The Amazon Resource Name (ARN) of the AWS IAM user managed by
        % Databricks. This is the identity that is going to assume the
        % AWS IAM role.
        unity_catalog_iam_arn string
        % The external ID used in role assumption to prevent confused
        % deputy problems.
        external_id string
    end

    methods
        function obj = AwsIamRole(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.AwsIamRole
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
                fields.?databricks.datastructures.unitycatalog.AwsIamRole
            end
            obj = databricks.datastructures.unitycatalog.AwsIamRole;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end