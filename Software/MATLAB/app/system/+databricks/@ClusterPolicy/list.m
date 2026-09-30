function result = list(obj, options)
    % LIST List Cluster Policies
    %
    % This method will return a list of the policies defined for this
    % Databricks account.
    % The return value is a structure with a field total_count. If
    % total_count is non-zero, it also contains a field policies.
    %
    % Optional named arguments
    %   sort_order     A databricks.datastructures.ListOrder
    %   sort_column    A databricks.datastructures.PolicySortColumn
    %
    % Example:
    %   cp = databricks.ClusterPolicy
    %   l = cp.list
    %   l = 
    %   ListResponse with properties:
    %       policies: [1x7 databricks.datastructures.clusterpolicy.Policy]
    %       totalCount: 7
    %
    % Two additional arguments exist, sort_order and sort_column.
    %
    % l = cp.list('sort_order', 'ASC')
    %
    % l = cp.list('sort_column', 'POLICY_NAME')
    %
    % See: https://docs.databricks.com/dev-tools/api/latest/policies.html

    % (c) 2022-2026 MathWorks, Inc.

    arguments
        obj %  (1,1) databricks.ClusterPolicy
        options.sort_order  (1,1) databricks.datastructures.clusterpolicy.ListOrder
        options.sort_column (1,1) databricks.datastructures.clusterpolicy.PolicySortColumn
    end

    args = {};
    if isfield(options, 'sort_order')
        args = {'sort_order', options.sort_order};
    end
    if isfield(options, 'sort_column')
        args = {args{:}, 'sort_column', options.sort_column}; %#ok<CCAT> 
    end

    clusterURI = obj.getURI('policies/clusters', 'list', args{:});
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.clusterpolicy.ListResponse().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.clusterpolicy.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
