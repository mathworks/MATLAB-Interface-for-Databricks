function volumeURL = generateVolumeURL(destination, destinationWritable, options)
    % GENERATEVOLUMEURL Returns the Databricks portal URL for the destination
    % If the destination is not writable then the higher-level path is provided e.g.:
    %   https://adb-123456789.azuredatabricks.net/explore/data?o=123456789
    % A matlab.net.URI object is returned.
    % Only /Volumes destination paths are supported.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        destination string {mustBeTextScalar, mustBeNonzeroLengthText},
        destinationWritable (1,1) logical
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true;
    end

    if ~startsWith(destination, "/Volumes/")
        error("DATABRICKS:GENERATEVOLUMEURL", "Only /Volumes paths are currently supported");
    end

    if ~destinationWritable
        hostStr = databricks.internal.configurationprofile.ConfigFile.getProfileField("host", profileName=options.profileName);
        volumeURL = matlab.net.URI(hostStr);
        volumeURL.Path = {"explore", "data"};
        org_id = databricks.internal.configurationprofile.ConfigFile.getProfileField("org_id", profileName=options.profileName);
        q = matlab.net.QueryParameter("o", org_id);
        volumeURL.Query(end+1) = q;
    else
        fields = split(destination, "/");
        if numel(fields) < 5
            error("DATABRICKS:GENERATEVOLUMEURL", "destination argument does not have the expected number of 5 or more fields");
        end
        catalog = lower(fields(3));
        schema = lower(fields(4));
        volume = lower(fields(5));
        
        hostStr = databricks.internal.configurationprofile.ConfigFile.getProfileField("host", profileName=options.profileName);
    
        org_id = databricks.internal.configurationprofile.ConfigFile.getProfileField("org_id", profileName=options.profileName);
    
        volumeURL = matlab.net.URI(hostStr);
        volumeURL.Path = {"explore", "data", "volumes", catalog, schema, volume};
    
        q = matlab.net.QueryParameter("o", org_id);
        volumeURL.Query(end+1) = q;
    
        if endsWith(destination, "/")
            pathSlash = destination;
        else
            pathSlash = destination + "/";
        end
        q = matlab.net.QueryParameter("volumePath", pathSlash);
        volumeURL.Query(end+1) = q;
    end
end