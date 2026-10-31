function result = deleteMetastore(obj, id, force)
    % DELETEMETASTORE deletes a metastore.
    %
    % Example:
    %
    %   result = uc.deleteMetastore(id);    
    %   result = uc.deleteMetastore(id,true);    
    %
    % Required Inputs:
    %   id  
    %       Description: 
    %           id of the metastore to delete
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
        id string {mustBeTextScalar}
        force logical = false
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'metastores');
    URI.Path(end+1) = id;

    % Start a DELETE request
    request = obj.getRequestMessage('DELETE');

    if force
        URI.Query(end+1) = matlab.net.QueryParameter("force",true);
    end

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end