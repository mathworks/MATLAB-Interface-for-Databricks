function cluster = findById(clId, options)
    % FINDBYID Method to find a cluster by id
    % Locate a databricks cluster by id
    %
    % Required argument
    %   clId    A scalar text cluster Id
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % For example:
    %
    % cl = databricks.Cluster.findById('0928-104326-ul6a0cn9')
    % cl =
    %   Cluster with properties:
    %
    %                    cluster_name: 'Mumindalen'
    %                    node_type_id: 'Standard_DS3_v2'
    %                   spark_version: '10.4.x-scala2.12'
    %                      spark_conf: [4×1 containers.Map]
    %                      start_time: 28-Sep-2022 10:43:26
    %            last_state_loss_time: 29-Sep-2022 15:11:14
    %                azure_attributes: [1×1 struct]
    %              last_activity_time: 29-Sep-2022 15:10:56
    %             last_restarted_time: 29-Sep-2022 15:11:14
    %             driver_node_type_id: 'Standard_DS3_v2'
    %             enable_elastic_disk: 1
    %         autotermination_minutes: 120
    %                     num_workers: 0
    %                       disk_spec: [1x1 struct]
    %                 terminated_time: 29-Sep-2022 17:11:00
    %                  cluster_source: 'UI'
    %              termination_reason: [1x1 struct]
    %                    default_tags: [1x1 struct]
    %    enable_local_disk_encryption: 0
    %          init_scripts_safe_mode: 0
    %                 instance_source: [1x1 struct]
    %                      cluster_id: '0928-104326-ul6a0cn9'
    %                  spark_env_vars: [1x1 containers.Map]
    %          driver_instance_source: [1x1 struct]
    %                     custom_tags: [1x1 struct]
    %               creator_user_name: 'joeuser@example.com'
    %                           state: 'TERMINATED'
    %         effective_spark_version: '10.4.x-scala2.12'
    %                   state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
    %                spark_context_id: 7382155561119740546

    %   (c) 2020-2024 MathWorks, Inc.

    arguments
        clId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    % List all clusters
    clusterList = databricks.Cluster.list(args{:});

    % Loop and find cluster
    cluster = databricks.Cluster.empty();

    for cCount = 1:numel(clusterList)
        if strcmpi(clusterList(cCount).cluster_id,clId)
            % Match
            cluster = clusterList(cCount);
            break;
        end
    end
end %function
