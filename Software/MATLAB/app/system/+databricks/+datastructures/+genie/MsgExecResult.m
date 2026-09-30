classdef MsgExecResult < JSONMapper
    % MSGEXECRESULT Contains the result data of a single chunk when using INLINE disposition
    % When using EXTERNAL_LINKS disposition, the array external_links is used instead
    % to provide presigned URLs to the result data in cloud storage. Exactly one of
    % these alternatives is used. (While the external_links array prepares the API
    % to return multiple links in a single response. Currently only a single link
    % is returned.)

    % Copyright 2025 The MathWorks, Inc.

    properties
        % The number of bytes in the result chunk. This field is not available when using INLINE disposition.
        byteCount int64 { JSONMapper.fieldName(byteCount, "byte_count") }
        % The position within the sequence of result set chunks.
        chunkIndex int32 { JSONMapper.fieldName(chunkIndex, "chunkIndex") }
        % The JSON_ARRAY format is an array of arrays of values, where each non-null value is formatted as a string. Null values are encoded as JSON null.
        dataArray string { JSONMapper.fieldName(dataArray, "data_array"), JSONMapper.doNotDecode}
        % externalLinks
        externalLinks databricks.datastructures.genie.ExternalLink { JSONMapper.fieldName(externalLinks, "external_links"), JSONMapper.JSONArray }
        % When fetching, provides the chunk_index for the next chunk. If absent, indicates there are no more chunks. The next chunk can be fetched with a statementexecution/getstatementresultchunkn request.
        nextChunkIndex int32 { JSONMapper.fieldName(nextChunkIndex, "next_chunk_index") }
        %  When fetching, provides a link to fetch the next chunk. If absent, indicates there are no more chunks. This link is an absolute path to be joined with your $DATABRICKS_HOST, and should be treated as an opaque link. This is an alternative to using next_chunk_index.
        nextChunkInternalLink string { JSONMapper.fieldName(nextChunkInternalLink, "next_chunk_internal_link") }
        % The number of rows within the result chunk.
        rowCount int64 { JSONMapper.fieldName(rowCount, "row_count") }
        % The starting row offset within the result set.
        rowOffset int64 { JSONMapper.fieldName(rowOffset, "row_offset") }
    end

    methods
        function obj = MsgExecResult(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.MsgExecResult
            end
            obj@JSONMapper(s, inputs);
        end
    end
end