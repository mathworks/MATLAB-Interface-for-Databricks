function refresh(obj, varargin)
    % REFRESH Method to refresh information about a Spark cluster
    % Refresh information about a new cluster. This method is asynchronous;
    % the returned cluster_id can be used to poll the cluster state.
    %
    %   cl = databricks.Cluster();
    %   cl.cluster_name = 'Test Cluster';
    %   cl.setNumWorkers(3); % Number of workers
    %   cl.create();
    %   cl.refresh();
    %
    % The resulting structure contains information about the cluster.
    %
    %   cl =
    %
    %   Cluster with properties:
    %
    %                 cluster_name: 'Test Cluster'
    %                 node_type_id: 'Standard_DS3_v2'
    %                spark_version: '10.4.x-scala2.12'
    %                   spark_conf: [1x1 struct]
    %      effective_spark_version: '10.4.x-scala2.12'
    %                state_message: ''
    %               spark_env_vars: [1x1 struct]
    %                   start_time: 30-May-2022 14:21:07
    %                       driver: [1x1 struct]
    %         last_state_loss_time: 01-Jan-1970
    %                  custom_tags: [1x1 struct]
    %          last_restarted_time: 30-May-2022 14:24:16
    %               runtime_engine: 'STANDARD'
    %             spark_context_id: 6867261915688657682
    %                    jdbc_port: 10000
    %                  num_workers: 3
    %          driver_node_type_id: 'Standard_DS3_v2'
    %            cluster_memory_mb: 14336
    %                   cluster_id: '0530-142107-k9i1yrat'
    %          enable_elastic_disk: 1
    %                cluster_cores: 4
    %                    disk_spec: [1x1 struct]
    %                        state: 'RUNNING'
    %               cluster_source: 'UI'
    %                 default_tags: [1x1 struct]
    %            creator_user_name: 'user@example.com'
    % enable_local_disk_encryption: 0
    %             azure_attributes: [1x1 struct]
    %       init_scripts_safe_mode: 0
    %              instance_source: [1x1 struct]
    %      autotermination_minutes: 120
    %       driver_instance_source: [1x1 struct]


    %  (c) 2019-2026 MathWorks, Inc.

    %% Initializations

    if isprop(obj, 'cluster_id')
        if strlength(obj.cluster_id) == 0
            error('DATABRICKS:CLUSTER', 'cluster_id value is not set');
        end
    else
        error('DATABRICKS:CLUSTER', 'cluster_id property is not set');
    end

    clusterURI = obj.getURI('clusters', 'get', 'cluster_id', obj.cluster_id);
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.GET;

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;

        processedData = mlflow.jsondecode(resp.Body.Data, allowMissing, ...
            {'start_time'}, 'int64',...
            {'terminated_time'}, 'int64',...
            {'last_state_loss_time'}, 'int64',...
            {'last_activity_time'}, 'int64',...
            {'cluster_memory_mb'}, 'int64',...
            {'spark_context_id'}, 'int64',...
            {'last_restarted_time'}, 'int64'...
            );

        % Valid response so package and send back to user
        propList = fieldnames(processedData);

        for pCount = 1:numel(propList)
            currProp = propList{pCount};

            % create the properties on the object
            if ~isprop(obj, currProp)
                addprop(obj, currProp);
            end

            % populate the information about the object
            switch currProp
                case {'start_time', 'terminated_time', 'last_state_loss_time', 'last_activity_time', 'last_restarted_time'}
                    obj.(currProp) = datetime(processedData.(currProp), 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);

                otherwise
                    obj.(currProp) = processedData.(currProp);
            end
        end

        % Resave the cluster_id for sanity
        obj.cluster_id = processedData.cluster_id;
    else
        matlab.databricks.internal.responseError(resp, 'Failed to refresh cluster info');
    end

end %function
