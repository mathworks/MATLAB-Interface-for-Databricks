function obj = rename(obj, newName)
    % RENAME Method to rename a registered model
    % 
    % newName must be provided as a scalar string or character vector. It is the
    % newname of the registered model.
    %
    % An mlflow.RegisteredModel object is returned.
    % 
    % Example:
    % 
    %   rm = mlflow.RegisteredModel;
    %   result = rm.rename('oldName', 'newName');
    % 
    
    %  Copyright 2021-2022 MathWorks, Inc.
    
    arguments
        obj     (1,1) mlflow.RegisteredModel
        newName (1,1) string
    end

    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'rename');
    request = obj.getRequestMessage('POST');
    
    % Create the request
    payload.name = obj.name;
    payload.new_name = newName;

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(payload);
    
    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));
    
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing  = true;
        data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"registered_model", "creation_timestamp"}, "int64", {"registered_model", "last_updated_timestamp"}, "int64");  %#ok<CLARRSTR>
        
        obj.initFromStructInternal(data.registered_model);
    else
        % Could not create experiment
        error('MLFLOW:ERROR', 'Failed to create registered model\n%s', char(resp));
    end

end %function
