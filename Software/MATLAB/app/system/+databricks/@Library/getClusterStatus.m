function clusterStatus = getClusterStatus(obj, clusterId)
    % GETCLUSTERSTATUS Method to get status of libraries
    % Get the status of libraries on a cluster. A status will be available for
    % all libraries installed on the cluster via the API or the libraries UI as
    % well as libraries set to be installed on all clusters via the libraries
    % UI. If a library has been set to be installed on all clusters,
    % is_library_for_all_clusters will be true, even if the library was also
    % installed on the cluster.
    %
    %   lib = databricks.Library;
    %   lib.getClusterStatus(myCluster.cluster_id);
    %     ans =
    %   Library with properties:
    %    status: 'INSTALLED'
    %       jar: 'dbfs:/tmp/javabuilder.jar'
    %
    % Please see:
    % https://docs.databricks.com/dev-tools/api/latest/libraries.html


    %  (c) 2020-2023 MathWorks, Inc.

    %% Get the name of the cluster

    %% Get information about existing spark versions
    libraryURI = obj.getURI('libraries', 'cluster-status', 'cluster_id', clusterId);
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(libraryURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        clusterStatus = databricks.Library.empty();

        % Valid response so package and send back to user
        if isfield(resp.Body.Data,'library_statuses')
            statusList = resp.Body.Data.library_statuses;
            for lCount = 1:numel(statusList)
                statusItem = databricks.Library;

                % Add status
                if ~isprop(statusItem,'status')
                    statusItem.addprop('status');
                end

                % Create the status
                if iscell(statusList)
                    libType = fieldnames(statusList{lCount}.library);
                    statusItem.setType(libType{1});
                    statusItem.(libType{1})=statusList{lCount}.library.(libType{1});
                    statusItem.status = statusList{lCount}.status;

                else
                    libType = fieldnames(statusList(lCount).library);
                    statusItem.setType(libType{1});
                    statusItem.(libType{1})=statusList(lCount).library.(libType{1});
                    statusItem.status = statusList(lCount).status;
                end

                % Append
                clusterStatus(lCount) = statusItem;
            end
        else
            % Nothing was found default initialization of empty applies
        end

    else
        matlab.databricks.internal.responseError(resp, 'Invalid status response');
    end

end %function
