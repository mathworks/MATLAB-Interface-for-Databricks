function [result, errorResponse] = listConversations(obj, spaceId, options)
    % LISTCONVERSATIONS List Genie conversations to return a complete list
    % An optional pageSize int32 argument can be provided that sets the page size
    % used the default value is 20, it must be less than or equal to 100.
    % On success a databricks.datastructures.genie.listConversationsResponse is returned
    % otherwise a databricks.datastructures.ErrorResponse is returned.
    % To return a page at a time use databricks.Genie.listConversationsPage()
    %
    % Example:
    %   g = databricks.Genie;
    %   spaceId = "01f08739b4391f709fd65ba3a813ef7d";
    %   [result, errorResponse] = g.listConversations(spaceId);
    %
    % See also: https://docs.databricks.com/api/workspace/genie/listConversations
    
    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 = 20
    end

    if options.pageSize > 100
        error("DATABRICKS:GENIE:LISTCONVERSATIONSPAGESIZE", "Page size must be less than or equal to 100.");
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = spaceId;
    URI.Path(end+1) = "conversations";

    URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);
    
    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        paginatedResult = databricks.datastructures.genie.ListConversationsResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
        result = databricks.datastructures.genie.ListConversationsResponse.empty;
        return;
    end

    conversationsAll = paginatedResult.conversations;
    while strlength(paginatedResult.nextPageToken) > 0
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", paginatedResult.nextPageToken);
        request = obj.getRequestMessage('GET');
        resp = request.send(URI, obj.HTTPOptions);
        if resp.StatusCode == matlab.net.http.StatusCode.OK
            paginatedResult = databricks.datastructures.genie.ListConversationsResponse().fromJSON(resp.Body.Data);
        else
            result = databricks.datastructures.genie.ListConversationsResponse.empty;
            errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
            return;
        end
        conversationsAll = [conversationsAll, paginatedResult.conversations]; %#ok<AGROW>
    end
    
    % Overwrite the last contents with the concatenated array from previous calls
    result = databricks.datastructures.genie.ListConversationsResponse();
    result.conversations = conversationsAll;
end
