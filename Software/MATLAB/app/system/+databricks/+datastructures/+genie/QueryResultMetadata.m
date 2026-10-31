classdef QueryResultMetadata < JSONMapper
    % QUERYRESULTMETADATA Class to represent Metadata associated with the query result

    % Copyright 2025 The MathWorks, Inc.

    properties
        % Indicates whether the result set is truncated.
        isTruncated logical { JSONMapper.fieldName(isTruncated, "is_truncated") }
        % The number of rows in the result set.
        rowCount int64 { JSONMapper.fieldName(rowCount, "row_count") }
    end

    methods
        function obj = QueryResultMetadata(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.QueryResultMetadata
            end
            obj@JSONMapper(s, inputs);
        end
    end
end