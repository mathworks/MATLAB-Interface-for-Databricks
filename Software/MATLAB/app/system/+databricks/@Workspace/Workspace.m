classdef Workspace < databricks.Object
    % WORKSPACE Databricks interface to manipulate Workspaces
    % Interface to connect to Databricks Workspaces via the
    % databricks 2.0 REST API. Please see the documentation at:
    % https://docs.databricks.com/api/latest/index.html
    %
    % For example:
    %
    %   % Create a Databricks Workspace
    %   ws = databricks.Workspace();
    
    % Copyright 2020-2026 The MathWorks, Inc.
    
    properties
        username = '';
    end

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    
    methods
        % Constructor
        function obj = Workspace(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
            
            % Set username property
            settings = databricks.internal.settings.Settings.getSettingsStruct();
            obj.username = settings.username;
        end
        
        function delete(obj, varargin)
            % DELETE Delete an object or a directory
            % Delete an object or a directory (and optionally recursively deletes
            % all objects in the directory). If path does not exist errors with
            % RESOURCE_DOES_NOT_EXIST. If path is a non-empty directory and
            % logical recursive argument is set to false errors with
            % DIRECTORY_NOT_EMPTY. Object deletion cannot be undone and deleting
            % a directory recursively is not atomic.
            %
            % Example
            %    ws = databricks.Workspace();
            %    path = '/Users/joe@example.com/myproject';
            %    recurse = true;
            %    ws.delete(path, recurse)
            
            % validate input
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'delete';
            % path is optional as maybe calling destructor
            validString = @(x) ischar(x) || isStringScalar(x);
            addOptional(p,'pathArg', '', validString);
            addOptional(p,'recursive', false, @islogical);
            parse(p,varargin{:});
            
            if isempty(p.Results.pathArg)
                % call destructor on the object
            else
                
                curAPI = 'workspace';
                apiMethod = 'delete';
                curURI = obj.getURI(curAPI, apiMethod);
                
                % Create a request to create a secret scope
                request = obj.getRequestMessage;
                request.Method = matlab.net.http.RequestMethod.POST;
                
                request.Body = matlab.net.http.MessageBody;
                s = struct;
                s.path = p.Results.pathArg;
                s.recursive = p.Results.recursive;
                request.Body.Payload = jsonencode(s);
                
                % Call Databricks
                resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
                % Process the response
                if resp.StatusCode == matlab.net.http.StatusCode.OK
                    disp(['Deleted object or directory: ', char(s.path)]);
                else
                    matlab.databricks.internal.responseError(resp, sprintf('Failed to delete object or directory: %s', char(s.path)));
                end
            end
        end %function
    end %methods
    
end %class
