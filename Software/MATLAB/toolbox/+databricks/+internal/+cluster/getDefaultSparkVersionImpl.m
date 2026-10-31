function sparkVersion = getDefaultSparkVersionImpl(options)
    % GETDEFAULTSPARKVERSIONIMPL Spark Version based on settings default Databricks runtime
    %
    % Optional named arguments:
    %
    % checkAvailableVersions : Use the Cluster API to determine the available options
    %                          and choose a filtered response.
    %                          Default is a logical true.
    %
    %      databricksRuntime : Provide a Databricks runtime base version e.g. 15.4
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
    %  authMethod : A matlab.internal.databricks.AuthMethod.
    %
    % profileName : A configuration file profileName value.
    %
    % Example:
    %    v = databricks.internal.cluster.getDefaultSparkVersionImpl()
    %    v = "15.4.x-scala2.12"

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        options.checkAvailableVersions (1,1) logical = true
        options.ML (1,1) logical = false
        options.GPU (1,1) logical = false
        options.photon (1,1) logical = false
        options.databricksRuntime string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.internal.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if isfield(options, "databricksRuntime")
        databricksRuntime = options.databricksRuntime;
    else
        args = matlab.internal.utils.addArgs(options, "settingsFile");
        settingsValue = databricks.internal.settings.Settings.getSettingsField("defaultDatabricksRuntime", args{:});
        pkgDefaultRuntime = matlab.internal.databricks.pkgsettings.getPkgSettingsImpl(field="defaultDatabricksRuntime");
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

    if options.checkAvailableVersions
        aarch64 = false;

        args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
        verOptions = databricks.internal.getFilteredSparkVersionsImpl(args{:},...
            'baseVersions', databricksRuntime,...
            'gpu', options.GPU,...
            'ml', options.ML,...
            'photon', options.photon,...
            'aarch64', aarch64);

        if height(verOptions) == 0
            sparkVersion = databricksRuntime + ".x-cpu-scala2.12";
            fprintf(2, "Could not determine a Spark Version value based on provided options, using: %s\n", sparkVersion);
        elseif height(verOptions) == 1
            sparkVersion = string(verOptions.key(1));
        else
            sparkVersion = string(verOptions.key(1));
            fprintf("More than one potential Spark Version value found based on provided options, using: %s\n", sparkVersion);
        end
    else
        sparkVersion = databricksRuntime + ".x-scala2.12";
    end
end
