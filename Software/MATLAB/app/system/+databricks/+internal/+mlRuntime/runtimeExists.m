function tf = runtimeExists(runtimeURL, remoteDestination, options)
    % runtimeExists Returns true if runtime for a given URL exists on DBFS

    %  (c) 2023-2024 MathWorks, Inc.

    arguments
        runtimeURL string {mustBeTextScalar, mustBeNonempty}
        remoteDestination string {mustBeTextScalar, mustBeNonempty} = "/MathWorks/runtime"
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    fileURI = matlab.net.URI(runtimeURL);
    zipFile = fileURI.Path(end);
    if ~endsWith(remoteDestination, "/")
        remoteDestination = strcat(remoteDestination, "/");
    end
    zipPath = strcat(remoteDestination, zipFile);

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    db = databricks.DBFS(args{:});
    stat = db.getStatus(zipPath);
    if isempty(stat)
        tf = false;
    else
        if isa(stat, "databricks.datastructures.FileInfo")
            if isprop(stat, 'is_dir')
                if stat.is_dir
                    error("DATABRICKS:runtimeExists", "Path is a directory not a file: %s", zipPath);
                else
                    tf = true;
                end
            else
                error("DATABRICKS:runtimeExists", "is_dir property not found");
            end
        else
            error("DATABRICKS:runtimeExists", "Expected a response of type: databricks.datastructures.FileInfo");
        end
    end
end