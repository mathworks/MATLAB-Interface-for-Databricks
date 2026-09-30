function [result, errorResponse] = createConversationMessage(obj, spaceId, conversationId, content)
    % CREATECONVERSATIONMESSAGE Create new message in a conversation
    % The AI response uses all previously created messages in the conversation
    % to respond.
    %
    % Example:
    %   g = databricks.Genie;
    %   spaceId = "01f08735906717ac8d15d3dc2b61402e";
    %   conversationId = "01f08739b4391f709fd65ba3a813ef7d";
    %   content = "What tables are there and how are they connected? Give me a short summary.";
    %   [result, errorResponse] = g.createConversationMessage(spaceId, conversationId, content)
    
    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
        content string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
    URI.Path(end+1) = "messages";

    request = obj.getRequestMessage('POST');

    s = struct;
    s.content = content;
    request.Body(1).Payload = jsonencode(s);
    
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.CreateConversationMessageResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.CreateConversationMessageResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end