function result = listRecipients(obj)
    % LISTRECIPIENTS lists delta sharing recipients.
    %
    % Example:
    %
    %   result = uc.listRecipients();
    %
    % Outputs:
    %   result
    %       Description:
    %           list of recipients
    %       Type:
    %           databricks.datastructures.unitycatalog.RecipientInfoList
    %
    % See Also: databricks.datastructures.unitycatalog.RecipientInfoList

    % Copyright 2022-2026 The MathWorks, Inc.

    % Get URI
    URI = obj.getURI('unity-catalog', 'recipients');

    % Start a GET request
    request = obj.getRequestMessage('GET');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.RecipientInfoList().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end