function obj = update(obj, description)
    % UPDATE Method to update a registered model
    % 
    % name must be provided as a scalar string or character vector. It is the
    % name of the registered model.
    %
    % An optional new description can be provided as a scalar string or character vector.
    %
    % An mlflow.RegisteredModel object is returned.
    % 
    % Example:
    % 
    %   rm = mlflow.RegisteredModel;
    %   result = rm.update('modelName', 'Updated model description');
    % 
    
    %  Copyright 2021-2022 MathWorks, Inc.
    
    arguments
        obj         (1,1) mlflow.RegisteredModel
        description (1,1) string
    end

    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'update');
    request = obj.getRequestMessage('PATCH');
    
    % Create the request
    payload.name = obj.name;
    if nargin > 1
        payload.description = description;
    end
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(payload);
    
    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));
    
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;
        data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"registered_model", "creation_timestamp"}, "int64", {"registered_model", "last_updated_timestamp"}, "int64");  %#ok<CLARRSTR>
        
        obj.initFromStructInternal(data.registered_model);

    else
        % Could not create experiment
        error('MLFLOW:ERROR', 'Failed to create registered model\n%s', char(resp));
    end

end %function
