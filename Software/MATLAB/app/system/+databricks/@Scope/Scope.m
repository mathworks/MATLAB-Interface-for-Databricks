classdef Scope < databricks.Object
    % Scope as used by Databricks Secrets API
    % scopes and initial_manage_principal values will be stored as character
    % vectors. Scope names must be unique within a workspace. They must consist
    % of alphanumeric characters, dashes, underscores, and periods, and may not
    % exceed 128 characters. The names are readable by all users of a workspace.
    % A workspace is limited to a maximum of 100 scopes. Scopes are typically
    % created with the initial_manage_principal set to 'users', consult
    % Databricks documentation for options which may vary with Databricks plan
    % type.
    %
    % Example
    %    scope = databricks.Scope;
    %    scope.scope = 'myScope';
    %    scope.initial_manage_principal = 'users';
    %    scope.create;
    %    scopes = scope.list;
    %    scope.delete('myScope');

    % TODO determine if the spec allows 128 double byte characters or not

    %   (c) 2020-2026 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    properties
        scope = '';
        initial_manage_principal = '';
    end

    methods
        % Constructor
        function obj = Scope(varargin)
            obj.Version = '2.0';
            obj.getAuth(varargin{:});
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=true);
        end


        % Must consist of alphanumeric characters, dashes, underscores, and periods
        % and may not exceed 128 characters.
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
                        error('DATABRICKS:ERROR','Scope scope can contain only alphanumeric characters, dashes, underscores, and periods');
                    end
                end
            else
                error('DATABRICKS:ERROR','Scope scope must be of type scalar string or character vector');
            end
        end


        function set.initial_manage_principal(obj, val)
            if ischar(val) || isStringScalar(val)
                obj.initial_manage_principal = char(val);
            else
                error('DATABRICKS:ERROR','Scope initial_manage_principal must be of type scalar string or character vector');
            end
        end


        function delete(obj, varargin)
            % DELETE Delete a Databricks secret scope
            % Errors with RESOURCE_DOES_NOT_EXIST if the scope does not exist or
            % PERMISSION_DENIED if the user does not have permission to make the call.
            % The scope name to delete should be provided as an argument
            % regardless of whether are set in the underlying Scope object.
            %
            % Example
            %    scope.delete('myScope')
            %    Deleted scope: myScope

            % validate input
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'delete';
            % scopeArg is optional as maybe calling destructor
            validString = @(x) ischar(x) || isstring(x);
            addOptional(p,'scopeArg',[], validString);
            parse(p,varargin{:});

            if isempty(p.Results.scopeArg)
                % call destructor on the object
            else
                scopeArg = obj.validateScope(p.Results.scopeArg);

                % Initializations
                curAPI = 'secrets/scopes';
                apiMethod = 'delete';
                curURI = obj.getURI(curAPI, apiMethod);

                % Create a request to create a secret scope
                request = obj.getRequestMessage('POST');

                request.Body = matlab.net.http.MessageBody;
                % Create a struct using only the scope property of the Scope
                % i.e. no initial_manage_principal
                s = struct;
                s.scope = scopeArg;
                request.Body.Payload = jsonencode(s);

                % Call Databricks
                resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
                % Process the response
                if resp.StatusCode == matlab.net.http.StatusCode.OK
                    disp(['Deleted scope: ', char(scopeArg)]);
                else
                    matlab.databricks.internal.matlab.databricks.internal.responseError(resp, sprintf('Failed to delete scope: %s', char(scopeArg)));
                end
            end
        end

    end %methods

end %class
