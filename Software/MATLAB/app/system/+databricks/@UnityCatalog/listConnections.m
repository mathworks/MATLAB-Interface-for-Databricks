function result = listConnections(obj)
    % listConnections gets list of connections.
    %
    % Example:
    %
    %   result = uc.listConnections();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of connections
    %       Type:
    %           databricks.datastructures.unitycatalog.Connection
    %
    % See Also: databricks.datastructures.unitycatalog.Connection
    %           https://docs.databricks.com/api/workspace/connections/list
    % 
    
    % API pagination requirement, i.e. support only the future proof paginated API
    % Databricks doc:
    % NOTE: we recommend using max_results=0 to use the paginated version of this API.
    % Unpaginated calls will be deprecated soon.
    % PAGINATION BEHAVIOR: When using pagination (max_results >= 0), a page may contain
    % zero results while still providing a next_page_token. Clients must continue
    % reading pages until next_page_token is absent, which is the only indication
    % that the end of results has been reached.


    % Copyright 2026 The MathWorks, Inc.

    listConnectionsResp = obj.listConnectionsPage();
    result = listConnectionsResp.connections;
    while ~isempty(listConnectionsResp.next_page_token)
        nextPage = obj.listConnectionsPage(page_token=listConnectionsResp.next_page_token);
        result = [result, nextPage.connections]; %#ok<AGROW>
    end
end