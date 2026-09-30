function result = getMetastore(obj, id)
    % GETMETASTORE gets metastore information.
    %
    % Example:
    %
    %   result = uc.getMetastore(id);
    %
    % Required Inputs:
    %   id
    %       Description:
    %           id of the metastore
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the metastore
    %       Type:
    %           databricks.datastructures.unitycatalog.MetastoreInfo
    %
    % Throws an error if the specified metastore cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.MetastoreInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        id string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastores');
    URI.Path(end+1) = id;

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