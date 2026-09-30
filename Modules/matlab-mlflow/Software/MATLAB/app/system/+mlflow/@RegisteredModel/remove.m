function remove(obj)
    % REMOVE Method to delete a registered model
    % Delete a registered model from the MLFlow tracking server.
    %
    %   rm = mlflow.RegisteredModel
    %   rm.remove('modelName');  % Deletes a registered model

    %  Copyright 2020-2022 MathWorks, Inc.

    % Remove the model
    endpointURI = obj.getURI('registered-models', 'delete');
    request = obj.getRequestMessage('delete');

    % Configure the request
    %     query = matlab.net.QueryParameter('name', obj.name);
    %     endpointURI.Query(end+1) = query;
    payload = struct('name', obj.name);
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(payload);

    % Call mlflow to remove the experiment
    % Note: MATLAB assumes that a DELETE method should not expect a Body,
    % but this is exactly what this endpoint expects, so we turn off this
    % warning before the call.
    warnState = warning('off', 'MATLAB:http:BodyUnexpectedFor');
    resp = request.send(endpointURI, getHTTPOptions);
    warning(warnState)

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        disp(['Successfully deleted registered model with name: ', obj.name]);
    else
        if isstruct(resp.Body.Data)
            if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
                error('MLFLOW:ERROR', 'Failed to delete experiment: %s\nError code: %s\nMessage: %s',...
                  char(obj.name), char(resp.Body.Data.error_code), char(resp.Body.Data.message));
            else
                error('MLFLOW:ERROR', 'Unexpected error response structure');
            end
        else
            % Try char cast
            error('MLFLOW:ERROR','Failed to delete experiment: %s\n%s', obj.name, char(resp.Body.Data));
        end
    end

end %function
