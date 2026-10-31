function tf = isNotebooksSupported(cluster, options)
    % ISNOTEBOOKSSUPPORTED Returns true if the cluster supports notebooks otherwise false
    % If the cluster does not have a workload_type property that specifies notebooks
    % support, true is assumed as the default.

    %  Copyright 2023 MathWorks, Inc.

    arguments
        cluster (1,1) databricks.Cluster
        options.silent (1,1) logical = false
    end

    if isempty(cluster)
        error("DATABRICKS:isJobsSupported", "cluster is not configured")
    end

    if ~isprop(cluster, 'cluster_id')
        if ~options.silent
            fprintf("Cluster property cluster_id not found, assuming notebooks are not supported\n");
        end
        tf = false; % No point going further
        return;
    end

    if ~options.silent
        fprintf("Checking if the cluster: %s supports notebooks\n", cluster.cluster_id);
    end

    if ~isprop(cluster, 'workload_type')
        % Nothing to check against assume true
        tf = true;
        if ~options.silent
            fprintf("Cluster property workload_type not found, assuming notebooks are supported\n");
        end
    else
        if ~isfield(cluster.workload_type, 'clients')
            % No client field found, nothing to check assume true
            tf = true;
            if ~options.silent
                fprintf("Cluster property workload_type/clients not found, assuming notebooks are supported\n");
            end
        else
            if isfield(cluster.workload_type.clients, 'notebooks') && islogical(cluster.workload_type.clients.notebooks)
                tf = cluster.workload_type.clients.notebooks;
                if ~options.silent
                    if tf
                        fprintf("Notebooks are supported\n");
                    else
                        fprintf("Notebooks are not supported\n");
                    end
                end
            else
                tf = true;
                if ~options.silent
                    fprintf("Cluster property workload_type/clients of unexpected type, assuming notebooks are supported\n");
                end
            end
        end
    end
end