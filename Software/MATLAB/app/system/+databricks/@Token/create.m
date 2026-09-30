function create(obj, duration, comment, options)
    % CREATE Create a databricks token with a specified lifetime
    % This call returns the error QUOTA_EXCEEDED if the caller exceeds the token
    % quota, which is 600. The token object is updated with a created value.
    %
    %   create(durationInSeconds, commentString);
    %
    % Example:
    %
    %   % Create a handle to the Token interface
    %   token = databricks.Token();
    %   token.create(100, 'Sample Comment');
    %
    % Following create the token object will contain the ID, creation time, expiry
    % time and value required to work with the databricks API.
    %
    %   token =
    %         Token with properties:
    %           token_value: "<REDACTED>"
    %            token_info: [1x1 struct]
    %
    %   token.token_info is a struct with fields:
    %
    %          comment: "Sample Comment"
    %    creation_time: 05-Aug-2026 11:32:04
    %      expiry_time: 05-Aug-2026 11:33:44
    %           scopes: [0×0 string]
    %         token_id: "f5db25c85b5c21b7a042b728ebba57c7c866f57a29a1959a41a6c4944bae618d"
    %
    % Create a token with specific scopes using a named argument `scopes` set to a character
    % vector, string or string array.
    %
    %   token = databricks.Token();
    %   token.create(100, 'Sample Comment', scopes=["unity-catalog", "clusters"]);
    %
    % The first argument `lifetime_seconds` can also be specified as a MATLAB duration
    % and it will be converted accordingly.
        
    %   (c) 2019-2026 MathWorks, Inc.

    arguments(Input)
        obj databricks.Token
        duration (1,1)
        comment string = string.empty
        options.scopes string {mustBeNonzeroLengthText}
    end

    if isa(duration, 'duration')
        duration = int64(seconds(duration));
    elseif isnumeric(duration) && ~isa(duration, "logical") && isreal(duration) && isfinite(duration) && gt(duration, 0) && lt(duration, intmax("int64"))
        duration = int64(duration);
    else
        error('DATABRICKS:TOKEN:CREATE:DURATION', "Invalid lifetime_seconds value, use a scalar duration or int64.");
    end

    % Create the request to create the tokens
    tokenURI = obj.getURI('token', 'create');
    request = obj.getRequestMessage('POST');

    % Minimal use of a JSONMapper class pending a wider update of the Token class
    createRequest = databricks.datastructures.token.CreateRequest();

    createRequest.lifetime_seconds = duration;

    if ~isempty(comment)
        createRequest.comment = comment;
    end

    if isfield(options, "scopes")
        createRequest.scopes = options.scopes;
    end

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = createRequest.getPayload;
    resp = request.send(tokenURI, databricks.internal.getHTTPOptions(convertResponse=false));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        cr = databricks.datastructures.token.CreateResponse().fromJSON(resp.Body.Data);
        obj.token_value = cr.token_value;
        obj.token_info = cr.token_info.tokenInfo2struct();
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end
end
