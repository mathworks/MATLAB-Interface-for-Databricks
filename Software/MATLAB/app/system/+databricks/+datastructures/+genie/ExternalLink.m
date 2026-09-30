classdef ExternalLink < JSONMapper
    % EXTERNALLINK

    % Copyright 2025 The MathWorks, Inc.

    properties
        % The number of bytes in the result chunk. This field is not available when using INLINE disposition.
        byteCount int64 { JSONMapper.fieldName(byteCount, "byte_count") }
        % The position within the sequence of result set chunks.
        chunkIndex int32 { JSONMapper.fieldName(chunkIndex, "chunk_index") }
        % Indicates the date-time that the given external link will expire and becomes invalid, after which point a new external_link must be requested.
        expiration datetime { JSONMapper.epochDatetime(expiration,'TicksPerSecond',1000), JSONMapper.fieldName(expiration, "expiration") }
        % A presigned URL pointing to a chunk of result data, hosted by an external service, with a short expiration time (<= 15 minutes). As this URL contains a temporary credential, it should be considered sensitive and the client should not expose this URL in a log.
        externalLink string { JSONMapper.fieldName(externalLink, "external_link") }
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
        function obj = ExternalLink(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ExternalLink
            end
            obj@JSONMapper(s, inputs);
        end
    end
end