function [result, errorResponse] = startConversation(obj, spaceId, content)
    % STARTCONVERSATION Start a new conversation
    %
    % Example:
    %   g = datebricks.Genie;
    %   [result, errorResponse] = g.listSpaces;
    %   spaceId = result.spaces(1).spaceId; % Assume #1
    %   content = "What is the answer to the ultimate question of Life, the Universe, and Everything?";
    %   [result, errorResponse] = g.startConversation(spaceId, content);

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        content string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "start-conversation";

    request = obj.getRequestMessage('POST');

    s = struct;
    s.content = content;
    request.Body(1).Payload = jsonencode(s);
    
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.StartConversationResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.StartConversationResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end