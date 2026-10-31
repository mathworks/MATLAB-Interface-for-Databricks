function [result, errorResponse] = deleteConversation(obj, spaceId, conversationId)
    % DELETECONVERSATION Delete a conversation
    %
    % Example:
    %   g = databricks.Genie;
    %   [result, errorResponse] = g.deleteConversation("e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f");
    %
    % See also: https://docs.databricks.com/api/workspace/genie/deleteconversation

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
   
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