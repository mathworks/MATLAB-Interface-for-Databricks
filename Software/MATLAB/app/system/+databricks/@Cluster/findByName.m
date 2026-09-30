function cluster = findByName(clName, options)
    % FINDBYNAME Method to find a cluster by name
    % Locate a Databricks cluster by name.
    %
    % Required argument
    %   clName    A scalar text cluster name
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %
    %   cl = databricks.Cluster.findByName('Databricks Demo');

    % (c) 2020-2024 MathWorks, Inc.

    arguments
        clName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    % List all clusters
    clusterList = databricks.Cluster.list(args{:});
    if isempty(clusterList)
        cluster = databricks.Cluster.empty();
    else
        % Loop and find cluster
        clIdx = strcmpi({clusterList.cluster_name},clName);
        if any(clIdx)
            cluster = clusterList(clIdx);
        else
            cluster = databricks.Cluster.empty();
        end
    end
end %function
