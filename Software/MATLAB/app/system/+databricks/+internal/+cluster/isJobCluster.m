function tf = isJobCluster(cluster_id, options)
    % isJobCluster 
    % 
    % Returns true if the cluster_id provided is a job cluster, otherwise
    % false.
    % 
    % Throws an error otherwise.
    %
    % Example:
    %   tf = databricks.internal.cluster.isJobCluster("0306-062556-bqreojvr")

    % Copyright 2026 The MathWorks, Inc.
    arguments
        cluster_id (1,1) string {mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.authMethod (1,1) matlab.databricks.AuthMethod
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    cl = databricks.Cluster.findById(cluster_id, args{:});

    if isempty(cl)
        error('DATABRICKS:CLUSTER_ID_DOES_NOT_EXIST', ...
            "Cluster with ID '%s' not found.", cluster_id);
    end

    tf = cl.cluster_source == "JOB";

end