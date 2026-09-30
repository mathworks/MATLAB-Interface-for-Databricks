function result = getTable(obj, name)
    % GETTABLE gets table information.
    %
    % Example:
    %
    %   result = uc.getTable(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the table
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the table
    %       Type:
    %           databricks.datastructures.unitycatalog.TableInfo
    %
    % Throws an error if the specified table cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.TableInfo
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'tables');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.TableInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end