function result = deleteVolume(obj, name)
    % DELETEVOLUME deletes a volume.
    %
    % Example:
    %
    %   result = uc.deleteVolume(name);
    %
    % Required Inputs:
    %   name  
    %       Description: 
    %           The three-level (fully qualified) name of the volume
    %           e.g.: "main.default.my_volume"
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

    % Copyright 2024-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'volumes');
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