classdef ResultData < JSONMapper
    % ResultData Statement result data chunk
    %
    % ResultData Properties:
    %   chunkIndex - Position within the sequence of result chunks
    %   rowOffset - Starting row offset within the result set
    %   rowCount - Number of rows within the result chunk
    %   byteCount - Number of bytes in the result chunk
    %   dataArray - JSON_ARRAY result data
    %   externalLinks - Presigned links for externally stored result data
    %   nextChunkIndex - Index of the next chunk, when available
    %   nextChunkInternalLink - Internal link for the next chunk, when available

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % chunkIndex - Position within the sequence of result chunks
        chunkIndex int32 {JSONMapper.fieldName(chunkIndex,"chunk_index")}
        % rowOffset - Starting row offset within the result set
        rowOffset int64 {JSONMapper.fieldName(rowOffset,"row_offset")}
        % rowCount - Number of rows within the result chunk
        rowCount int64 {JSONMapper.fieldName(rowCount,"row_count")}
        % byteCount - Number of bytes in the result chunk
        byteCount int64 {JSONMapper.fieldName(byteCount,"byte_count")}
        % dataArray - JSON_ARRAY result data
        dataArray {JSONMapper.fieldName(dataArray,"data_array"), JSONMapper.doNotDecode, JSONMapper.JSONArray}
        % externalLinks - Presigned links for externally stored result data
        externalLinks databricks.datastructures.statementexecution.ExternalLink {JSONMapper.fieldName(externalLinks,"external_links"), JSONMapper.JSONArray}
        % nextChunkIndex - Index of the next chunk, when available
        nextChunkIndex int32 {JSONMapper.fieldName(nextChunkIndex,"next_chunk_index")}
        % nextChunkInternalLink - Internal link for the next chunk, when available
        nextChunkInternalLink string {JSONMapper.fieldName(nextChunkInternalLink,"next_chunk_internal_link")}
    end

    methods
        % Constructor
        function obj = ResultData(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.ResultData
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
