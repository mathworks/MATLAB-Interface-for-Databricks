function result = getConnection(obj, name)
    % GETCONNECTION gets connection information.
    %
    % Example:
    %
    %   result = uc.getConnection(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the connection
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the connection
    %       Type:
    %           databricks.datastructures.unitycatalog.Connection
    %
    % Throws an error if the specified connection cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.Connection
    
    % Copyright 2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'connections');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.Connection().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end