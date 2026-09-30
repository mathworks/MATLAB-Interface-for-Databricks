classdef Object < dynamicprops
    % OBJECT Databricks root object
    % Properties added to this object will be available on all databricks
    % classes.
    %
    % The Version property refers to the version of the Databricks REST API
    % to be used.
    %
    % For more information on provider chain based authentication details see:
    % https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
    %
    % See Documentation for further details: Documentation/Authentication.md

    %  (c) 2019-2026 MathWorks, Inc.

    properties(Dependent,Hidden)
        % Databricks Connect PAC or Oauth token
        Token
        % Databricks Endpoint
        Host
        % Version of the Databricks REST API to use by default
        Version
        % Databricks Org_id value (not always used on AWS)
        Org_id
        % Name of the profile used to authenticate
        Profile
        % Basic auth is deprecated and will be removed in a future release
        % Used by Basic authentication for account-level API calls
        AccountId
        % Used by Basic authentication for account & workspace level API calls
        Username
        % Used by Basic authentication for account & workspace level API calls
        Password
        % Used by OauthM2M authentication
        ClientId
        % Used by OauthM2M authentication
        ClientSecret
        % AuthMethod to use
        AuthMethod
        % UserAgent used for telemetry 
        UserAgent
    end
    
    properties(SetAccess = private, Hidden)
        objectImpl databricks.internal.Object;
    end

    methods
        function val = get.Token(obj)
            val = obj.objectImpl.Token;
        end

        function set.Token(obj, val)
            obj.objectImpl.Token = val;
        end

        function val = get.Host(obj)
            val = obj.objectImpl.Host;
        end

        function set.Host(obj, val)
            obj.objectImpl.Host = val;
        end

        function val = get.Version(obj)
            val = obj.objectImpl.Version;
        end

        function set.Version(obj, val)
            obj.objectImpl.Version = val;
        end

        function val = get.Org_id(obj)
            val = obj.objectImpl.Org_id;
        end

        function set.Org_id(obj, val)
            obj.objectImpl.Org_id = val;
        end

        function val = get.Profile(obj)
            val = obj.objectImpl.Profile;
        end

        function set.Profile(obj, val)
            obj.objectImpl.Profile = val;
        end

        function val = get.AccountId(obj)
            val = obj.objectImpl.AccountId;
        end

        function set.AccountId(obj, val)
            obj.objectImpl.AccountId = val;
        end

        function val = get.Username(obj)
            val = obj.objectImpl.Username;
        end

        function set.Username(obj, val)
            obj.objectImpl.Username = val;
        end

        function val = get.Password(obj)
            val = obj.objectImpl.Password;
        end

        function set.Password(obj, val)
            obj.objectImpl.Password = val;
        end

        function val = get.ClientId(obj)
            val = obj.objectImpl.ClientId;
        end

        function set.ClientId(obj, val)
            obj.objectImpl.ClientId = val;
        end

        function val = get.ClientSecret(obj)
            val = obj.objectImpl.ClientSecret;
        end

        function set.ClientSecret(obj, val)
            obj.objectImpl.ClientSecret = val;
        end

        function val = get.AuthMethod(obj)
            internal = obj.objectImpl.AuthMethod;
            if isempty(internal)
                val = matlab.databricks.AuthMethod.empty;
            else
                val = matlab.databricks.AuthMethod.(string(internal));
            end
        end

        function set.AuthMethod(obj, val)
            obj.objectImpl.AuthMethod = string(val);
        end

        function val = get.UserAgent(obj)
            val = obj.objectImpl.UserAgent;
        end

        function set.UserAgent(obj, val)
            obj.objectImpl.UserAgent = val;
        end
    end

    methods
        % Constructor
        function obj = Object(~, varargin)
            obj.objectImpl = databricks.internal.Object(varargin{:});
        end
    end                                                                                                                                                                                         

    methods
        function uri = getURI(obj, api, method, varargin)
            % getURI Return a matlab.net.URI object
            %
            % Examples:
            %  % Return a matlab.net.URI for https://<host>/api/2.0/clusters/list
            %  u = obj.getURI('clusters', 'list')
            %
            %  % If the function needs parameters, they can be added as pairs
            %  % Return a matlab.net.URI for https://<host>/api/2.0/clusters/get?cluster_id=123
            %  u = obj.getURI('clusters', 'get', 'cluster_id', '123')
             uri = obj.objectImpl.getURI(api, method, varargin{:});
        end


        function tf = isPreview(obj, varargin)
            tf = obj.objectImpl.isPreview(varargin{:});
        end


        function getAuth(obj, varargin)
            % getAuth Populates the authentication configuration values in the databricks.Object class
            % Sets Host, Profile & Token
            for i = 1:2:numel(varargin)
                if strcmp(varargin{i}, 'authMethod') && isa(varargin{i+1}, 'matlab.databricks.AuthMethod')
                    varargin{i+1} = varargin{i+1}.authMethodImpl;
                end
            end
            obj.objectImpl.getAuth(varargin{:});
        end
    end


    methods (Access = protected)
        function addStructureAsDynProps(obj, S)
            propList = fieldnames(S);

            timeStampFields = {...
                'created_at', ...
                'created_at_timestamp', ...
                'updated_at', ...
                'start_time', ...
                'created_time', ...
                'end_time', ...
                'terminated_time', ...
                'last_state_loss_time', ...
                'last_activity_time', ...
                'last_restarted_time'...
                };

            for pCount = 1:numel(propList)
                propName = propList{pCount};

                % create the properties on the object
                val = S.(propName);

                if ismember(propName, timeStampFields)
                    val = databricks.Object.epochToTimestamp(val);
                end

                % populate the information about the object
                setprop(obj, propName, val);
            end
        end

        function rmpropif(obj, propName)
            % rmpropif Remove a property if it exists
            if isprop(obj, propName)
                prop = findprop(obj, propName);
                delete(prop);
            end
        end

        function setprop(obj, propName, propValue)
            % setprop Set a property on an object
            % If the property doesn't already exist, it will be added
            if ~isprop(obj, propName)
                addprop(obj, propName);
            end
            obj.(propName) = propValue;
        end
    end


    methods(Static)
        function userAgent = getUserAgent(varargin)
            % getUserAgent Returns user agent based on a MATLAB Release value
            % Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
            % By default the current release is used.
            %
            % Example:
            %   userAgent = databricks.Object.getUserAgent(release="R2025b");
            userAgent = databricks.internal.Object.getUserAgent(varargin{:});      
        end
    end


    methods(Static, Hidden)
        function result = sanitizeHost(varargin)
            % sanitizeHost Cleans up host values
            % Leading and trailing white space is removed.
            % If the host is of length zero this is returned, with an
            % optional warning.
            % If the host has a trailing / it is removed.
            % If the host does not start with https:// (case insensitive) a
            % warning is produced.
            result = databricks.internal.Object.sanitizeHost(varargin{:});     
        end %class


        function ts = epochToTimestamp(epoch)
            ts = databricks.internal.Object.epochToTimestamp(epoch);
        end
    end
end