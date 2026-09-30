classdef GetMsgAttachmentSQLQueryResponse < JSONMapper
    % GETMSGATTACHMENTSQLQUERYRESPONSE Class to represent a GetMsgAttachmentSQLQuery response

    % Copyright 2025 The MathWorks, Inc.

    properties
        % SQL Statement Execution response
        statementResponse databricks.datastructures.genie.StatementResponse { JSONMapper.fieldName(statementResponse, "statement_response") }
    end

    methods
        function obj = GetMsgAttachmentSQLQueryResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end