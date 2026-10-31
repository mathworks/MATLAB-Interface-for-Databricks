function [result, errorResponse] = getConversationMessage(obj, spaceId, conversationId, messageId)
    % GETCONVERSATIONMESSAGE Get message from conversation
    %
    % Example:
    %   g = databricks.Genie;
    %   spaceId = "e1ef34712a29169db030324fd0e1df5f";
    %   conversationId = "e1ef34712a29169db030324fd0e1df5f";
    %   messageId = "e1ef34712a29169db030324fd0e1df5f";
    %   message = g.getConversationMessage(spaceId, conversationId, messageId);
    %
    % See also: https://docs.databricks.com/api/workspace/genie/getmessage

    % (c) 2025-2026 The MathWorks Inc

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
    
    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.Message().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.Message.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end