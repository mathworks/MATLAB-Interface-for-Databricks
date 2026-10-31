function obj = list(options)
    % LIST Create a list of databricks clusters
    % This method can be used to create a list of all available Databricks clusters.
    %
    %   cl = databricks.Cluster.list();
    %
    % The returned cluster(s) will provide a handle to Databricks.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %
    %  clusters = databricks.Cluster.list
    %  clusters = 
    %    1×32 Cluster array with properties:
    %
    %      cluster_name
    %      node_type_id
    %      spark_version
    %      spark_conf
    %
    %  clusters(1)
    %  ans = 
    %    Cluster with properties:
    %
    %                      cluster_name: 'Mumindalen'
    %                      node_type_id: 'Standard_DS3_v2'
    %                     spark_version: '10.4.x-scala2.12'
    %                        spark_conf: [2×1 containers.Map]
    %                        start_time: 30-Sep-2022 08:46:12
    %              last_state_loss_time: 01-Jan-1970
    %                  azure_attributes: [1×1 struct]
    %                last_activity_time: 30-Sep-2022 09:39:59
    %               last_restarted_time: 30-Sep-2022 08:52:48
    %               driver_node_type_id: 'Standard_DS3_v2'
    %               enable_elastic_disk: 1
    %                  cluster_log_conf: [1×1 struct]
    %           autotermination_minutes: 120
    %                       num_workers: 2
    %                      init_scripts: [1×1 struct]
    %                         disk_spec: [1×1 struct]
    %                   terminated_time: 30-Sep-2022 11:40:28
    %                    cluster_source: 'UI'
    %                cluster_log_status: [1×1 struct]
    %                termination_reason: [1×1 struct]
    %                      default_tags: [1×1 struct]
    %      enable_local_disk_encryption: 0
    %            init_scripts_safe_mode: 0
    %                   instance_source: [1×1 struct]
    %                        cluster_id: '0930-084612-uurhdujo'
    %                    spark_env_vars: [2×1 containers.Map]
    %            driver_instance_source: [1×1 struct]
    %                 creator_user_name: 'joeuser@example.com'
    %                             state: 'TERMINATED'
    %           effective_spark_version: '10.4.x-scala2.12'
    %                     state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
    %                  spark_context_id: 7430983140709072285

    %  (c) 2019-2026 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    %% Get a list of all databricks clusters
    obj = databricks.Cluster(args{:});

    clusterURI = obj.getURI('clusters', 'list');
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, obj.HTTPOptions);


    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;

        processedData = mlflow.jsondecode(resp.Body.Data, allowMissing, ...
            {"clusters", {':'}, 'num_workers'}, 'int32',...
            {"clusters", {':'}, 'spark_context_id'}, 'int64',...
            {"clusters", {':'}, 'jdbc_port'}, 'int32',...
            {"clusters", {':'}, 'autotermination_minutes'}, 'int32', ...
            {"clusters", {':'}, 'start_time'}, 'int64',...
            {"clusters", {':'}, 'terminated_time'}, 'int64',...
            {"clusters", {':'}, 'last_state_loss_time'}, 'int64',...
            {"clusters", {':'}, 'last_activity_time'}, 'int64',...
            {"clusters", {':'}, 'last_restarted_time'}, 'int64',...
            {"clusters", {':'}, 'cluster_memory_mb'}, 'int64'...
            );

        if ~isempty(fieldnames(processedData))
            % We have a non-empty response

            % Create an object for each cluster
            for cCount = 1:numel(processedData.clusters)

                if iscell(processedData.clusters)
                    curCluster = processedData.clusters{cCount};
                else
                    curCluster = processedData.clusters(cCount); % only one structure
                end

                if isfield(curCluster, 'spark_version')
                    extraArgs = matlab.utils.addArgs(curCluster, ["spark_version"]);
                end
                % Create an output cluster
                obj(cCount) = databricks.Cluster(args{:}, extraArgs{:});

                % Valid response so package and send back to user
                if isfield(curCluster, 'spark_conf')
                    fieldNames = fieldnames(curCluster.spark_conf);
                    if numel(fieldNames) > 0
                        scpCell = {};
                        % Build and nx2 cell array of pairs
                        for f = 1:numel(fieldNames)
                            scpCell{f, 1} = fieldNames{f}; %#ok<AGROW>
                            scpCell{f, 2} = curCluster.spark_conf.(fieldNames{f}); %#ok<AGROW>
                        end
                        scps = databricks.SparkConfPair(scpCell);
                        obj(cCount).setSparkConf(scps);
                        % Remove spark_conf from the struct as it has now been set in the cluster object directly
                        curCluster = rmfield(curCluster, 'spark_conf');
                    else
                        error('DATABRICKS:ERROR', 'Unexpected empty spark_conf field');
                    end
                end

                if isfield(curCluster, 'spark_env_vars')
                    fieldNames = fieldnames(curCluster.spark_env_vars);
                    if numel(fieldNames) > 0
                        for f = 1:numel(fieldNames)
                            var = databricks.SparkEnvPair(fieldNames{f}, curCluster.spark_env_vars.(fieldNames{f}));
                            % Incrementally add the env var entries to the object
                            obj(cCount).setSparkEnvVars(var);
                        end
                    end
                    % Remove spark_env_vars from the struct as it has now been set in the cluster object directly
                    curCluster = rmfield(curCluster, 'spark_env_vars');
                end

                % Add struct fields other than spark_env_vars and spark_conf
                obj(cCount).addStructureAsDynProps(curCluster);

            end
        else
            % We have an empty response
            obj = [];
        end

    else
        % Could not list clusters
        error('DATABRICKS:ERROR', 'Failed to list clusters');
    end

end %function
