classdef Manifest < JSONMapper
    % MANIFEST The result manifest provides schema and metadata for the result set.
    %
    % Manifest Properties:
    %   format - Data format
    %   schema - type: Schema
    %   totalChunkCount - Total number of chunks that the result set has been divided into
    %   chunks - Array of result set chunk metadata. - type: array of Chunk
    %   totalByteCount - Total number of bytes in the result set
    %   totalRowCount - Total number of rows in the result set
    %   truncated - Indicates whether the result is truncated due to row_limit or byte_limit

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % format - Data format
        format databricks.datastructures.statementexecution.Format {JSONMapper.fieldName(format,"format")}
        % schema - type: ResultSchema
        schema databricks.datastructures.statementexecution.Schema {JSONMapper.fieldName(schema,"schema")}
        % totalChunkCount - Total number of chunks that the result set has been divided into
        totalChunkCount int32 {JSONMapper.fieldName(totalChunkCount,"total_chunk_count")}
        % chunks - Array of result set chunk metadata
        chunks databricks.datastructures.statementexecution.Chunk {JSONMapper.fieldName(chunks,"chunks"), JSONMapper.JSONArray}
        % totalByteCount - Total number of bytes in the result set
        totalByteCount int64 {JSONMapper.fieldName(totalByteCount,"total_byte_count")}
        % totalRowCount - Total number of rows in the result set
        totalRowCount int64 {JSONMapper.fieldName(totalRowCount,"total_row_count")}
        % truncated - Indicates whether the result is truncated due to row_limit or byte_limit
        truncated logical {JSONMapper.fieldName(truncated,"truncated")}
    end

    methods
        % Constructor
        function obj = Manifest(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.Manifest
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
