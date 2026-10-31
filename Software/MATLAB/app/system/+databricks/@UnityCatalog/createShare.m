function result = createShare(obj, shareinfo)
    % CREATESHARE creates new delta sharing share. Use this to first create
    % a new share with only a name (and possibly comment) set. Then use
    % updateShareObjects to add objects to the share and
    % updateSharePermissions to grant access to recipients.
    %
    % Example:
    %
    %   result = uc.createShare(shareinfo);
    %
    % Required Inputs:
    %   shareinfo  
    %       Description: 
    %           settings/configuration for the new share
    %       Type: 
    %           databricks.datastructures.unitycatalog.ShareInfo
    %       Required Properties in the data structure which must be set:
    %           name
    %       Optional Properties in the data structure which can be:
    %           comment
    %
    % Outputs:
    %   result  
    %       Description:
    %           settings/configuration of the created share
    %       Type:
    %           databricks.datastructures.unitycatalog.ShareInfo    
    %
    % See Also: databricks.datastructures.unitycatalog.ShareInfo,
    %           updateShareObjects, updateSharePermissions
    
    % Copyright 2022 The MathWorks, Inc.
    
    arguments
        obj databricks.UnityCatalog
        shareinfo databricks.datastructures.unitycatalog.ShareInfo
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'shares');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "name"
    ]; %#ok<NBRAK2> 

    optionalProperties = [
        "comment"
    ]; %#ok<NBRAK2> 

    request.Body(1).Payload = shareinfo.getPayload(requiredProperties,optionalProperties);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.ShareInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end