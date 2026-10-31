function result = metastoreSummary(obj)
    % METASTORESUMMARY Gets information about a metastore.
    %
    % Example:
    %
    %   result = uc.metastoreSummary();
    %
    % Outputs:
    %   result
    %       Description:
    %           Summary of metastore information
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreInfo

    % Copyright 2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastore_summary');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.MetastoreInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end