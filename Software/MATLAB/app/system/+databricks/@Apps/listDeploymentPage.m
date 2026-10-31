function [result, errorResponse] = listDeploymentPage(obj, appName, options)
    % listDeploymentPage Retrieves a list of apps, one page at a time.
    % Returns an array of databricks.datastructures.apps.ListDeploymentResult objects and
    % a databricks.datastructures.ErrorResponse object.
    %
    % Example:
    %   a = databricks.App();
    %   [result, errorResponse] = a.listDeploymentPage("myapp");
    %
    % Optional arguments:
    %      pageSize: Upper bound for items returned.
    %     pageToken: Token for pagination
    %
    % See also: databricks.Apps.listPages
    %           https://docs.databricks.com/api/workspace/apps/listdeployments

    % (c) 2026 MathWorks, Inc.

    arguments (Input)
        obj databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 {mustBePositive}
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.ListDeploymentResult
        errorResponse databricks.datastructures.ErrorResponse
    end

    URI = obj.getURI('apps', appName);
    URI.Path(end+1) = 'deployments';

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
        result = databricks.datastructures.apps.ListDeploymentResult().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.apps.ListDeploymentResult.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
