function result = deleteSchema(obj, name)
    % DELETESCHEMA deletes a schema.
    %
    % Example:
    %
    %   result = uc.deleteSchema(name);
    %
    % Required Inputs:
    %   name  
    %       Description: 
    %           name of the schema to delete
    %       Type: 
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           true is successful, never returns false (throws error if 
    %           unsuccessful)
    %       Type:
    %           logical
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'schemas');
    URI.Path(end+1) = name;

    % Start a DELETE request
    request = obj.getRequestMessage('DELETE');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end