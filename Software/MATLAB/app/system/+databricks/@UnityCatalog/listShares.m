function result = listShares(obj)
    % LISTSHARES lists delta sharing shares.
    %
    % Example:
    %
    %   result = uc.listShares();
    %
    % Outputs:
    %   result  
    %       Description:
    %           list of shares
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.ShareInfoList

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ShareInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end