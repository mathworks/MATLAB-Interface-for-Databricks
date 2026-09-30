function obj = create(obj, varargin)
    % CREATE Method to create a model version
    %
    % A mlflow.ModelVersion object is returned. It is the new version number
    % generated for this model in registry.
    %
    % Example:
    %
    %   mv = mlflow.ModelVersion;
    %   result = mv.create();
    %

    %  Copyright 2021-2022 MathWorks, Inc.

    %% Create a new model version
    clusterURI = obj.getURI('model-versions', 'create');
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload;

    % Call mlflow to create the model version
    % Don't decode the json with the built in approach so that creation_timestamp & last_updated_timestamp
    % can be explicitly converted to int64s
    [resp, complete, history] = request.send(clusterURI, getHTTPOptions('ConvertResponse', false)); %#ok<ASGLU> 

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;
        resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"model_version", "creation_timestamp"}, "int64", {"model_version", "last_updated_timestamp"}, "int64");  %#ok<CLARRSTR>
        propNames = fieldnames(resp.Body.Data);
        if ~isempty(propNames)
            % Ensure that we have the model version response
            if isfield(resp.Body.Data,'model_version')
                if isfield(resp.Body.Data.model_version, 'creation_timestamp')
                    resp.Body.Data.model_version.creation_timestamp = datetime(resp.Body.Data.model_version.creation_timestamp, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
                end
                if isfield(resp.Body.Data.model_version, 'last_updated_timestamp')
                    resp.Body.Data.model_version.last_updated_timestamp = datetime(resp.Body.Data.model_version.last_updated_timestamp, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
                end
                % We have a non-empty response
                obj.initFromStructInternal(resp.Body.Data.model_version);
            else
                error('MLFLOW:ERROR', 'Failed to create model version\n%s', char(resp));
            end
        else
            error('MLFLOW:ERROR', 'Failed to create model version\n%s', char(resp));
        end
    else
        % Could not create model version
        error('MLFLOW:ERROR', 'Failed to create model version\n%s', char(resp));
    end

end %function
