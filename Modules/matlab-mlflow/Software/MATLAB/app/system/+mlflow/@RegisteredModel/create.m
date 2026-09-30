function obj = create(obj, varargin)
    % CREATE Method to create a registered model
    % 
    % An mlflow.RegisteredModel object is returned.
    % 
    % Example:
    % 
    %   rm = mlflow.RegisteredModel;
    %   result = rm.create();
    
    %  (c) 2021-2022 MathWorks, Inc.
    
    %% Create a new registered model
    clusterURI = obj.getURI('registered-models', 'create');
    request = obj.getRequestMessage('POST');
    
    % Create the request
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload;
    
    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions);
    
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        propNames = fieldnames(resp.Body.Data);
        if ~isempty(propNames)
            % A non-empty response
            obj.initFromStructInternal(resp.Body.Data.registered_model);
        end
    else
        % Could not create model
        error('MLFLOW:ERROR', 'Failed to create registered model\n%s', char(resp));
    end
    
end %function
