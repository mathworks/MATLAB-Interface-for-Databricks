classdef Parameter < JSONMapper
    % Parameter SQL statement parameter
    %
    % Parameter Properties:
    %   name - Parameter name used in the SQL statement
    %   value - Parameter value
    %   type - Optional Databricks SQL type for the parameter value

    % Copyright 2026, MathWorks Inc.

    properties
        % name - Parameter name used in the SQL statement
        name string
        % value - Parameter value
        value string
        % type - Optional Databricks SQL type for the parameter value
        type string
    end

    methods
        function obj = Parameter(s, inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.statementexecution.Parameter
            end
            obj = obj.initialize(s, inputs);
        end
    end
end
