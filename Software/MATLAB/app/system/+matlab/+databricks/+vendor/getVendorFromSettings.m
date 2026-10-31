function vendor = getVendorFromSettings(options)
    % GETVENDORFROMSETTINGS Returns the vendor value stored in the settings file
    %
    % Returns a matlab.databricks.vendor.Vendor enumeration.
    % If no default value is defined an empty enumeration value is returned.
    % The DATABRICKS_VENDOR environment variable is respected.
    %
    % An optional named argument settingsFile may be provided for non default
    % file locations.
    %
    % Example
    %   v = matlab.databricks.vendor.getVendorFromSettings();

    %  (c) 2024 MathWorks, Inc.

    arguments
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, "settingsFile");
    settingsValue = databricks.internal.settings.Settings.getSettingsField("vendor", args{:});
    
    if isa(settingsValue, "string") || ischar(settingsValue)
        settingsValue = string(settingsValue);
        if isempty(settingsValue)
            vendor = matlab.databricks.vendor.Vendor.empty;
        else
            if isscalar(settingsValue)
                vendor = matlab.databricks.vendor.Vendor(settingsValue);
            else
                error("DATABRICKS:getVendorFromSettings", "Expected settings vendor value to be a scalar string");
            end
        end
    else
        error("DATABRICKS:getVendorFromSettings", "Expected settings vendor value to be a string not a: %s", class(settingsValue));
    end
end