function result = deleteConnection(obj, name)
    % DELETECONNECTION deletes a Connection.
    %
    % Example:
    %
    %   result = uc.deleteConnection(name);
    %
    % Required Inputs:
    %   name  
    %       Description: 
    %           name of the catalog to delete
    %       Type: 
    %           string
    % Outputs:
    %   result
    %       Description:
    %           true is successful, never returns false (throws error if 
    %           unsuccessful)
    %       Type:
    %           logical
    %
    % See Also: https://docs.databricks.com/api/workspace/connections/delete
    
    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'connections');
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