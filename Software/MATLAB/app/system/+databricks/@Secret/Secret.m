classdef Secret < databricks.Object
    % SECRET Databricks Secrets API
    % The Secrets API allows you to create, and manage secrets. The key must
    % consist of alphanumeric characters, dashes, underscores and periods only
    % and cannot exceed 128 characters. The maximum allowed secret value size is
    % 128KB. The maximum number of secrets in a given scope is 1000. The secret
    % value may be a character vector or byte array of type uint8.
    %
    %  Example
    %    secret = databricks.Secret;
    %    secret.scope = 'myScope';
    %    secret.key = 'myKey';
    %    secret.setValue('mySecretValue');
    %    secret.put
    %    secretTable = secret.list;
    %    secret.delete('myScope','myKey');

    % TODO determine if the spec allows 128 double byte characters or not

    %  (c) 2020-2026 The MathWorks, Inc.

    properties
        scope = '';
        key = '';
    end

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    % Limit potential for accidental disclosure to the secret value via logs etc.
    properties (Hidden = true, Access = private)
        value;
    end

    methods
        % Constructor
        function obj = Secret(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end


        function set.scope(obj, val)
            obj.scope = obj.validateScope(val);
        end


        function scope = validateScope(~, val)
            if ischar(val) || isStringScalar(val)
                if (strlength(val) > 128) || (strlength(val) == 0)
                    error('DATABRICKS:ERROR','Invalid scope length, must not exceed 128 characters');
                else
                    cVal = char(val);
                    matchIdx = regexp(cVal, '[\.\w-]');
                    if numel(matchIdx) == numel(cVal)
                        scope = cVal;
                    else
                        error('DATABRICKS:ERROR','Secret scope can contain only alphanumeric characters, dashes, underscores, and periods');
                    end
                end
            else
                error('DATABRICKS:ERROR','Secret scope must be of type scalar string or character vector');
            end
        end


        function key = validateKey(~, val)
            if ischar(val) || isStringScalar(val)
                if (strlength(val) > 128) || (strlength(val) == 0)
                    error('DATABRICKS:ERROR','Invalid key length, must not exceed 128 characters');
                else
                    cVal = char(val);
                    matchIdx = regexp(cVal, '[\.\w-]');
                    if numel(matchIdx) == numel(cVal)
                        key = cVal;
                    else
                        error('DATABRICKS:ERROR','Secret key can contain only alphanumeric characters, dashes, underscores, and periods');
                    end
                end
            else
                error('DATABRICKS:ERROR','Secret key must be of type scalar string or character vector');
            end
        end


        function set.value(obj, val)
            maxSize = 128 * 1024;

            if ischar(val) || isStringScalar(val)
                cVal = char(val);
                cValW = whos('cVal');
                if cValW.bytes > maxSize
                    error('DATABRICKS:ERROR','Secret value must be 128KB or less in size');
                else
                    obj.value = cVal;
                end
            elseif isa(val, 'uint8')
                if numel(val) > maxSize
                    error('DATABRICKS:ERROR','Secret value must be 128KB or less in size');
                else
                    obj.value = val;
                end
            else
                error('DATABRICKS:ERROR','Secret key must be of type scalar string, character vector or uint8');
            end
        end


        function delete(obj, varargin)
            % DELETE Delete a Databricks secret
            % Errors with RESOURCE_DOES_NOT_EXIST if the scope does not exist or
            % PERMISSION_DENIED if the user does not have permission to make the call.
            % The scope and key pair to delete should be provided as arguments
            % regardless of whether are set in the underlying Secret object.
            %
            % Example
            %    secret.delete('myScope','myKey')
            %    Deleted secret: myScope : myKey

            % validate input
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'delete';
            % scopeArg is optional as maybe calling destructor
            validString = @(x) ischar(x) || isstring(x);
            addOptional(p,'scopeArg',[], validString);
            addOptional(p,'keyArg',[], validString);
            parse(p,varargin{:});

            if isempty(p.Results.scopeArg)
                % call destructor on the object
            else
                scopeArg = obj.validateScope(p.Results.scopeArg);
                if isempty(p.Results.keyArg)
                    error('DATABRICKS:ERROR','Secret key argument not set');
                else
                    keyArg = obj.validateScope(p.Results.keyArg);
                end

                curAPI = 'secrets';
                apiMethod = 'delete';
                curURI = obj.getURI(curAPI, apiMethod);

                % Create a request to create a secret scope
                request = obj.getRequestMessage;
                request.Method = matlab.net.http.RequestMethod.POST;

                request.Body = matlab.net.http.MessageBody;
                s = struct;
                s.scope = scopeArg;
                s.key = keyArg;
                request.Body.Payload = jsonencode(s);

                % Call Databricks
                resp = request.send(curURI, getHTTPOptions);
                % Process the response
                if resp.StatusCode == matlab.net.http.StatusCode.OK
                    disp(['Deleted secret: ', char(s.scope), ' : ', char(s.key)]);
                else
                    matlab.databricks.internal.responseError(resp, sprintf('Failed to delete secret: %s : %s', char(s.scope), char(s.key)));
                end
            end
        end

    end %methods
end %class
