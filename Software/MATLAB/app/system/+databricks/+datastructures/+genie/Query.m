classdef Query < JSONMapper
    % Query Class to represent Query Attachment if Genie responds with a SQL query

    % Copyright 2025 The MathWorks, Inc.

    properties
        % Description of the query
        description string { JSONMapper.fieldName(description, "description") }
        % Time when the user updated the query last
        lastUpdatedTimestamp datetime { JSONMapper.epochDatetime(lastUpdatedTimestamp,'TicksPerSecond',1000), JSONMapper.fieldName(lastUpdatedTimestamp, "last_updated_timestamp") }
        % AI generated SQL query
        query string { JSONMapper.fieldName(query, "query") }
        % Metadata associated with the query result
        queryResultMetadata databricks.datastructures.genie.QueryResultMetadata { JSONMapper.fieldName(queryResultMetadata, "query_result_metadata") }
        % Statement Execution API statement id. Use Get status, manifest, and result first chunk to get the full result data
        statementId string { JSONMapper.fieldName(statementId, "statement_id") }
        % Name of the query
        title string { JSONMapper.fieldName(title, "title") }
    end

    methods
        function obj = Query(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Query
            end
            obj@JSONMapper(s, inputs);
        end
    end
end