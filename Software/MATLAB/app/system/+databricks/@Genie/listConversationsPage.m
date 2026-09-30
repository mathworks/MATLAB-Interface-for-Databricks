function [result, errorResponse] = listConversationsPage(obj, id, options)
    % LISTCONVERSATIONSPAGE Gets a page of a list of genie conversations
    %
    % Example:
    %   g databricks.Genie;
    %   [result, errorResponse] = g.listConversationsPage;

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.Genie
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 = 20
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if options.pageSize > 100
        error("DATABRICKS:GENIE:LISTCONVERSATIONSPAGESIZE", "Page size must be less than or equal to 100.");
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = id;
    URI.Path(end+1) = "conversations";

    URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);

    if isfield(options, 'pageToken')
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", options.pageToken);
    end

    % Get 1st page
    request = obj.getRequestMessage('GET');
    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.ListConversationsResponse().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.ListConversationsResponse;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end