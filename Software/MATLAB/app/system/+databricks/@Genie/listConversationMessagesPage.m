function [result, errorResponse] = listConversationMessagesPage(obj,  spaceId, conversationId, options)
    % LISTCONVERSATIONMESSAGESPAGE List a page of messages in a conversation

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 = 20
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if options.pageSize > 100
        error("DATABRICKS:GENIE:LISTCONVERSATIONMESSAGESPAGE", "Page size must be less than or equal to 100.");
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
    URI.Path(end+1) = "messages";

    URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);

    if isfield(options, 'pageToken')
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", options.pageToken);
    end

    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.ListConversationMessagesResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.ListConversationMessagesResponse.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end