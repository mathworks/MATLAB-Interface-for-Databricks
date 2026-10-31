
classdef Status < JSONEnum
    % STATUS Enumeration for Genie conversation messages
    %
    % Example:
    %   f = databricks.datastructures.genie.Status.FAILED;
    %
    % See also: https://docs.databricks.com/api/workspace/genie/createmessage#status

    % (c) 2025 The MathWorks Inc.

    enumeration
        % Fetching metadata from the data sources.
        FETCHING_METADATA ("FETCHING_METADATA")
        % Running smart context step to determine relevant context.
        FILTERING_CONTEXT ("FILTERING_CONTEXT")
        % Waiting for the LLM to respond to the user's question.
        ASKING_AI ("ASKING_AI")
        % Waiting for warehouse before the SQL query can start executing.
        PENDING_WAREHOUSE ("PENDING_WAREHOUSE")
        % Executing a generated SQL query. Get the SQL query result by calling getMessageAttachmentQueryResult API.
        EXECUTING_QUERY ("EXECUTING_QUERY")
        % The response generation or query execution failed. See error field.
        FAILED ("FAILED")
        % Message processing is completed. Results are in the attachments field. Get the SQL query result by calling getMessageAttachmentQueryResult API.
        COMPLETED ("COMPLETED")
        % Message has been submitted.
        SUBMITTED ("SUBMITTED")
        % SQL result is not available anymore. The user needs to rerun the query. Rerun the SQL query result by calling executeMessageAttachmentQuery API.
        QUERY_RESULT_EXPIRED ("QUERY_RESULT_EXPIRED")
        % Message has been cancelled.
        CANCELLED ("CANCELLED")
    end
end
