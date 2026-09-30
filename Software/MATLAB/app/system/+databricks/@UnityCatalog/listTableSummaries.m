function result = listTableSummaries(obj,catalog_name,optionals)
    % LISTTABLESUMMARIES lists high level table information for tables in a
    % given catalog. Allows searching for tables based on schema name
    % patterns and table name patterns. 
    %
    % The output may be paged. listTableSummaries does *not* automatically
    % retrieve all pages. Call the method again with a 'page_token'
    % Name-Value pair to manually retrieve the pages as desired.
    %
    % Example:
    %
    %   result = uc.listTableSummaries(catalog_name);    
    %   result = uc.listTableSummaries(catalog_name,'table_name_pattern','SomePat%');        
    %
    % Required Inputs:
    %   catalog_name  
    %       Description:
    %           Name of the catalog
    %       Type:
    %           string
    %
    % Optional Inputs Provided as Name-Value Pairs:
    %   'schema_name_pattern'
    %       Description:
    %          SQL LIKE style pattern to search for tables based on
    %          (partial) schema name.
    %       Type:
    %           string
    %   'table_name_pattern'
    %       Description:
    %          SQL LIKE style pattern to search for tables based on
    %          (partial) table name.
    %       Type:
    %           string
    %   'max_results'
    %       Description:
    %           Limit on number of results to return
    %       Type:
    %           int32
    %   'page_token'
    %       Description:
    %           Page token. If a previous output of listTableSummaries
    %           contained a next_page_token, this next_page_token can be
    %           provided here as page_token to retrieve the next page of
    %           results.
    %       Type:
    %           string
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of tables
    %       Type:
    %           databricks.datastructures.unitycatalog.TableSummariesResp
    %
    % See Also: databricks.datastructures.unitycatalog.TableSummariesResp  
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        % Name of parent Catalog for Schemas and Tables of interest	
        catalog_name string
        % A SQL LIKE pattern (supporting % and _) specifying names of Schemas of interest	
        optionals.schema_name_pattern string
        % A SQL LIKE pattern (supporting % and _) specifying names of Tables of interest	
        optionals.table_name_pattern string
        % Maximum number of tables to return (i.e., the page length); defaults to 1000	
        optionals.max_results int32
        % Opaque token to send for the next page of results	
        optionals.page_token string
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'table-summaries');
    URI.Query(end+1) = matlab.net.QueryParameter("catalog_name",catalog_name);
    for field = string(fieldnames(optionals))'
        URI.Query(end+1) = matlab.net.QueryParameter(field,optionals.(field));
    end

    % Start a POST request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.TableSummariesResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end
