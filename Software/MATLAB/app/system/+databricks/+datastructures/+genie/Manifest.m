classdef Manifest < JSONMapper
    % MANIFEST Provides schema and metadata for the result set

    % Copyright 2025 The MathWorks, Inc.

    properties
        % Array of result set chunk metadata.
        chunks databricks.datastructures.genie.Chunk { JSONMapper.fieldName(chunks, "chunks"), JSONMapper.JSONArray }
        % Enum: JSON_ARRAY | ARROW_STREAM | CSV
        format databricks.datastructures.genie.Format { JSONMapper.fieldName(format, "format") }
        % The schema is an ordered list of column descriptions.
        schema databricks.datastructures.genie.Schema { JSONMapper.fieldName(schema, "schema") }
        % The total number of bytes in the result set. This field is not available when using INLINE disposition.
        totalByteCount int64 { JSONMapper.fieldName(totalByteCount, "total_byte_count") }
        % The total number of chunks that the result set has been divided into.
        totalChunkCount int32 { JSONMapper.fieldName(totalChunkCount, "total_chunk_count") }
        % The total number of rows in the result set.
        totalRowCount int64 { JSONMapper.fieldName(totalRowCount, "total_row_count") }
        % Indicates whether the result is truncated due to row_limit or byte_limit.
        truncated logical { JSONMapper.fieldName(truncated, "truncated") }
    end

    methods
        function obj = Manifest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Manifest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end