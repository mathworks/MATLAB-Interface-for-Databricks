function result = getSchema(obj, name)
    % GETSCHEMA gets schema information.
    %
    % Example:
    %
    %   result = uc.getSchema(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the schema
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the schema
    %       Type:
    %           databricks.datastructures.unitycatalog.SchemaInfo
    %
    % Throws an error if the specified schema cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.SchemaInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'schemas');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.SchemaInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end