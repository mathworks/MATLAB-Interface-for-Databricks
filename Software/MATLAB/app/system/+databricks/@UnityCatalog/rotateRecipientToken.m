function result = rotateRecipientToken(obj, name, rotaterecipienttoken)
    % ROTATERECIPIENTTOKEN rotates the token for an external delta sharing recipient.
    % (TOKEN not DATABRICKS based)
    %
    % Example:
    %
    %   result = uc.rotateRecipientToken(name, rotaterecipienttoken);
    %
    % Required Inputs:
    %   name
    %       Description:
    %           name of recipient
    %       Type:
    %           string
    %   rotaterecipienttoken
    %       Description:
    %           Specifies when the previous token expires. This can make
    %           the token expire sooner not move its expiry further into
    %           the future. Set existing_token_expire_in_seconds to 0 to
    %           expire immediately.
    %       Type:
    %           databricks.datastructures.unitycatalog.RotateRecipientToken
    %       Required Properties in the data structure which must be set:
    %           existing_token_expire_in_seconds
    %
    % Outputs:
    %   result
    %       Description:
    %           updated recipient information
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfo
    %
    % See Also: databricks.datastructures.unitycatalog.RotateRecipientToken,
    %           databricks.datastructures.unitycatalog.RecipientInfo

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj databricks.UnityCatalog
        name string {mustBeTextScalar}
        rotaterecipienttoken databricks.datastructures.unitycatalog.RotateRecipientToken
    end

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');
    URI.Path(end+1) = name;
    URI.Path(end+1) = "rotate-token";
    
    % Start a POST request
    request = obj.getRequestMessage('POST');

    % Set the body
    requiredProperties = [
        "existing_token_expire_in_seconds"
    ]; %#ok<NBRAK2> 

    optionalProperties = [ ];

    request.Body(1).Payload = rotaterecipienttoken.getPayload(requiredProperties,optionalProperties);    

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.RecipientInfo().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end