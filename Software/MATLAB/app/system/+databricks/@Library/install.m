function install(obj, clusterId, verbose, options)
    % INSTALL Method to install a library on a cluster
    % Install libraries on a cluster. The installation is asynchronous - it
    % completes in the background after the request.
    %
    %   lib = databricks.Library;
    %   lib.setType('jar');
    %   lib.jar = 'dbfs:/mylibraries/mylibrary.jar';
    %
    %   clusterId = '1211-151034-4ee14cnm'
    %   lib.install(clusterId);
    %
    %  If the current configuration for Databricks is pointing to the
    %  correct cluster, the installation can be done without an argument,
    %  i.e. 
    %   lib.install();
    %
    %  A verbose flag can be used to suppress output:
    %   verbose = false;
    %   lib.install(clusterId, verbose);

    %  (c) 2020-2024 MathWorks, Inc.

    arguments
        obj (1,1) databricks.Library
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        verbose (1,1) logical = true
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if nargin == 1
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName=options.profileName);
    end

    % Create a new spark cluster on databricks
    libraryURI = obj.getURI('libraries', 'install');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload(clusterId);

    % Requires metastore admin or to have the MANAGE ALLOWLIST privilege
    % % Verify cluster version/destination
    % args = matlab.utils.addArgs(options, ["profileName", "authMethod", "verbose"]);
    % destination = obj.(obj.getType);
    % if ~databricks.internal.cluster.isLibrarySupported(destination, "clusterOrId", clusterId, args{:})
    %     error("DATABRICKS:LIBRARYINSTALL", ...
    %         "The library cannot be installed using this combination of cluster type and file path.");
    % end

    % Call databricks
    resp = request.send(libraryURI, databricks.internal.getHTTPOptions(convertResponse=true));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if verbose
            % Valid response so package and send back to user
            disp('Library installation requested');
        end
    else
        matlab.databricks.internal.responseError(resp, 'Failed to install library');
    end

end %function
