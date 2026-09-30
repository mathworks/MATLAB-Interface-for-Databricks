function result = updateSchema(obj, name, schemainfo)
    % UPDATESCHEMA updates schema settings.
    %
    % Only the values which are actually set in the data structure will be
    % updated. To not update/change a value leave the property entirely
    % empty in the data structure.
    %
    % Example:
    %
    %   result = uc.updateSchema(name, schemainfo);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           (current) name of schema
    %       Type:
    %           string
    %   schemainfo
    %       Description:
    %           Information to update
    %       Type:
    %           databricks.datastructures.unitycatalog.SchemaInfo
    %       Optional Properties in the data structure which can be updated:
    %           name
    %           comment
    %           owner
    %           ucproperties
    %
    % Outputs:
    %   result
    %       Description:
    %           updated schema settings/configuration
    %       Type:
    %           databricks.datastructures.unitycatalog.SchemaInfo
    %
    % See Also: databricks.datastructures.unitycatalog.SchemaInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        schemainfo databricks.datastructures.unitycatalog.SchemaInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'schemas');
    URI.Path(end+1) = name;

    % Start a PATCH request
    request = obj.getRequestMessage('PATCH');

    % Set the body
    requiredProperties = [ ];

    optionalProperties = [
        "name", ...
        "comment", ...
        "owner", ...
        "ucproperties"
    ];

    request.Body(1).Payload = schemainfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.SchemaInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end