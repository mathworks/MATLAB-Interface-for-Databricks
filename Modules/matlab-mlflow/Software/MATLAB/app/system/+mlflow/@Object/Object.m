classdef Object < dynamicprops
    % OBJECT MLflow root object
    % Properties added to this object will be available on all mlflow
    % classes.

    %  (c) 2020-2024 MathWorks, Inc.

    properties(Hidden)
        Token = '';
        Host = '';
        Version = '2.0';
    end

    methods(Hidden)
        % Strip excess whitespace
        function candidateHost = iSanitizeHost(~,hostConfig)
            % Set Host
            if ~(ischar(hostConfig) || isStringScalar(hostConfig))
                error('Host must be a character vector or scalar string');
            end
            candidateHost = strip(hostConfig);
            if strlength(candidateHost) == 0
                error('Host value is not set');
            end
            % Allow http for possible local instances
            if ~(startsWith(candidateHost, 'https://') || startsWith(candidateHost, 'http://'))
                error('Expected host value to start with https:// or http://');
            end
            if strcmp(candidateHost(end),'/')
                % Trailing / has been used in the configuration
                % Strip it out.
                candidateHost = candidateHost(1:end-1);
            end
        end
    end

    methods
        %% Constructor
        function obj = Object(varargin)
            % By default, fetch the authentication info.
            obj.getAuth(varargin{:});
        end

        function uri = getURI(obj, api, method, varargin)
            % getURI Return a URI object
            %
            %    u = obj.getURI('experiments', 'list')
            %
            %  will return a matlab.net.URI, e.g. in the case of databricks:
            %    https://<REDACTED>.cloud.databricks.com/api/2.0/mlflow/experiments/list
            %
            %  If the function needs parameters, they can be added as pairs
            %
            %    u = obj.getURI('experiment', 'get', 'experiment_id', '123')
            %  will return a matlab.net.URI for the get experiment REST
            %  endpoint.
            %
            if rem(length(varargin),2) ~= 0
                error('Parameters must be provided in pairs of name/value');
            end
            if obj.isPreview(api)
                endpoint = [obj.Host,'/api/', obj.Version, '/preview/mlflow/',api,'/', method];
            else
                endpoint = [obj.Host,'/api/', obj.Version, '/mlflow/',api,'/', method];
            end
            uri = matlab.net.URI(endpoint, varargin{:});
        end

        function tf = isPreview(~, api)
            % Only needs to handle Model Version for now
            if strcmp(char(api), 'model_versions')
                tf = true;
            else
                tf = false;
            end
        end

        function getAuth(obj, varargin)
            if mlflow.Object.isDatabricks
                % obj.getDatabricksAuth(varargin{:})
                dbObj = databricks.Object;
                dbObj.getAuth(varargin{:});
            
                obj.Token = dbObj.Token;
                obj.Host = dbObj.Host;
            else
                % Authentication flow prior to support for the Databricks
                % unified authentication chain
                if nargin == 1
                    configData = obj.getConfig();
                    % Set Token
                    if isfield(configData, 'token')
                        obj.Token = configData.token;
                    end
                    % Host (handle trailing characters)
                    obj.Host = obj.iSanitizeHost(configData.host);
                elseif nargin == 2
                    % In this case, an alternative configuration file was used as an argument
                    authFile = varargin{1};
                    if isfile(authFile)
                        configData = mlflow.jsondecode(fileread(authFile));
                        obj.Token = configData.token;
                        obj.Host = obj.iSanitizeHost(configData.host);
                    else
                        error('No file at this location: %s\n', authFile);
                    end
                else
                    % Validate the inputs
                    validString = @(x) ischar(x) || isstring(x);
                    p = inputParser;
                    p.addOptional('Host','',validString);
                    p.addOptional('Token','',validString);
                    p.parse(varargin{:});
                    obj.Host = obj.iSanitizeHost(p.Results.Host);
                    obj.Token = p.Results.Token;
                end
            end
        end

        function configData = getConfig(~)
            % Return config values from a non Databricks config file if it exists
            % Error if no file is found

            authFile = mlflow.getConfigFile();
            if exist(authFile,'file')
                configData = jsondecode(fileread(authFile));
            end

            if isempty(configData)
                error("mlflow:Authorization", "No authorization data found, in config files");
            end
        end

    end

    methods (Static)
        function tf = isDatabricks()
            if exist('databricksRoot','file') == 2
                tf = true;
            else
                tf = false;
            end
        end
    end

    methods (Access = protected)
        function addStructureAsDynProps(obj, S)
            propList = fieldnames(S);

            for pCount = 1:numel(propList)
                % create the properties on the object
                if ~isprop(obj,propList{pCount})
                    addprop(obj,propList{pCount});
                end

                % populate the information about the object
                obj.(propList{pCount}) = S.(propList{pCount});
            end

        end

        function config = getConfigFromEnvVars(~)
            % getConfigFromEnvVars Deprecated function, will be removed in a future release
            config = struct;
            fprintf(2, "mlflow.Object.getConfigFromEnvVars has been deprecated and will be removed in a future release\n");
            fprintf(2, "Its functionality has been superseded by support for the Databricks unified authentication provider chain.");
        end
    end
end %class