classdef Chunk < JSONMapper
    % CHUNK

    % Copyright 2025 The MathWorks, Inc.

    properties
        % The number of bytes in the result chunk. This field is not available when using INLINE disposition.
        byteCount int64 { JSONMapper.fieldName(byteCount, "byte_count") }
        % The position within the sequence of result set chunks.
        chunkIndex int32 { JSONMapper.fieldName(chunkIndex, "chunk_index") }
        % The number of rows within the result chunk.
        rowCount int64 { JSONMapper.fieldName(rowCount, "row_count") }
        % The number of rows within the result chunk.
        rowOffset int64 { JSONMapper.fieldName(rowOffset, "row_offset") }
    end

    methods
        function obj = Chunk(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Chunk
            end
            obj@JSONMapper(s, inputs);
        end
    end
end