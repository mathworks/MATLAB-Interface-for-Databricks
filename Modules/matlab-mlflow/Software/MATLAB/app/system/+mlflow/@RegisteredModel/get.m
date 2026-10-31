function obj = get(name)
    % GET Method to get a registered model
    % 
    % name must be provided as a scalar string or character vector. It is the
    % name of the registered model.
    %
    % An mlflow.RegisteredModel object is returned.
    % 
    % Example:
    % 
    %   rm = mlflow.RegisteredModel;
    %   result = rm.get('modelName');
    % 
    
    %  Copyright 2021-2022 MathWorks, Inc.
    
    arguments
        name (1,1) string
    end

    obj = mlflow.RegisteredModel();

    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'get');
    request = obj.getRequestMessage('GET');
    
    % Create the request
%     payload.name = name;
%     request.Body = matlab.net.http.MessageBody;
%     request.Body.Payload = jsonencode(payload);
    QP = matlab.net.QueryParameter('name', name);
    clusterURI.Query = QP;

    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions);
    
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK

        rms = resp.Body.Data.registered_model;
        obj.initFromStructInternal(rms);
    else
        % Could not create experiment
        error('MLFLOW:ERROR', 'Failed to get registered model\n%s', char(resp));
    end

end %function
