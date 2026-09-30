function [regModels, nextPageToken] = list(maxResults, pageToken)
    % LIST List registered models
    %
    % This is a static method on the mlfow.RegisteredModel class, and will
    % list models registered on the mlflow endpoint.
    %
    % Examples: 
    %  % List up to 20 models
    %  regmdls = mlflow.RegisteredModel.list()
    %
    %  % List up to N models (we set N to 5)
    %  regmdls = mlflow.RegisteredModel.list(5)
    %  
    %  % List up to 5 models and save the pagination token
    %  [regmdls, paginationToken] = mlflow.RegisteredModel.list(5)
    %  % Now list the next 10 models
    %  [regmdls, paginationToken] = mlflow.RegisteredModel.list(10, paginationToken)
    %

    %  (c) 2021-2022 MathWorks, Inc.

    arguments
        maxResults (1,1) int64 = 20
        pageToken string = string.empty
    end

    obj = mlflow.RegisteredModel;

    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'list');
    request = obj.getRequestMessage('GET');

    QP = matlab.net.QueryParameter('max_results', maxResults);

    if ~isempty(pageToken)
        QP(end+1) = matlab.net.QueryParameter('page_token', pageToken);
    end

    clusterURI.Query = QP;

    % Call mlflow to create the registered model version
    resp = request.send(clusterURI, getHTTPOptions);

    regModels = mlflow.RegisteredModel.empty;
    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if isfield(resp.Body.Data, 'registered_models')
            % A non-empty response
            data = resp.Body.Data;
            for k=1:length(data.registered_models)
                entry = data.registered_models(k);
                if iscell(entry)
                    entry = entry{1};
                end
                rm = mlflow.RegisteredModel();
                rm.initFromStructInternal(entry);
                regModels(end+1) = rm; %#ok<AGROW> 
            end
            if nargout > 1
                if isfield(data, 'next_page_token' )
                    nextPageToken = data.next_page_token;
                else
                    nextPageToken = string.empty;
                end
            end
        end
    else
        % Could not create model
        error('MLFLOW:ERROR', 'Failed to list registered models\n%s', char(resp));
    end


end