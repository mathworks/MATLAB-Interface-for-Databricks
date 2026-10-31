classdef StatementResponse < JSONMapper
    % STATEMENTRESPONSE Class to represent a SQL Statement Execution response

    % Copyright 2025 The MathWorks, Inc.

    properties
        % The result manifest provides schema and metadata for the result set
        manifest databricks.datastructures.genie.Manifest { JSONMapper.fieldName(manifest, "manifest") }
        result databricks.datastructures.genie.MsgExecResult { JSONMapper.fieldName(result, "result") }
        % The statement ID is returned upon successfully submitting a SQL statement, and is a required reference for all subsequent calls.
        statementId string { JSONMapper.fieldName(statementId, "statement_id") }
        status databricks.datastructures.genie.StatementResponseStatus { JSONMapper.fieldName(status, "status") }
    end

    methods
        function obj = StatementResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.StatementResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end