function result = getRecipient(obj, name)
    % GETRECIPIENT gets delta sharing recipient information.
    %
    % Example:
    %
    %   result = uc.getRecipient(name);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of the recipient
    %       Type:
    %           string
    %
    % Outputs:
    %   result
    %       Description:
    %           settings/configuration of the recipient
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfo
    %
    % Throws an error if the specified recipient cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.RecipientInfo

    % Copyright 2022 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');
    URI.Path(end+1) = name;

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.RecipientInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end