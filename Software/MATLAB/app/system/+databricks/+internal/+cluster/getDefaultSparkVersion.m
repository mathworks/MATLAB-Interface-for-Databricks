function sparkVersion = getDefaultSparkVersion(options)
    % GETDEFAULTSPARKVERSION Spark Version based on settings default Databricks runtime
    %
    % Optional named arguments:
    %
    % checkAvailableVersions : Use the Cluster API to determine the available options
    %                          and choose a filtered response.
    %                          Default is a logical true.
    %
    %      databricksRuntime : Provide a Databricks runtime base version e.g. 17.3
    %                          to override the version in the databricks-settings.json
    %                          file.
    %
    %          ML : Selects a Databricks Runtime version with ML functionality
    %               enabled. Default is a logical false.
    %
    %         GPU : Selects a Databricks Runtime version with GPU functionality
    %               enabled. Default is a logical false.
    %
    %      photon : Selects a Databricks Runtime version with Photon functionality
    %               enabled. Default is a logical false.
    %
    %  authMethod : A matlab.databricks.AuthMethod.
    %
    % profileName : A configuration file profileName value.
    %
    % Example:
    %    v = databricks.internal.cluster.getDefaultSparkVersion()
    %    v = "17.3.x-scala2.13"

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.checkAvailableVersions (1,1) logical = true
        options.ML (1,1) logical = false
        options.GPU (1,1) logical = false
        options.photon (1,1) logical = false
        options.databricksRuntime string {mustBeTextScalar, mustBeNonzeroLengthText} % base version e.g. 17.3
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    
    if isfield(options, "databricksRuntime")
        databricksRuntime = options.databricksRuntime;
    else
        args = matlab.utils.addArgs(options, "settingsFile");
        settingsValue = databricks.internal.settings.Settings.getSettingsField("defaultDatabricksRuntime", args{:});
        pkgDefaultRuntime = matlab.databricks.internal.pkgsettings.getPkgSettings(field="defaultDatabricksRuntime");
        if isa(settingsValue, "string") || ischar(settingsValue)
            settingsValue = string(settingsValue);
            if isscalar(settingsValue) && strlength(settingsValue) > 0
                databricksRuntime = settingsValue;
            else
                databricksRuntime = pkgDefaultRuntime;
                if isempty(settingsValue)
                    fprintf(2, "Settings file defaultDatabricksRuntime not set, using: %s\n", databricksRuntime);
                else
                    fprintf(2, "Settings file defaultDatabricksRuntime value invalid, using: %s\n", databricksRuntime);
                end
            end
        else
            databricksRuntime = pkgDefaultRuntime;
            fprintf(2, "Settings file defaultDatabricksRuntime class invalid or not set, using: %s\n", databricksRuntime);
        end
    end
    
    runtimeSemVer = matlab.utils.SemVer(databricksRuntime);
    if runtimeSemVer >= 17
        defaultScalaAppend = ".x-scala2.13";
    else
        defaultScalaAppend = ".x-scala2.12";
    end

    if options.checkAvailableVersions
        % Only support Intel for now
        aarch64 = false;

        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        verOptions = databricks.internal.getFilteredSparkVersions(args{:},...
            'baseVersions', databricksRuntime,...
            'gpu', options.GPU,...
            'ml', options.ML,...
            'photon', options.photon,...
            'aarch64', aarch64);

        if height(verOptions) == 0
            sparkVersion = databricksRuntime + defaultScalaAppend;
            fprintf(2, "Could not determine a Spark Version value based on provided options, using: %s\n", sparkVersion);
        elseif height(verOptions) == 1
            sparkVersion = string(verOptions.key(1));
        else
            sparkVersion = string(verOptions.key(1));
            fprintf("More than one potential Spark Version value found based on provided options, using: %s\n", sparkVersion);
        end
    else
        sparkVersion = databricksRuntime + defaultScalaAppend;
    end
end