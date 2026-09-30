function [result, errorResponse] = execMsgAttachmentSQLQuery(obj, spaceId, conversationId, messageId, attachmentId)
    % EXECMSGATTACHMENTSQLQUERY Execute the SQL for a message query attachment
    % Use this API when the query attachment has expired and needs to be re-executed.

    % Copyright 2025-2026 The MathWorks, Inc.

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
    URI.Path(end+1) = "execute-query";

    request = obj.getRequestMessage('POST');

    % Perform the actual call
    warning('off', 'MATLAB:http:BodyExpectedFor');
    resp = request.send(URI, obj.HTTPOptions);
    warning('on', 'MATLAB:http:BodyExpectedFor');

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
