function [result, errorResponse] = getMsgAttachmentSQLQueryResult(obj, spaceId, conversationId, messageId, attachmentId)
    % GETMSGATTACHMENTSQLQUERYRESULT Get the result of SQL query if the message has a query attachment
    % This is only available if a message has a query attachment and the message
    % status is EXECUTING_QUERY OR COMPLETED.
    %
    % See also: https://docs.databricks.com/api/workspace/genie/getmessageattachmentqueryresult

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
        messageId string {mustBeTextScalar, mustBeNonzeroLengthText}
        attachmentId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
    URI.Path(end+1) = "messages";
    URI.Path(end+1) = messageId;
    URI.Path(end+1) = "attachments";
    URI.Path(end+1) = attachmentId;
    URI.Path(end+1) = "query-result";

    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
