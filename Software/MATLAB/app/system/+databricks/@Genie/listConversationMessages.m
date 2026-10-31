function [result, errorResponse] = listConversationMessages(obj, spaceId, conversationId, options)
    % LISTCONVERSATIONMESSAGES List conversation messages to return a complete list
    % An optional pageSize int32 argument can be provided that sets the page size
    % used the default value is 20, it must be less than or equal to 100.
    % On success a databricks.datastructures.genie.listConversationMessagesResponse
    % is returned otherwise a databricks.datastructures.ErrorResponse is returned.
    % To return a page at a time use databricks.Genie.listConversationMessagesPage()
    %
    % Example:
    %   g = databricks.Genie;
    %   s = g.listSpaces;
    %   spaceId = s.spaces(end).spaceId;
    %   c = g.listConversations(spaceId);
    %   convsersationId = c.conversations(end).conversationId;
    %   [result, errorResponse] = g.listConversationMessages(spaceId, convsersationId);
    %   result.messages(1).content
    %   ans =
    %       "Write a query to count the number of rows in the outages table"
    %
    % See also: https://docs.databricks.com/api/workspace/genie/listConversationmessages
    
    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        conversationId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 = 20
    end

    if options.pageSize > 100
        error("DATABRICKS:GENIE:LISTCONVERSATIONMESSAGES", "Page size must be less than or equal to 100.");
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";
    URI.Path(end+1) = conversationId;
    URI.Path(end+1) = "messages";

    URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);
    
    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        paginatedResult = databricks.datastructures.genie.ListConversationMessagesResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
        result = databricks.datastructures.genie.ListConversationMessagesResponse.empty;
        return;
    end

    messagesAll = paginatedResult.messages;
    while strlength(paginatedResult.nextPageToken) > 0
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", paginatedResult.nextPageToken);
        request = obj.getRequestMessage('GET');
        resp = request.send(URI, obj.HTTPOptions);
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            paginatedResult = databricks.datastructures.genie.ListConversationMessagesResponse().fromJSON(resp.Body.Data);
        else
            result = databricks.datastructures.genie.ListConversationMessagesResponse.empty;
            errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
            return;
        end
        messagesAll = [messagesAll, paginatedResult.messages]; %#ok<AGROW>
    end
    
    % Overwrite the last contents with the concatenated array from previous calls
    result = databricks.datastructures.genie.ListConversationMessagesResponse();
    result.messages = messagesAll;
end
