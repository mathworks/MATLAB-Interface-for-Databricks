function url = getMetastoreURL(options)
    % GETMETASTOREURL Returns the URL to configure a Workspace Metastore
    % Can be used to configure allowlists.
    % Sample metastore portal url:
    %   https://adb-1234567890.1.azuredatabricks.net/explore/metastore?o=1234567890
    % A matlab.net.URI is returned.
    %
    % Example:
    %   metastoreURL = matlab.databricks.internal.getMetastoreURL()

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    hostStr = databricks.internal.configurationprofile.ConfigFile.getProfileField("host", profileName=options.profileName);
    
    org_id = databricks.internal.configurationprofile.ConfigFile.getProfileField("org_id", profileName=options.profileName);

    url = matlab.net.URI(hostStr);

    url.Path = {"explore", "metastore"};
    
    q = matlab.net.QueryParameter("o", org_id);
    url.Query(end+1) = q;
end

