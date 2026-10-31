classdef StatementResponse < JSONMapper
    % StatementResponse Response to a statement execution request
    %
    % StatementResponse Properties:
    %   statement_id - Statement ID is returned upon successfully submitting a SQL statement, and is a required reference for all subsequent calls.
    %   status - type: StatementStatus
    %   manifest - type: ResultManifest
    %   result - type: ResultData
    %
    % Class dependencies:
    %
    %   StatementResponse
    %   |-- status --> Status
    %   |   |-- state ----> State
    %   |   |-- error ----> Error
    %   |   |   `-- errorCode --> ErrorCode
    %   |   `-- sqlState -> State
    %   |-- manifest -> Manifest
    %   |   |-- format --> Format
    %   |   |-- schema --> Schema
    %   |   |   `-- columns --> Column
    %   |   |       `-- typeName --> ColumnInfoType
    %   |   `-- chunks --> Chunk
    %   `-- result ---> ResultData
    %       `-- externalLinks --> ExternalLink

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % statement_id - Statement ID is returned upon successfully submitting a SQL statement, and is a required reference for all subsequent calls.
        statementId string {JSONMapper.fieldName(statementId,"statement_id")}
        % status - type: StatementStatus
        status databricks.datastructures.statementexecution.Status {JSONMapper.fieldName(status,"status")}
        % manifest - type: Manifest
        manifest databricks.datastructures.statementexecution.Manifest {JSONMapper.fieldName(manifest,"manifest")}
        % result - type: ResultData
        result databricks.datastructures.statementexecution.ResultData {JSONMapper.fieldName(result,"result")}
    end

    methods
        % Constructor
        function obj = StatementResponse(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.StatementResponse
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
