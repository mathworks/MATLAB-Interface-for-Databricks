classdef Status < JSONMapper
    % STATUS response includes execution state and if relevant, error information.
    %
    % Status Properties:
    %   state: Statement execution state
    %   error: error state
    %   sqlState: error code returned when the statement execution fails.
    %             Only populated when the statement status is FAILED.

    % (c) 2023-2026 MathWorks Inc.

    properties
        % state Statement execution state
        state databricks.datastructures.statementexecution.State {JSONMapper.fieldName(state,"state")}
        % error
        error databricks.datastructures.statementexecution.Error {JSONMapper.fieldName(error,"error")}
        % sqlState error code returned when the statement execution fails. Only populated when the statement status is FAILED.
        sqlState databricks.datastructures.statementexecution.State {JSONMapper.fieldName(sqlState,"sql_state")}
    end

    methods
        function obj = Status(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.Status
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
