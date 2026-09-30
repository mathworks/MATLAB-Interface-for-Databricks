function payload = getPayload(obj, varargin)
% GETPAYLOAD Internal method to create the request payload by removing properties

% (c) 2019-2022 MathWorks, Inc.

%% Create a candidate payload
objProps = properties(obj);

for pCount = 1:numel(objProps)
    candidate.(objProps{pCount}) = obj.(objProps{pCount});
end

%% Remove redundant properties
if isfield(candidate,'Version')
    candidate = rmfield(candidate,'Version');
end

%% Make the NewCluster conform to the NewCluster object
% Please see: https://docs.databricks.com/dev-tools/api/latest/jobs.html#jobsclusterspecnewcluster
if isfield(candidate, 'new_cluster')
    clusterCandidate = candidate.new_cluster;
    
    % Make the data model match
    % Keep in sync with Job NewCluster data structure
    fieldsToAllow = {...
        'num_workers',...
        'autoscale',...
        'spark_version',...
        ... 'cluster_name',... % Not supported in 2.0
        'spark_conf',...
        'aws_attributes',...
        'node_type_id',...
        'driver_node_type_id',...
        'ssh_public_keys',...
        'custom_tags',...
        'cluster_log_conf',...
        'init_scripts',...
        'docker_image',... % Not supported in 2.0, maybe i 2.1 but Databricks docs are offline, included for now as a workaround
        'spark_env_vars',...
        ... 'autotermination_minutes',... % Not supported in 2.0
        'enable_elastic_disk',...
        'driver_instance_pool_id',...
        'instance_pool_id'...
        ... 'idempotency_token',... % Not supported in 2.0
        ... 'apply_policy_default_values',... % Not supported in 2.0
        ... 'policy_id'... % Not supported in 2.0
        };
    
    % All only the properties that match
    cProps = intersect(fieldsToAllow,fieldnames(clusterCandidate));
    for cCount = 1:numel(cProps)
        clCandidate.(cProps{cCount})=clusterCandidate.(cProps{cCount});
    end

    % Assign to new_cluster property as is
    candidate.new_cluster = clCandidate;
end

% Finally serialize
payload = jsonencode(candidate);

end %function
