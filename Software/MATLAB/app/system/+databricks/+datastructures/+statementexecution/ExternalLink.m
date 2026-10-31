classdef ExternalLink < JSONMapper
    % ExternalLink Presigned link for externally stored statement result data
    %
    % ExternalLink Properties:
    %   byteCount - Number of bytes in the result chunk
    %   chunkIndex - Position within the sequence of result chunks
    %   expiration - Date-time when the external link expires
    %   externalLink - Presigned URL pointing to chunk data
    %   nextChunkIndex - Index of the next chunk, when available
    %   nextChunkInternalLink - Internal link for the next chunk, when available
    %   rowCount - Number of rows within the result chunk
    %   rowOffset - Starting row offset within the result set

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % byteCount - Number of bytes in the result chunk
        byteCount int64 {JSONMapper.fieldName(byteCount,"byte_count")}
        % chunkIndex - Position within the sequence of result chunks
        chunkIndex int32 {JSONMapper.fieldName(chunkIndex,"chunk_index")}
        % expiration - Date-time when the external link expires
        expiration datetime {JSONMapper.stringDatetime(expiration,'yyyy-MM-dd''T''HH:mm:ss.SSSZ', 'TimeZone', 'UTC'), JSONMapper.fieldName(expiration,"expiration")}
        % externalLink - Presigned URL pointing to chunk data
        externalLink string {JSONMapper.fieldName(externalLink,"external_link")}
        % nextChunkIndex - Index of the next chunk, when available
        nextChunkIndex int32 {JSONMapper.fieldName(nextChunkIndex,"next_chunk_index")}
        % nextChunkInternalLink - Internal link for the next chunk, when available
        nextChunkInternalLink string {JSONMapper.fieldName(nextChunkInternalLink,"next_chunk_internal_link")}
        % rowCount - Number of rows within the result chunk
        rowCount int64 {JSONMapper.fieldName(rowCount,"row_count")}
        % rowOffset - Starting row offset within the result set
        rowOffset int64 {JSONMapper.fieldName(rowOffset,"row_offset")}
    end

    methods
        % Constructor
        function obj = ExternalLink(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.ExternalLink
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
