function [regModels, nextPageToken] = search(filter, maxResults, orderBy, pageToken)
    % SEARCH List registered models
    %
    % This is a static method on the mlfow.RegisteredModel class, and will
    % search models registered on the mlflow endpoint. Without arguments,
    % it behaves much like the list method.
    %
    % Examples: 
    %  % Search up to 100 models
    %  regmdls = mlflow.RegisteredModel.search()
    %
    %  % Search models whose name is like Test
    %  regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'")
    %  
    %  % Search models whose name is like Test, limit to 5 results
    %  regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'", 5)
    %  
    %  % Search models whose name is like Test, order by user_id
    %  regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [])
    %  
    %  
    %  % Search up to 5 models and save the pagination token
    %  [regmdls, paginationToken] = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [])
    %  % Now search the next 10 models
    %  [regmdls, paginationToken] = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [], paginationToken)
    %

    %  Copyright 2021-2022 MathWorks, Inc.

    arguments
        filter (1,1) string = ""
        maxResults (1,1) int64 = 100
        orderBy  string = string.empty
        pageToken string = string.empty
    end

    obj = mlflow.RegisteredModel;

    % Create a new registered model
    clusterURI = obj.getURI('registered-models', 'search');
    request = obj.getRequestMessage('GET');

    QP = matlab.net.QueryParameter('filter', filter);
    QP(end+1) = matlab.net.QueryParameter('max_results', maxResults);

    if ~isempty(orderBy)
        QP(end+1) = matlab.net.QueryParameter('order_by', orderBy, matlab.net.ArrayFormat.repeating);
    end
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