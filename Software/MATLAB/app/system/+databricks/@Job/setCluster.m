function setCluster(obj, varargin)
    % SETCLUSTER Method to configure the cluster details for a job
    % If an existing cluster is to be used then that cluster's cluster_id
    % property should be provided. If a new cluster should be created then to
    % execute the job the a Cluster object should be provided. Note the Cluster
    % object's cluster_id and name should not be set.
    %
    % When running jobs on an existing cluster, you may need to manually
    % restart the cluster if it stops responding. Running jobs
    % on new clusters provides greater reliability.
    %
    % For example, to use an existing cluster:
    %
    %   jb = databricks.Job;
    %   jb.name = 'Example';
    %   % Use the cluster_id of an existing Cluster object e.g. cl.cluster_id
    %   jb.setCluster('0716-182237-eta530');
    %
    % If a new a cluster is desired, provide a Cluster object:
    %
    %   cl = databricks.Cluster
    %   cl.setNumWorkers([2 10]);
    %
    %   jb = databricks.Job;
    %   jb.name = 'Example';
    %   jb.setCluster(cl);

    %   (c) 2019-2021 MathWorks, Inc.

    %% Parse the inputs
    p = inputParser;
    p.KeepUnmatched = false;

    validInput = @(x) ischar(x) || isstring(x) || isa(x,'databricks.Cluster');

    % Parse & Retrieve default & input values
    p.addRequired('ClusterDetails',validInput);
    p.parse(varargin{:});

    clusterDetails = p.Results.ClusterDetails;

    %% Set the cluster properties
    if isa(clusterDetails,'databricks.Cluster')
        rmpropif(obj, 'existing_cluster_id')

        % A cluster object has been passed in
        setprop(obj,'new_cluster', clusterDetails);

    else
        % clusterDetails should be a cluster ID string
        rmpropif(obj,'new_cluster')

        % An existing cluster id has been specified
        setprop(obj,'existing_cluster_id', clusterDetails);

        % % Check if the cluster supports Jobs
        % cl = databricks.Cluster.findById(clusterDetails);
        % if ~isempty(cl)
        %     if databricks.internal.cluster.isJobsSupported(cl)
        %         warning("DATABRICKS:setCluster","Cluster: %s does not support jobs workloads", clusterDetails.cluster_id);
        %     end
        % end
    end
end %function
