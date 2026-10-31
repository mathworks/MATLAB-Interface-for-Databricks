classdef ExecMsgAttachmentSQLQueryResponse < JSONMapper
    % EXECMSGATTACHMENTSQLQUERYRESPONSE Class to represent a ExecMsgAttachmentSQLQuery response

    % Copyright 2025 The MathWorks, Inc.

    properties
        % SQL Statement Execution response
        statementResponse databricks.datastructures.genie.StatementResponse { JSONMapper.fieldName(statementResponse, "statement_response") }
    end

    methods
        function obj = ExecMsgAttachmentSQLQueryResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end