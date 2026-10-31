classdef Error < JSONMapper
    % Error
    %
    % Error Properties:
    %   error_code - type: ErrorCode
    %   message - Brief summary of error condition. - type: string

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % errorCode - type: ErrorCode
        errorCode databricks.datastructures.statementexecution.ErrorCode {JSONMapper.fieldName(errorCode,"error_code")}
        % message - Brief summary of error condition.
        message string {JSONMapper.fieldName(message,"message")}
    end

    methods
        % Constructor
        function obj = Error(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.Error
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
