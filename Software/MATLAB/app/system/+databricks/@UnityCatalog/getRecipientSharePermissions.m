function result = getRecipientSharePermissions(obj, name)
    % GETRECIPIENTSHAREPERMISSIONS gets permissions for the given delta share recipient.
    %
    % Example:
    %
    %   result = uc.getRecipientSharePermissions(name);
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
    %           share permissions for each share shared with the specified
    %           recipient
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
    %
    % Throws an error if the specified recipient cannot be found.
    %
    % See Also: databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');
    URI.Path(end+1) = name;
    URI.Path(end+1) = "share-permissions";
    
    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end