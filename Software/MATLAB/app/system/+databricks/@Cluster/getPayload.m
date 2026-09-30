function payload = getPayload(obj, varargin)
    % GETPAYLOAD Internal method to create the request payload by removing properties

    % (c) 2019-2024 MathWorks, Inc.

    %% Create a candidate payload
    objProps = properties(obj);

    for pCount = 1:numel(objProps)
        candidate.(objProps{pCount}) = obj.(objProps{pCount});
    end

    %% Remove redundant properties
    if isfield(candidate,'Version')
        candidate = rmfield(candidate,'Version');
    end

    %% Remove mutually exclusive fields
    if isfield(candidate,'instance_pool_id') && isfield(candidate,'node_type_id')
        candidate = rmfield(candidate,'node_type_id');
    end

    %% Handle runtime engine
    % From: https://docs.databricks.com/api/workspace/clusters/create
    %
    % This field is not compatible with legacy spark_version values that
    % contain -photon-. Remove -photon- from the spark_version and set
    % runtime_engine to PHOTON.
    %
    % If left unspecified, the runtime engine defaults to standard unless the
    % spark_version contains -photon-, in which case Photon will be used.
    
    % If not set do nothing
    if isfield(candidate,'runtime_engine')
        if isfield(candidate, 'spark_version')
            if contains(candidate.spark_version, "-photon-")
                fprintf("A spark_version containing -photon- cannot be used with the runtime_engine property.\n");
                fprintf("Updating spark_version to remove -photon- & setting runtime_engine to PHOTON instead.\n");
                candidate.spark_version = replace(char(candidate.spark_version),'-photon-','-');
                candidate.runtime_engine = char(databricks.datastructures.RuntimeEngine.PHOTON);
            else
                % spark_version does not contain photon so do nothing.
            end
        else
            % This will likely cause a server side error
            fprintf(2, "spark_version field not found.\n");
        end
    end

    % Make the data model match
    fieldsToAllow = {...
        'num_workers',...
        'autoscale',...
        'cluster_name',...
        'spark_version',...'
        'spark_conf',...
        'aws_attributes',...
        'node_type_id',...
        'driver_node_type_id',...
        'ssh_public_keys',...
        'custom_tags',...
        'cluster_log_conf',...
        'init_scripts',...
        'docker_image',...
        'spark_env_vars',...
        'autotermination_minutes',...
        'enable_elastic_disk',...
        'driver_instance_pool_id',...
        'instance_pool_id',...
        'idempotency_token',...
        'apply_policy_default_values',...
        'policy_id',...
        'single_user_name',...
        'data_security_mode',...
        'run_as',...
        'runtime_engine',...
        'instance_pool_id'...
        };

    % All only the properties that match
    cProps = intersect(fieldsToAllow, fieldnames(candidate));
    for cCount = 1:numel(cProps)
        clCandidate.(cProps{cCount}) = candidate.(cProps{cCount});
    end

    % Translate to JSON
    payload = jsonencode(clCandidate);
    % data is in JSON format from here on

end %function
