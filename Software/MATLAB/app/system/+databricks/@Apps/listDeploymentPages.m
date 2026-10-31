function [result, errorResponse] = listDeploymentPages(obj, appName, options)
    % listDeploymentPages Retrieves a list of all matching app.
    % This method supports pagination and will retrieve all pages.
    % This may have performance implications for large result sets.
    % Returns an array of databricks.datastructures.apps.AppDeployment and
    % a databricks.datastructures.ErrorResponse.
    %
    % Example:
    %   a = databricks.Apps;
    %   [result, errorResponse] = a.listDeploymentPages()
    %
    % Optional arguments:
    %      pageSize: Upper bound for items returned.
    %     pageToken: Token for pagination
    %
    % See also: databricks.Apps.listDeploymentPage
    %           https://docs.databricks.com/api/workspace/apps/listdeployments

    % (c) 2026 MathWorks, Inc.

    arguments (Input)
        obj databricks.Apps
        appName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pageSize (1,1) int32 {mustBePositive} = 20
        options.pageToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result databricks.datastructures.apps.AppDeployment
        errorResponse databricks.datastructures.ErrorResponse
    end

    % Get 1st page
    args = matlab.utils.addArgs(options, ["pageSize", "pageToken"]);
    [pageResult, pageErrorResponse] = obj.listDeploymentPage(appName, args{:});

    % If the first call failed just return
    if ~isempty(pageErrorResponse)
        result = databricks.datastructures.apps.AppDeployment.empty;
        errorResponse = pageErrorResponse;
        return;
    else
        result = pageResult.appDeployments;
        errorResponse = pageErrorResponse;
    end

    % Collect all results from subsequent pages
    args = matlab.utils.addArgs(options, "pageSize");
    while ~isempty(pageResult.nextPageToken) && strlength(pageResult.nextPageToken) > 0
        [pageResult, pageErrorResponse] = obj.listDeploymentPage(appName, "pageToken", pageResult.nextPageToken, args{:});
        result = [result, pageResult.appDeployments]; %#ok<AGROW>
        if ~isempty(pageErrorResponse)
            result = databricks.datastructures.apps.AppDeployment.empty();
            errorResponse = pageErrorResponse;
            return;
        end
    end
end
