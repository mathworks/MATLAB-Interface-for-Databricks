function revoke(obj, token_id)
    % REVOKE Method to revoke a databricks token
    % Revoke an API access token using the REST API.
    %
    % Example:
    %
    %   tokenInterface = databricks.Token();
    %   tokenInterface.revoke();

    %   (c) 2019-2026 MathWorks, Inc.

    arguments (Input)
        obj databricks.Token
        token_id string = string.empty
    end

    % Create the request to create the tokens
    tokenURI = obj.getURI('token', 'delete');
    request = obj.getRequestMessage('POST');

    s = struct;
    resetObj = false;
    if ~isempty(token_id) && strlength(token_id) > 0
        s.token_id = token_id;
    elseif isprop(obj, "token_info") && ~isempty(obj.token_info) ...
            && isfield(obj.token_info, "token_id") && ~isempty(obj.token_info.token_id) && strlength(obj.token_info.token_id) > 0
            s.token_id = obj.token_info.token_id;
            resetObj = true;
    else
        error('DATABRICKS:TOKEN:REVOKE:NOID', "No token id found.");
    end

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(s);

    resp = request.send(tokenURI, databricks.internal.getHTTPOptions(convertResponse=true));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if resetObj
            obj.token_info=[];
            obj.token_value=[];
        end
        fprintf('Successfully revoked token: %s\n', s.token_id);
    else
        fprintf('Failed to revoke token: %s\n', s.token_id);
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end
end 
