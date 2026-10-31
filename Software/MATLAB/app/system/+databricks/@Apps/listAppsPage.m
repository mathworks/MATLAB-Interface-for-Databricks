function [result, errorResponse] = listAppsPage(obj, options)
    % listAppsPage Retrieves a list of apps, one page at a time.
    % Returns an array of databricks.datastructures.apps.ListAppResult objects and
    % a databricks.datastructures.ErrorResponse object.
    %
    % Example:
    %   a = databricks.App();
    %   [result, errorResponse] = a.listAppsPage("myapp");
    %
    % Optional arguments:
    %      pageSize: Upper bound for items returned.
    %     pageToken: Token for pagination
    %
    % See also: databricks.Apps.listAppsPages
    %           https://docs.databricks.com/api/workspace/apps/list

    % (c) 2026 MathWorks, Inc.

    arguments (Input)
        obj databricks.Apps
        options.pageSize (1,1) int32 {mustBePositive}
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.ListAppsResult
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI('apps', '');
    
    if isfield(options, "pageSize")
        URI.Query(end+1) = matlab.net.QueryParameter("page_size", options.pageSize);
    end
    if isfield(options, "pageToken")
        URI.Query(end+1) = matlab.net.QueryParameter("page_token", options.pageToken);
    end
   
    
    % Get 1st page
    request = obj.getRequestMessage('GET');
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.apps.ListAppsResult().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.ListAppsResult.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
