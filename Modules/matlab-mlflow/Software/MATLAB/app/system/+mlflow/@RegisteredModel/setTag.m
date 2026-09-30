function setTag(obj, varargin)
    % SETTAG Method to set a tag on a registered model
    % 
    % The arguments can be either a key/value pair or an object of type
    % mlflow.RegisteredModelTag
    %
    % An mlflow.RegisteredModel object is returned.
    % 
    % Examples:
    % 
    %   rm = mlflow.RegisteredModel.get("SomeModel");
    %   result = rm.update('mykey', 'myvalue');
    % 
    %   rmt = mlflow.RegisteredModelTag('otherkey', 'othervalue');
    %   rm = rm.update(rmt)

    %  Copyright 2021-2022 MathWorks, Inc.
    
    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'set-tag');
    request = obj.getRequestMessage('POST');
    
    % Create the request
    payload.name = obj.name;
    if nargin == 2 && isa(varargin{1}, "mlflow.RegisteredModelTag")
        rmt = varargin{1};
        payload.key = rmt.key;
        payload.value = rmt.value;
    elseif nargin == 3
        payload.key = string(varargin{1});
        payload.value = string(varargin{2});
    else
        error('mlflow:registeredmodel_settag_arguments', 'Bad arguments')
    end
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(payload);
    
    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));
    
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % All went well
    else
        % Could not create experiment
        error('MLFLOW:ERROR', 'Failed to create registered model: %s', char(resp));
    end

end %function
