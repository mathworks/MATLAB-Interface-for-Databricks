function [result, errorResponse] = deleteConversationMessage(obj, spaceId, conversationId, messageId)
    % DELETECONVERSATIONMESSAGE Delete a conversation message
    %
    % Example:
    %   g = databricks.Genie;
    %   [result, errorResponse] = g.deleteConversationMessage("e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f");
    %
    % See also: https://docs.databricks.com/api/workspace/genie/deleteconversationmessage

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
        messageId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
    URI.Path(end+1) = "messages";
    URI.Path(end+1) = messageId;
   
    % Start a DELETE request
    request = obj.getRequestMessage('DELETE');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end