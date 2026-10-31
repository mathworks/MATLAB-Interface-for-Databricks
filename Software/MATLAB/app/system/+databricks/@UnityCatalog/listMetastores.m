function result = listMetastores(obj)
    % LISTMETASTORES lists metastores.
    %
    % Example:
    %
    %   result = uc.listMetastores();
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of metastores
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreInfoList

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastores');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.MetastoreInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end