function result = createSchema(obj, schemainfo)
    % CREATESCHEMA creates a new schema.
    %
    % Example:
    %
    %   result = uc.createSchema(schemainfo);
    %
    % Required Inputs:
    %   schemainfo
    %       Description:
    %           settings/configuration for the new schema
    %       Type:
    %           databricks.datastructures.unitycatalog.SchemaInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %           catalog_name
    %       Optional Properties in the data structure which can be set:
    %           comment
    %           ucproperties
    %
    % See Also: databricks.datastructures.unitycatalog.SchemaInfo

    % Copyright 2022 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        schemainfo databricks.datastructures.unitycatalog.SchemaInfo
    end
    
    % Get URI
    URI = obj.getURI('unity-catalog', 'schemas');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name", ...
        "catalog_name"
    ];

    optionalProperties = [
        "comment", ...
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