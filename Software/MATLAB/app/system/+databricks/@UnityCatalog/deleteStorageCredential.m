function result = deleteStorageCredential(obj, name, force)
    % DELETESTORAGECREDENTIAL deletes a storage credential.
    %
    % Example:
    %
    %   result = uc.deleteStorageCredential(name);
    %   result = uc.deleteStorageCredential(name,true);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the storage credential to delete
    %       Type:
    %           string
    %
    % Optional Inputs:
    %   force
    %       Description:
    %           force delete
    %       Type:
    %           logical
    %       Default value:
    %           false
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
        force logical = false;
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'storage-credentials');
    URI.Path(end+1) = name;
    if force
        URI.Query(end+1) = matlab.net.QueryParameter('force','true');
    end
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