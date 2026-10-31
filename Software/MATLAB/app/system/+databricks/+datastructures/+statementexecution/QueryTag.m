classdef QueryTag < JSONMapper
    % QueryTag Query tag for a SQL statement
    %
    % QueryTag Properties:
    %   key - Query tag key
    %   value - Query tag value

    % Copyright 2026, MathWorks Inc.

    properties
        % key - Query tag key
        key string
        % value - Query tag value
        value string
    end

    methods
        function obj = QueryTag(s, inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.statementexecution.QueryTag
            end
            obj = obj.initialize(s, inputs);
        end
    end
end
