function result = listConnectionsPage(obj, options)
    % LISTCONNECTIONSPAGE gets list of connections.
    %
    % Example:
    %
    %   result = uc.listConnectionsPage();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of catalogs
    %       Type:
    %           databricks.datastructures.unitycatalog.ListConnectionsResp
    %
    % See Also: databricks.datastructures.unitycatalog.ListConnectionsResp
    %           https://docs.databricks.com/api/workspace/connections/list
    % 
    
    % API pagination requirement, i.e. support only the future proof paginated API

    % Databricks:
    % NOTE: we recommend using max_results=0 to use the paginated version of this API.
    % Unpaginated calls will be deprecated soon.
    % PAGINATION BEHAVIOR: When using pagination (max_results >= 0), a page may contain
    % zero results while still providing a next_page_token. Clients must continue
    % reading pages until next_page_token is absent, which is the only indication
    % that the end of results has been reached.

    % Copyright 2026 The MathWorks, Inc.

    arguments (Input)
        obj databricks.UnityCatalog
        options.page_token string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    URI = obj.getURI('unity-catalog', 'connections');

    URI.Query(end+1) = matlab.net.QueryParameter("max_results", 0);
    if isfield(options, "page_token")
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", options.page_token);
    end

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ListConnectionsResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end