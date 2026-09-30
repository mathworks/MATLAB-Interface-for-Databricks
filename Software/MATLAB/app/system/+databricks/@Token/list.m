function tokenList = list(obj)
    % LIST Method to list existing tokens on the Databricks interface
    % List the existing tokens on databricks account using the REST API.
    %
    % Example:
    %   t = databricks.Token()
    %   l = t.list();

    %  (c) 2019-2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) databricks.Token
    end
    arguments (Output)
        tokenList databricks.Token
    end

    % Create the request to create the tokens
    tokenURI = obj.getURI('token', 'list');

    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(tokenURI, databricks.internal.getHTTPOptions(convertResponse=false));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Minimal JSONMapper use pending full conversion of class
        jmListResult = databricks.datastructures.token.ListResponse().fromJSON(resp.Body.Data);
        % Convert to a struct to retain backward compatibility
        % tokenList = databricks.Token.fromJSON(jsonencode(resp.Body.Data));
        tokenList = convToLegacyTokenObjs(jmListResult);
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end
end

% For use with legacy objects only
function result = convToLegacyTokenObjs(tokenList)
    arguments(Input)
        tokenList databricks.datastructures.token.ListResponse
    end
    arguments(Output)
        result databricks.Token
    end
        
    result(1, numel(tokenList.token_infos)) = databricks.Token;
    for n = 1:numel(tokenList.token_infos)
        result(n) = databricks.Token();
        result(n).token_value = '';
        result(n).token_info = tokenInfo2struct(tokenList.token_infos(n));
    end
end