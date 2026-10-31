function installWheelOnDatabricksCluster(obj, uploadFolder, options)
    % INSTALLWHEELONDATABRICKSCLUSTER Upload wheel to Databricks
    %
    % This method is only relevant when using the matlab-spark-api package
    % in a Databricks context.
    %
    % This method can upload the wheel file either to a Volume, Workspace or DBFS.
    % Libraries store on DBFS are not supported on Shared clusters,
    % see: https://docs.databricks.com/en/libraries/index.html
    %
    % Upload to a volume:
    %   PSB.installWheelOnDatabricksCluster("/Volumes/mycatalog/myschema/myvolume/some/directory")
    % 
    % Upload to DBFS:
    %   PSB.installWheelOnDatabricksCluster("dbfs:/some/directory")
    %
    % Upload to a Workspace:
    %   PSB.installWheelOnDatabricksCluster("/Users/user@example.com/some/directory")
    % 
    % Optional arguments are available for choosing cluster and/or auth
    % methods. The optional arguments are:
    %
    %   clusterId   A cluster id
    %   authMethod  The authorization method to use
    %   profileName The profile to use

    % Copyright 2022-2024 The MathWorks, Inc.

    arguments
        obj (1,1)
        uploadFolder string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterId (1,1) string = ""
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if ~isDatabricksEnvironment
        error("Databricks:upload_to_databricks_environment", ...
            "This upload method can only be used in a Databricks environment")
    end

    if isempty(options.clusterId) || strlength(options.clusterId) == 0
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
    else
        clusterId = options.clusterId;
    end
    
    if isfield(options, 'authMethod')
        options.authMethod = matlab.databricks.AuthMethod.(options.authMethod);
    end
    
    [wheelFile, wheelName] = obj.getWheelFile();
    % Upload the file
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});

    destinationName = uploadFolder + "/" + string(wheelName);

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if ~databricks.internal.cluster.isLibrarySupported(destinationName, "libraryType", "whl", "clusterOrId", clusterId, args{:})
        error("DATABRICKS:wheel_not_uploaded", ...
            "The wheel file: %s could not be used as a cluster scoped library on the cluster: %s", destinationName, clusterId);
    end

    fprintf("Uploading: %s to: %s ...\n", wheelName, uploadFolder);
    io.upload(wheelFile, destinationName);

    if ~io.isfile(destinationName)
        error("DATABRICKS:wheel_not_uploaded", ...
            "The wheel file could not be uploaded to: %s", destinationName);
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if databricks.internal.cluster.isLibraryPolicySet("cluster", clusterId, args{:})
        fprintf(2, "The cluster defines a library using a policy, thus further libraries cannot\n");
        fprintf(2, "be installed using the Libraries API. To install the library use the %%pip command in a notebook:\n");
        fprintf(2, "    %%pip %s\n", destinationName);
        fprintf(2, "See Notebook scoped libraries in: %s\n", matlab.databricks.internal.docLink("LibraryAPI"));
        error("Databricks:upload_to_databricks_environment",...
            "Cannot install library due to cluster policy.");
    end

    fprintf("Installing wheel on cluster: %s\n", clusterId);
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    PW = databricks.Library(args{:});
    PW.setType('whl');
    PW.whl = destinationName;
    PW.install(clusterId)
end
