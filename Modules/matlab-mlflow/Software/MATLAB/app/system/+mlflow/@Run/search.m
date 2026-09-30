function [runs, nextPageToken] = search(experimentIds, options)
    % SEARCH Method to search for runs that satisfy filter expressions
    % Search through MLFlow runs using Metric and Params keys
    %
    % Examples:
    % runs = mlflow.Run.search("1343416123331890")
    %
    % % Only search 5, and get a next_page_token
    % [runs, npt] = mlflow.Run.search(E.experiment_id, maxResults = 5)
    % % Search next 10
    % [runs2, npt] = mlflow.Run.search(E.experiment_id, maxResults = 10, pageToken=npt)
    %
    % Other optional arguments are filterExpr, runViewType, orderBy
    %
    % Cf. https://www.mlflow.org/docs/latest/rest-api.html#search-runs
    
    %  (c) 2020-2022 MathWorks, Inc.

    arguments
        experimentIds                 string
        options.filterExpr     (1,1)  string = "" 
        options.runViewType           mlflow.ViewType = mlflow.ViewType.ACTIVE_ONLY
        options.maxResults            int32
        options.orderBy               string
        options.pageToken             string
    end

    % Search API endpoint
    obj = mlflow.Run;
    clusterURI = obj.getURI('runs', 'search');

    % Create the request
    request = obj.getRequestMessage('POST');

    % Create the request
    request.Body = matlab.net.http.MessageBody;

    payload.experiment_ids = experimentIds;
    payload.filter = options.filterExpr;
    payload.run_view_type = options.runViewType;

    if isfield(options, 'maxResults')
        payload.max_results = options.maxResults;
    end

    if isfield(options, 'orderBy')
        payload.order_by = options.orderBy;
    end
    if isfield(options, 'pageToken')
        payload.page_token = options.pageToken;
    end
    % Encode
    request.Body.Payload = jsonencode(payload);


    % TODO add int64 handling in resp.Body.Data.Runs().RunInfo[start_time, end_time]

    % Call MLflow endpoint
    resp = request.send(clusterURI, getHTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        runs = mlflow.Run.empty;
        data = resp.Body.Data;
        if ~isempty(fieldnames(data))
            % We have a non-empty response

            % Create an object for each experiment
            for cCount = 1:numel(data.runs)

                expItem = data.runs(cCount);
                if iscell(expItem)
                    % Extract contents
                    expStruct = expItem{1};
                else
                    expStruct = expItem;
                end

                % Create an output run object
                runs(cCount) = mlflow.Run;
                runs(cCount).info = mlflow.RunInfo(expStruct.info);
                runs(cCount).data = mlflow.RunData(expStruct.data);
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
        % Could not list experiments
        error('MLFLOW:ERROR', 'Failed to search runs');
    end

end %function
